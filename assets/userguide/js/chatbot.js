// Chatbot JS — نسخة صديقة لبيئة file:// داخل التطبيق
(function () {
  'use strict';

  if (window.__MASAJID_BOT_BOOTED__) return;
  window.__MASAJID_BOT_BOOTED__ = true;

  // === إعدادات عامّة ===
  const VERSION   = (typeof window.CHATBOT_VERSION === "string" && window.CHATBOT_VERSION) || "v1";
  const DOCS_BASE = (typeof window.CHATBOT_DOCS_BASE === "string" ? window.CHATBOT_DOCS_BASE : "");
  const JSON_BASE = (typeof window.CHATBOT_JSON_BASE === "string" && window.CHATBOT_JSON_BASE) || "chatbot";
  const USE_INAPP_ROUTER         = !!window.CHATBOT_USE_INAPP_ROUTER;
  const OPEN_EXTERNAL_IN_WEBVIEW = window.CHATBOT_OPEN_EXTERNAL_IN_WEBVIEW !== false;

  const EXACT_MATCH_ONLY   = true;
  const IGNORE_JSON_ANSWER = true;

  const join = (a,b) => (a ? String(a).replace(/\/+$/, '') + '/' : '') + String(b || '').replace(/^\/+/, '');

  // —— احسب جذر الـsite بثبات ——
  function computeSiteRoot() {
    // 1) من اسكربت البندل: /chatbot/bundle.js
    const s = document.querySelector('script[src$="chatbot/bundle.js"],script[src*="/chatbot/bundle.js"]');
    if (s && s.src) {
      return new URL('../', s.src).toString(); // parent of /chatbot/
    }
    // 2) من JSON_BASE (chatbot/ …) ثم طلع مستوى
    const base = String(JSON_BASE || 'chatbot').replace(/^\/+|\/+$/g, '');
    try {
      const u = new URL(base + '/', document.baseURI);
      return new URL('../', u).toString();
    } catch (_) {}
    // 3) احتياطي: مجلد الصفحة الحالية
    let href = (document.baseURI || location.href || '').replace(/[#?].*$/, '');
    return href.replace(/[^/]+$/, ''); // directory
  }
  const __SITE_ROOT = computeSiteRoot();

  // اكسبورت للتشخيص
  window.__SITE_ROOT = __SITE_ROOT;

  // بناء URL لأي أصل داخل الموقع (JSON/JS/HTML…)
  const __U = (p) => new URL(String(p || '').replace(/^\/+/, ''), __SITE_ROOT).toString();
  window.__U = __U; // (اختياري للتشخيص)

  // ===== جلب JSON مع 3 محاولات: fetch -> XHR -> IFRAME =====
  async function getJSON(p) {
    const url = __U(p);
    try {
      const r = await fetch(url, { cache: "no-store" });
      if (!r.ok) throw new Error(`HTTP ${r.status} for ${url}`);
      return await r.json();
    } catch (_) { /* fallback */ }

    if (location.protocol === 'file:') {
      try {
        const data = await new Promise((res, rej) => {
          const xhr = new XMLHttpRequest();
          xhr.open("GET", url, true);
          xhr.onreadystatechange = () => {
            if (xhr.readyState === 4) {
              if (xhr.status === 0 || (xhr.status >= 200 && xhr.status < 300)) {
                try { res(JSON.parse(xhr.responseText)); } catch (e) { rej(e); }
              } else rej(new Error(`XHR ${xhr.status} for ${url}`));
            }
          };
          xhr.onerror = rej;
          xhr.send();
        });
        return data;
      } catch (_) { /* continue */ }
    } else {
      throw new Error(`Fetch failed for ${url}`);
    }

    return await new Promise((resolve, reject) => {
      const frame = document.createElement('iframe');
      frame.style.display = 'none'; frame.setAttribute('aria-hidden', 'true');
      let done = false;
      const cleanup = () => { try { frame.remove(); } catch(_){} };
      const timer = setTimeout(() => { if (!done){ done = true; cleanup(); reject(new Error(`IFRAME timeout for ${url}`)); } }, 5000);
      frame.onload = () => {
        if (done) return;
        try {
          const doc = frame.contentDocument || frame.contentWindow?.document;
          const txt = doc && doc.body ? (doc.body.innerText || doc.body.textContent || '') : '';
          cleanup(); clearTimeout(timer); done = true;
          if (!txt) return reject(new Error(`IFRAME empty for ${url}`));
          resolve(JSON.parse(txt));
        } catch (e) { cleanup(); clearTimeout(timer); done = true; reject(e); }
      };
      frame.onerror = () => { if (!done){ cleanup(); clearTimeout(timer); done = true; reject(new Error(`IFRAME error for ${url}`)); } };
      frame.src = url;
      document.body.appendChild(frame);
    });
  }

  // —— أدوات نصية للمطابقة العربية ——
  function normalizeText(text) {
    if (!text) return "";
    return text.toLowerCase()
      .replace(/\u0640/g, "")
      .replace(/[ًٌٍَُِّْ]/g, "")
      .replace(/[إأآا]/g, "ا")
      .replace(/ة/g, "ه")
      .replace(/[ئءؤ]/g, "ء")
      .replace(/[^ء-ي0-9a-z\s]/gi, " ")
      .replace(/\s+/g, " ")
      .trim();
  }

  // إضافة .html تلقائيًا (يحافظ على ?query و #hash)
  function ensureHtmlExt(href) {
    if (!href || /^(?:[a-z]+:)?\/\//i.test(href) || /^mailto:|^tel:/i.test(href) || href.startsWith('#')) return href;
    const m = String(href).match(/^([^?#]+)(.*)$/);
    const path = m ? m[1] : String(href);
    const tail = m ? m[2] : '';
    if (/\.[a-z0-9]+$/i.test(path) || path.endsWith('/')) return path + tail;
    return path + '.html' + tail;
  }

  // إذا ما فيه DOCS_BASE نخلي الروابط النسبية من نفس الجذر الذي حسبناه
  function asRelativeIfNoBase(path) {
    if (DOCS_BASE) return path;
    return path.startsWith("/") ? `.${path}` : path;
  }

  // ——— حل الروابط: يدعم http/https/file:// + .html + anchors ———
  function resolveLink(link) {
    if (!link) return "#";
    const raw = String(link).trim();

    if (/^(?:https?:)?\/\//i.test(raw) || /^mailto:|^tel:/i.test(raw) || raw.startsWith('#')) return raw;

    // مطلق من الجذر ⇒ ابنِ على __SITE_ROOT (دائمًا)
    if (raw.startsWith("/")) {
      const withSlash = ensureHtmlExt(raw);
      return new URL(withSlash.replace(/^\//, ""), __SITE_ROOT).toString();
    }

    // نسبي ⇒ ابنِ على __SITE_ROOT أيضًا (ليكون ثابتًا مهما كانت الصفحة الحالية)
    const rel = ensureHtmlExt(raw.replace(/^\/+/, ''));
    return new URL(asRelativeIfNoBase(rel), __SITE_ROOT).toString();
  }

  // اكسبورت للفحص في الكونسول
  window.__resolveLink = resolveLink;

  // فتح الروابط في تبويب جديد فقط لما يلزم
  function shouldOpenNewTab(itemOrOption, url) {
    if (itemOrOption && typeof itemOrOption.openInNewTab === "boolean") return itemOrOption.openInNewTab;
    const isExternal = /^(?:https?:)?\/\//i.test(url);
    const isWebView  = !!(window.ReactNativeWebView || window.webkit?.messageHandlers);
    if (isWebView && !OPEN_EXTERNAL_IN_WEBVIEW) return false;
    return isExternal;
  }
  function targetAttrs(itemOrOption, url) {
    return shouldOpenNewTab(itemOrOption, url) ? ' target="_blank" rel="noopener"' : '';
  }

  // تمرير إلى الأسفل
  function forceBottom(el){
    if (!el) return;
    el.scrollTop = el.scrollHeight;
    requestAnimationFrame(() => { el.scrollTop = el.scrollHeight; });
  }

  function renderLinkOnly(item){
    let html = "";
    if (Array.isArray(item.options) && item.options.length) {
      html += '<ul style="margin:8px 0 0; padding-inline-start:18px;">';
      for (const o of item.options) {
        const url = resolveLink(o.link);
        html += `<li><a href="${url}"${targetAttrs(o, url)}>${o.title}</a></li>`;
      }
      html += "</ul>";
    }
    if (item.link) {
      const url = resolveLink(item.link);
      html += `<a href="${url}"${targetAttrs(item, url)} style="display:inline-block;margin-top:8px;text-decoration:none;">🔗 عرض الصفحة</a>`;
    }
    return html || "—";
  }
  function buildResponse(item) {
    if (IGNORE_JSON_ANSWER) return renderLinkOnly(item);
    let html = "";
    if (item.answer) html += `<p>${item.answer}</p>`;
    if (Array.isArray(item.options) && item.options.length) {
      html += '<ul style="margin:8px 0 0; padding-inline-start:18px;">';
      for (const o of item.options) {
        const url = resolveLink(o.link);
        html += `<li><a href="${url}"${targetAttrs(o, url)}>${o.title}</a></li>`;
      }
      html += "</ul>";
    }
    if (item.link) {
      const url = resolveLink(item.link);
      html += `<a href="${url}"${targetAttrs(item, url)} style="display:inline-block;margin-top:8px;text-decoration:none;">🔗 عرض الصفحة</a>`;
    }
    return html || "—";
  }

  function getExact(item){   return Array.isArray(item.keywordsExact) ? item.keywordsExact : (Array.isArray(item.keywords) ? item.keywords : []); }
  function getGeneral(item){ return Array.isArray(item.keywordsGeneral) ? item.keywordsGeneral : []; }

  let chatbotData = [];
  function findAnswer(userInput) {
    const q = normalizeText(userInput);
    if (!q) return "عذرًا، لم أتمكن من العثور على إجابة لسؤالك.";

    if (EXACT_MATCH_ONLY) {
      for (const item of chatbotData) {
        for (const kw of getExact(item)) {
          if (q === normalizeText(kw)) {
            const hasContent = (item.link && item.link.trim()) || (Array.isArray(item.options) && item.options.length);
            if (hasContent) return buildResponse(item);
          }
        }
      }
      const hub = chatbotData.find(it =>
        it.isHub &&
        ((it.link && it.link.trim()) || (Array.isArray(it.options) && it.options.length)) &&
        [...getExact(it), ...getGeneral(it)].some(k => normalizeText(k) === q)
      );
      if (hub) return buildResponse(hub);
      return "عذرًا، لم أتمكن من العثور على إجابة لسؤالك.";
    }

    // (وضع المطابقة المرنة غير مُفعّل)
    for (const item of chatbotData) {
      for (const kw of getExact(item)) {
        if (q === normalizeText(kw)) return buildResponse(item);
      }
    }
    const hubMatches = [];
    for (const item of chatbotData.filter(x => x.isHub)) {
      for (const kw of [...getExact(item), ...getGeneral(item)]) {
        const k = normalizeText(kw);
        if (!k) continue;
        if (q.includes(k) || k.includes(q)) {
          const score = q.includes(k) ? k.length : q.length - 0.1;
          hubMatches.push({ item, score });
        }
      }
    }
    if (hubMatches.length) {
      hubMatches.sort((a,b)=>b.score-a.score);
      return buildResponse(hubMatches[0].item);
    }
    let best = { score: 0, item: null };
    for (const item of chatbotData.filter(x => !x.isHub)) {
      for (const kw of [...getExact(item), ...getGeneral(item)]) {
        const k = normalizeText(kw);
        if (!k) continue;
        if (q.includes(k) || k.includes(q)) {
          const score = q.includes(k) ? k.length : q.length - 0.1;
          if (score > best.score) best = { score, item };
        }
      }
    }
    if (best.item) return buildResponse(best.item);
    const fallback = chatbotData.find(x => x.isDefault);
    if (fallback) return buildResponse(fallback);
    return "عذرًا، لم أتمكن من العثور على إجابة لسؤالك.";
  }

  function getUI() {
    return {
      chatMessages: document.getElementById("chat-messages"),
      inputField:   document.getElementById("chat-input"),
      sendButton:   document.querySelector(".chatbot-send-button")
    };
  }

  const Typing = (function () {
    let el = null;
    function create() {
      const t = document.createElement('div');
      t.className = 'cb-typing';
      t.innerHTML = `<i class="cb-typing-logo" aria-hidden="true"></i><span class="cb-typing-dots"><span></span><span></span><span></span></span>`;
      return t;
    }
    function killLegacy() { document.querySelectorAll('.cb-typing-wrap').forEach(n => n.remove()); }
    return {
      show(container) {
        const chatMessages = container || document.getElementById("chat-messages");
        if (!chatMessages) return;
        killLegacy();
        if (!el) el = create();
        if (!el.isConnected) {
          chatMessages.appendChild(el);
          chatMessages.scrollTop = chatMessages.scrollHeight;
        }
      },
      hide() { if (el && el.parentNode) el.parentNode.removeChild(el); killLegacy(); }
    };
  })();
  window.CBTyping = Typing;

  function boot() {
    const { chatMessages, inputField, sendButton } = getUI();
    if (!chatMessages || !inputField || !sendButton) return false;

    chatMessages.innerHTML = `<div class="chatbot-message bot-message">👋 مرحبًا بك في نظام "مساجد" — كيف أقدر أساعدك اليوم؟</div>`;

    const mo = new MutationObserver(() => {
      const lastBot = chatMessages.querySelector('.chatbot-message.bot-message:last-of-type');
      if (lastBot) Typing.hide();
    });
    mo.observe(chatMessages, { childList: true });

    function addMessage(content, type) {
      const list = chatMessages;
      if (!list) return;
      if (type === 'bot') Typing.hide();
      const div = document.createElement("div");
      div.className = `chatbot-message ${type}-message`;
      div.innerHTML = content;
      list.appendChild(div);
      forceBottom(list);
    }

    function sendMessage() {
      const userInput = inputField.value.trim();
      if (!userInput) return;

      addMessage(userInput, "user");
      inputField.value = "";

      Typing.show(chatMessages);

      const replyHTML = findAnswer(userInput);
      const textLen = replyHTML.replace(/<[^>]+>/g, '').length;
      const delay = Math.max(700, Math.min(1400, 18 * textLen));

      setTimeout(() => { Typing.hide(); addMessage(replyHTML, "bot"); }, delay);
    }

    const JSON_BASE_CLEAN = String(JSON_BASE || 'chatbot').replace(/^\/+/, '');
    function mergeArrays(arrays){ return arrays.reduce((a,c)=> (Array.isArray(c)? a.concat(c): a), []); }
    function loadBundle() {
      return new Promise((resolve) => {
        if (Array.isArray(window.__CB_DATA__) && window.__CB_DATA__.length) return resolve(true);
        const s = document.createElement('script');
        s.src = __U(`${JSON_BASE_CLEAN}/bundle.js?v=${encodeURIComponent(VERSION)}`);
        s.onload  = () => resolve(Array.isArray(window.__CB_DATA__) && window.__CB_DATA__.length);
        s.onerror = () => resolve(false);
        (document.head || document.documentElement).appendChild(s);
      });
    }

    loadBundle().then((ok) => {
      if (ok) { chatbotData = window.__CB_DATA__; forceBottom(chatMessages); return; }
      const chatbotFiles = [
        `${JSON_BASE_CLEAN}/chatbot.json?v=${encodeURIComponent(VERSION)}`,
        `${JSON_BASE_CLEAN}/employees.json?v=${encodeURIComponent(VERSION)}`,
        `${JSON_BASE_CLEAN}/visits.json?v=${encodeURIComponent(VERSION)}`,
        `${JSON_BASE_CLEAN}/maintenance.json?v=${encodeURIComponent(VERSION)}`,
        `${JSON_BASE_CLEAN}/filters.json?v=${encodeURIComponent(VERSION)}`
      ];
      Promise.all(chatbotFiles.map(p => getJSON(p).catch(() => [])))
        .then(arrays => { chatbotData = mergeArrays(arrays); forceBottom(chatMessages); })
        .catch(err => { console.error("❌ فشل تحميل ملفات الشات بوت:", err); addMessage("❌ حدث خطأ أثناء تحميل البيانات. حاول لاحقًا.", "bot"); });
    });

    sendButton.addEventListener("click", sendMessage);
    inputField.addEventListener("keydown", e => { if (e.key === "Enter" && !e.shiftKey) { e.preventDefault(); sendMessage(); } });

    (function () {
      const root = document.documentElement;
      const msgBox = chatMessages;
      function applyKeyboardInset() {
        const vv = window.visualViewport;
        if (!vv) { root.style.setProperty('--kb', '0px'); return; }
        const kb = Math.max(0, window.innerHeight - vv.height);
        root.style.setProperty('--kb', kb + 'px');
      }
      function keepAtBottom() { if (msgBox) { msgBox.scrollTop = msgBox.scrollHeight; } }
      if (window.visualViewport) {
        window.visualViewport.addEventListener('resize', () => { applyKeyboardInset(); requestAnimationFrame(keepAtBottom); });
        window.visualViewport.addEventListener('scroll',  applyKeyboardInset);
      }
      window.addEventListener('orientationchange', () => { setTimeout(() => { applyKeyboardInset(); keepAtBottom(); }, 250); });
      const realFocus = inputField.focus.bind(inputField);
      inputField.focus = function (options = {}) { options.preventScroll = true; realFocus(options); };
      requestAnimationFrame(keepAtBottom);
      applyKeyboardInset();
    })();

    console.log('[BOT] booted');
    return true;
  }

  function waitAndBoot() {
    if (boot()) return;
    let tries = 0;
    const MAX_TRIES = 300;
    (function poll() {
      if (boot()) return;
      if (++tries > MAX_TRIES) { console.warn('[BOT] UI not found yet. still waiting…'); tries = 0; }
      requestAnimationFrame(poll);
    })();
  }

  window.addEventListener('cb:ui-ready', waitAndBoot, { once: true });
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', waitAndBoot, { once: true });
  } else {
    waitAndBoot();
  }
})();
