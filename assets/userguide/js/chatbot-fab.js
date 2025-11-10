/* =========================================================
   Chatbot FAB + Panel — FILE:// SAFE
   - بلا أي مسارات/طلبات شبكة.
   - لا يعرّف window.CBTyping إذا كان موجودًا (يتجنّب التعارض).
   - إن لم يوجد CBTyping من chatbot.js، ينشئ Fallback داخلي فقط.
   ========================================================= */
(function () {
  const FAB_ID     = 'cb-fab';
  const PANEL_ID   = 'cb-panel';
  const OVERLAY_ID = 'cb-overlay';

  // عناصر يجب تجاهلها في "إغلاق بالنقر خارجًا" حتى لا نكسر توغّلرات الصفحة
  const NO_GLOBAL_CLOSE_SEL =
    (window.CB_NO_GLOBAL_CLOSE && String(window.CB_NO_GLOBAL_CLOSE)) ||
    '#guideMoreBtn, #faqMoreBtn, #guide-more-wrap, #faq-more-wrap, .show-more-btn, [data-no-global-close]';

  function injectUI () {
    // لا تكرار
    if (document.getElementById(FAB_ID) &&
        document.getElementById(PANEL_ID) &&
        document.getElementById(OVERLAY_ID)) return;

    /* ===== الزر العائم (أيقونة GADD-like) ===== */
    const fab = document.createElement('div');
    fab.id = FAB_ID;
    fab.className = 'cb-fab';
    fab.setAttribute('aria-controls', PANEL_ID);
    fab.setAttribute('aria-expanded', 'false');
    fab.setAttribute('title', 'المساعد');

    // أيقونة البوت
    fab.innerHTML = `
      <div class="mujib_chat_icon" aria-hidden="true">
        <div class="icon_inner-cont">
          <div class="left_ear"></div>
          <div class="right_ear"></div>

          <div class="eyes_background"></div>
          <div class="eyes_cont">
            <span class="eye"></span>
            <span class="eye"></span>
          </div>

          <div class="smile"></div>
          <div class="chatbot_corner"></div>
          <div class="antenna"></div>
          <div class="head"></div>
        </div>
      </div>
    `;

    /* ===== الـ Overlay ===== */
    const overlay = document.createElement('div');
    overlay.id = OVERLAY_ID;
    overlay.className = 'cb-overlay';
    overlay.setAttribute('aria-hidden', 'true');
    overlay.dataset.open = '0';

    /* ===== اللوحة ===== */
    const panel = document.createElement('div');
    panel.id = PANEL_ID;
    panel.className = 'cb-panel cb--jad';
    panel.setAttribute('role', 'dialog');
    panel.setAttribute('aria-modal', 'false');
    panel.setAttribute('aria-labelledby', 'cb-title');
    panel.dataset.open = '0';

    panel.innerHTML = `
      <div class="cb-header">
        <div class="cb-jad-brand">
          <div class="cb-jad-logo" role="img" aria-label="شعار وكالة شؤون المساجد"></div>
          <div class="cb-jad-headings">
            <div id="cb-title" class="cb-jad-title">ASK ME - اسألني</div>
            <div class="cb-jad-subtitle">Ask me - اسألني</div>
          </div>
        </div>

        <div class="cb-jad-controls">
          <button class="cb-jad-icon" type="button" aria-label="خيارات" data-action="menu">⋮</button>
          <button class="cb-jad-icon cb-minimize" type="button" aria-label="طي اللوحة">⌄</button>
        </div>
      </div>

      <div class="cb-body">
        <div id="chat-messages" class="chatbot-messages"></div>
      </div>

      <div class="cb-input">
        <input id="chat-input" type="text" placeholder="اكتب سؤالك..." />
        <button type="button" class="chatbot-send-button">إرسال</button>
      </div>
    `;

    document.body.appendChild(fab);
    document.body.appendChild(overlay);
    document.body.appendChild(panel);

    /* ===== تمرير/سلوك الرسائل + مؤشّر الكتابة ===== */
    (function initScroll(panelEl){
      const chat = panelEl.querySelector('#chat-messages');
      if (!chat) return;

      // تهيئة الحاوية
      chat.classList.add('chatbot-scrollable');
      Object.assign(chat.style, {
        height:'100%', overflowY:'auto', WebkitOverflowScrolling:'touch',
        display:'flex', flexDirection:'column', rowGap:'10px'
      });

      const BOTTOM_THRESHOLD = 24;
      const isAtBottom = () =>
        (chat.scrollHeight - chat.scrollTop - chat.clientHeight) <= BOTTOM_THRESHOLD;

      const scrollToBottom = (smooth = true) => {
        const top = chat.scrollHeight;
        if (!smooth) chat.scrollTop = top;
        else chat.scrollTo({ top, behavior: 'smooth' });
      };

      // زر الرجوع لآخر رسالة
      let jumpBtn = chat.querySelector('#jump-to-latest');
      if (!jumpBtn) {
        jumpBtn = document.createElement('button');
        jumpBtn.id = 'jump-to-latest';
        jumpBtn.type = 'button';
        jumpBtn.className = 'jump-to-latest';
        jumpBtn.textContent = 'الرجوع للرسالة الأخيرة ↓';
        jumpBtn.hidden = true;
        chat.appendChild(jumpBtn);
      }
      const updateJump = () => { jumpBtn.hidden = isAtBottom(); };
      chat.addEventListener('scroll', updateJump, { passive: true });
      jumpBtn.addEventListener('click', () => scrollToBottom(true));

      /* ====== Typing indicator (متوافق مع chatbot.js) ====== */
      // إن وُجد CBTyping عالمي من chatbot.js نستخدمه كما هو
      // وإلا ننشئ Fallback محلي لا يكتب على window.CBTyping
      const FallbackTyping = (function () {
        let el = null, startAt = 0, timer = 0, minMs = 1200;
        function ensure() {
          if (el && el.isConnected) return el;
          el = document.createElement('div');
          el.className = 'cb-typing'; // نفس الكلاس المستخدم في chatbot.js
          el.innerHTML = `
            <i class="cb-typing-logo" aria-hidden="true"></i>
            <span class="cb-typing-dots"><span></span><span></span><span></span></span>
          `;
          chat.appendChild(el);
          return el;
        }
        return {
          show(){
            const n = chat.querySelector('.cb-typing') || ensure();
            n.style.display = 'inline-flex';
            startAt = performance.now();
            if (isAtBottom()) scrollToBottom(true);
          },
          hide(){
            const elapsed = performance.now() - startAt;
            const wait = Math.max(minMs - elapsed, 0);
            clearTimeout(timer);
            timer = setTimeout(() => {
              const n = chat.querySelector('.cb-typing');
              if (n) n.remove();
            }, wait);
          },
          isVisible(){ return !!chat.querySelector('.cb-typing'); }
        };
      })();

      const Typing = window.CBTyping || FallbackTyping;

      // مراقبة DOM: اظهار عند إضافة رسالة مستخدم، إخفاء عند إضافة رسالة بوت
      const mo = new MutationObserver(muts => {
        const auto = isAtBottom();
        muts.forEach(m => {
          m.addedNodes.forEach(node => {
            if (node.nodeType !== 1) return;

            if (node.matches?.('.chatbot-message.user-message') ||
                node.querySelector?.('.chatbot-message.user-message')) {
              Typing.show();
            }
            if (node.matches?.('.chatbot-message.bot-message') ||
                node.querySelector?.('.chatbot-message.bot-message')) {
              Typing.hide();
            }

            const media = node.querySelectorAll?.('img, video') ?? [];
            let pending = media.length;
            const done = () => { if (--pending === 0 && auto) scrollToBottom(true); };
            if (pending) {
              media.forEach(el => {
                if ((el.tagName === 'IMG' && el.complete) ||
                    (el.tagName === 'VIDEO' && el.readyState >= 2)) { done(); }
                else {
                  el.addEventListener('load', done, { once: true });
                  el.addEventListener('loadeddata', done, { once: true });
                  el.addEventListener('error', done, { once: true });
                }
              });
            } else if (auto) { scrollToBottom(true); }
          });
        });
        updateJump();
      });
      mo.observe(chat, { childList: true, subtree: true });

      // fallback سريع: عند الإرسال أو Enter فعّل المؤشّر
      const inputEl = panelEl.querySelector('#chat-input');
      const sendBtn = panelEl.querySelector('.chatbot-send-button');
      sendBtn?.addEventListener('click', () => Typing.show());
      inputEl?.addEventListener('keydown', (e) => { if (e.key === 'Enter') Typing.show(); });

      const ro = new ResizeObserver(() => { if (isAtBottom()) scrollToBottom(false); updateJump(); });
      ro.observe(chat);

      requestAnimationFrame(() => scrollToBottom(false));
    })(panel);

    /* ===== فتح/إغلاق ===== */
    const inputEl   = panel.querySelector('#chat-input');
    const minBtn    = panel.querySelector('.cb-minimize');

    const isOpen = () => panel.dataset.open === '1';
    const openPanel = () => {
      panel.dataset.open = '1';
      overlay.dataset.open = '1';
      overlay.setAttribute('aria-hidden', 'false');
      fab.setAttribute('aria-expanded', 'true');
      setTimeout(() => inputEl && inputEl.focus({ preventScroll: true }), 0);
    };
    const closePanel = () => {
      panel.dataset.open = '0';
      overlay.dataset.open = '0';
      overlay.setAttribute('aria-hidden', 'true');
      fab.setAttribute('aria-expanded', 'false');
    };
    const togglePanel = () => (isOpen() ? closePanel() : openPanel());

    fab.addEventListener('click', togglePanel);
    minBtn?.addEventListener('click', (e) => { e.stopPropagation(); closePanel(); });
    overlay.addEventListener('click', closePanel);

    // لا تُغلق عند النقر على عناصر توغّلر معيّنة في الصفحة
    const shouldIgnoreGlobalClose = (t) => {
      try { return !!(t && t.closest && t.closest(NO_GLOBAL_CLOSE_SEL)); }
      catch { return false; }
    };

    document.addEventListener('click', (e) => {
      if (!isOpen()) return;
      if (e.defaultPrevented) return;
      const t = e.target;
      if (shouldIgnoreGlobalClose(t)) return;
      if (!panel.contains(t) && !fab.contains(t)) closePanel();
    });

    document.addEventListener('keydown', (e) => { if (e.key === 'Escape' && isOpen()) closePanel(); });

    console.log('[FAB] UI injected');
    // نخبر البوت أن الواجهة جاهزة (والبوت أصلاً عنده polling)
    window.dispatchEvent(new CustomEvent('cb:ui-ready'));
  }

  // دعم MkDocs Material (SPA)
  if (window.document$ && typeof window.document$.subscribe === 'function') {
    window.document$.subscribe(() => injectUI());
  } else if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', injectUI);
  } else {
    injectUI();
  }
})();
