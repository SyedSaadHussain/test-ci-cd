/* =========================================================
   Section Pager — arrows to navigate within the current unit
   Author: Abdulrhman helper
   Fixes by: ChatGPT
   Policy:
   - يظهر فقط داخل الأقسام المسموحة (maintenance, assets)
   - لا يظهر في الصفحة الرئيسية ولا في صفحة طلب الدعم التقني (support)
   Behavior:
   - Right button (يمين) = Next  (التالي)
   - Left  button (يسار) = Prev  (السابق)
   - تم عكس اتجاه الشيفرون فقط
========================================================= */
(function () {
  "use strict";

  // الأقسام المسموحة بظهور الأسهم داخلها
  var ALLOWED_PREFIXES = [
    "/maintenance/", 
    "/assets/",
    "/visits/",
    "/mosques/",
    "/employees/",
    "/donations/",
    "/dashboard/",
    "/friday/",
    "/service-bills/",
    "/reports/",
    "/filters/",
    "/data-ops/",
    "/faq/",
    "/mobile-guide/"
  ];

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init, { once: true });
  } else {
    init();
  }

  function init() {
    try {
      console.log("[section-pager] Initializing...");
      
      // تجنّب تكرار التركيب إن وُجدت من قبل
      if (document.querySelector(".section-pager")) {
        console.log("[section-pager] Already mounted");
        return;
      }

      var currentUrl = window.location.href.toLowerCase();
      var here = normalizePath(new URL(window.location.href));
      
      console.log("[section-pager] Current URL:", window.location.href);
      console.log("[section-pager] Normalized path:", here);

      // إخفاء دائم في الصفحة الرئيسية
      if (isHomepage(here)) {
        console.log("[section-pager] Homepage detected, skipping");
        return;
      }

      // إخفاء دائم داخل قسم الدعم التقني
      if (currentUrl.indexOf("/support/") !== -1) {
        console.log("[section-pager] Support page detected, skipping");
        return;
      }

      // تحديد القسم بطريقة أفضل لدعم file:// و WebView
      var top = getTopPrefix(here);
      console.log("[section-pager] Detected prefix from path:", top);
      
      // تحقق إضافي من الرابط الكامل للأقسام المهمة
      var isInAllowedSection = false;
      for (var i = 0; i < ALLOWED_PREFIXES.length; i++) {
        if (currentUrl.indexOf(ALLOWED_PREFIXES[i]) !== -1 || top === ALLOWED_PREFIXES[i]) {
          isInAllowedSection = true;
          // استخرج القسم من الرابط مباشرة
          if (currentUrl.indexOf(ALLOWED_PREFIXES[i]) !== -1) {
            top = ALLOWED_PREFIXES[i];
          }
          console.log("[section-pager] Matched allowed prefix:", ALLOWED_PREFIXES[i]);
          break;
        }
      }

      // السماح فقط داخل الأقسام المحددة
      if (!isInAllowedSection) {
        console.log("[section-pager] Not in allowed section, skipping");
        return;
      }
      
      console.log("[section-pager] Using section prefix:", top);

      // المحاولة الأولى: بحسب المجلد الأول (prefix)
      var pages = collectPagesByPrefix(top);

      // Fallback: لو فشلنا أو ما لقينا الصفحة الحالية ضمن القائمة، خذ الروابط من القسم النشط وفلترها بنفس الـ prefix
      var currentIndex = pages.findIndex(function (it) { return it.path === here; });
      if (pages.length <= 1 || currentIndex === -1) {
        console.log("[section-pager] Using fallback collection method");
        pages = collectPagesFromActiveNavFiltered(top);
      }

      if (pages.length <= 1) {
        console.log("[section-pager] Not enough pages found, skipping");
        return;
      }

      currentIndex = pages.findIndex(function (it) { return it.path === here; });
      console.log("[section-pager] Current page index:", currentIndex, "out of", pages.length);
      
      if (currentIndex === -1) {
        console.log("[section-pager] Current page not found in collection, skipping");
        console.log("[section-pager] Looking for:", here);
        console.log("[section-pager] Available pages:", pages.map(function(p) { return p.path; }));
        return;
      }

      var prev = currentIndex > 0 ? pages[currentIndex - 1] : null;
      var next = currentIndex < pages.length - 1 ? pages[currentIndex + 1] : null;

      console.log("[section-pager] Mounting pager with prev:", prev ? prev.title : "none", "next:", next ? next.title : "none");
      mountPager(prev, next);
      bindKeyboard(prev, next);
    } catch (e) {
      console.warn("[section-pager] failed:", e);
    }
  }

  // ========= Utilities =========

  // Normalize to '/folder/name.html' and '/folder/index.html'
  function normalizePath(urlObj) {
    try {
      var p = urlObj.pathname || "/";
      
      // استخراج المسار النسبي من userguide/
      if (p.indexOf("/userguide/") !== -1) {
        p = p.substring(p.indexOf("/userguide/") + 10); // بعد userguide/
      }
      
      if (!p.startsWith("/")) p = "/" + p;         // لدعم file://
      if (p.endsWith("/")) p = p + "index.html";   // فهرس
      // تجاهل الحروف الكبيرة
      return p.toLowerCase();
    } catch {
      return "/";
    }
  }

  function isHomepage(pathname) {
    return pathname === "/index.html";
  }

  // إرجاع '/{first}/' كمجلد أعلى
  function getTopPrefix(pathname) {
    var parts = (pathname || "").split("/").filter(Boolean);
    if (parts.length <= 1) return "/"; // root أو ملف واحد
    return ("/" + parts[0] + "/").toLowerCase();
  }

  // محاولة 1: تجميع الروابط حسب المجلد الأعلى (prefix)
  function collectPagesByPrefix(prefix) {
    var navLinks = Array.from(document.querySelectorAll(".md-nav__link[href]"));
    var seen = new Set();
    var out = [];

    for (var i = 0; i < navLinks.length; i++) {
      var a = navLinks[i];
      var href = a.getAttribute("href");
      if (!href || href.startsWith("#")) continue;

      var url;
      try {
        url = new URL(href, document.baseURI || window.location.href);
      } catch {
        continue;
      }
      
      // تخطي الروابط الخارجية فقط (http/https لنطاقات أخرى)
      if (url.protocol === "http:" || url.protocol === "https:") {
        if (url.origin !== window.location.origin) continue;
      }

      var p = normalizePath(url);
      
      // تحقق أكثر مرونة - إذا كان href أو p يحتوي على القسم
      var matchesPrefix = p.startsWith(prefix) || 
                          href.indexOf(prefix) !== -1 ||
                          p.indexOf(prefix) !== -1;
      
      if (!matchesPrefix) continue;

      if (!seen.has(p)) {
        seen.add(p);
        out.push({ path: p, href: url.href, title: (a.textContent || "").trim() });
      }
    }
    
    console.log("[section-pager] Found", out.length, "pages for prefix:", prefix);
    return out;
  }

  // محاولة 2: الروابط من القسم النشط مع فلترة نفس الـ prefix
  function collectPagesFromActiveNavFiltered(prefix) {
    var scope =
      document.querySelector(".md-nav--primary .md-nav__item--active > nav") ||
      document.querySelector('.md-nav--primary [data-md-component="navigation"]');

    var links = scope
      ? Array.from(scope.querySelectorAll(".md-nav__link[href]"))
      : Array.from(document.querySelectorAll(".md-nav--primary .md-nav__link[href]"));

    var seen = new Set();
    var out = [];

    for (var i = 0; i < links.length; i++) {
      var a = links[i];
      var href = a.getAttribute("href");
      if (!href || href.startsWith("#")) continue;

      var url;
      try {
        url = new URL(href, document.baseURI || window.location.href);
      } catch {
        continue;
      }
      
      // تخطي الروابط الخارجية فقط
      if (url.protocol === "http:" || url.protocol === "https:") {
        if (url.origin !== window.location.origin) continue;
      }

      var p = normalizePath(url);
      
      // تحقق أكثر مرونة
      var matchesPrefix = p.startsWith(prefix) || 
                          href.indexOf(prefix) !== -1 ||
                          p.indexOf(prefix) !== -1;
      
      if (!matchesPrefix) continue; // فلترة بنفس القسم

      if (!seen.has(p)) {
        seen.add(p);
        out.push({ path: p, href: url.href, title: (a.textContent || "").trim() });
      }
    }
    
    console.log("[section-pager] Fallback found", out.length, "pages for prefix:", prefix);
    return out;
  }

  function mountPager(prev, next) {
    var wrap = document.createElement("div");
    wrap.className = "section-pager";
    document.body.appendChild(wrap);

    var leftBtn = createBtn("left", prev);
    var rightBtn = createBtn("right", next);

    if (leftBtn) wrap.appendChild(leftBtn);
    if (rightBtn) wrap.appendChild(rightBtn);
  }

  function createBtn(side, target) {
    var btn = document.createElement("button");
    btn.type = "button";
    btn.className = "section-pager__btn section-pager__btn--" + side;
    btn.setAttribute("aria-hidden", target ? "false" : "true");
    btn.setAttribute("tabindex", target ? "0" : "-1");

    if (!target) {
      btn.classList.add("is-disabled");
      btn.disabled = true;
    } else {
      var label = side === "right"
        ? ("التالي: " + (target.title || "")).trim()
        : ("السابق: " + (target.title || "")).trim();
      btn.setAttribute("title", label);
      btn.setAttribute("aria-label", label);
      btn.addEventListener("click", function () { window.location.href = target.href; });
    }

    // Icon SVG (chevron) — تم عكس الاتجاه هنا فقط
    var svgNS = "http://www.w3.org/2000/svg";
    var svg = document.createElementNS(svgNS, "svg");
    svg.setAttribute("viewBox", "0 0 24 24");
    svg.setAttribute("class", "section-pager__icon");
    var path = document.createElementNS(svgNS, "path");
    path.setAttribute(
      "d",
      side === "right"
        ? "M15 6l-6 6 6 6"   // chevron-left
        : "M9 6l6 6-6 6"     // chevron-right
    );
    path.setAttribute("fill", "none");
    path.setAttribute("stroke", "currentColor");
    path.setAttribute("stroke-width", "2");
    path.setAttribute("stroke-linecap", "round");
    path.setAttribute("stroke-linejoin", "round");
    svg.appendChild(path);
    btn.appendChild(svg);

    return btn;
  }

  function bindKeyboard(prev, next) {
    document.addEventListener("keydown", function (ev) {
      var tag = (ev.target && ev.target.tagName) || "";
      if (/INPUT|TEXTAREA|SELECT/.test(tag)) return;

      if (ev.key === "ArrowLeft" && prev) {
        ev.preventDefault();
        window.location.href = prev.href;
      } else if (ev.key === "ArrowRight" && next) {
        ev.preventDefault();
        window.location.href = next.href;
      }
    });
  }
})();
