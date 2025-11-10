// docs/js/hero-glue.js  (v3.12 — zero-flicker glue at top; hysteresis + instant apply)
(function () {
  const root   = document.documentElement;
  const header = document.querySelector('.md-header');
  const inner  = document.querySelector('.md-content__inner');
  const hero   =
    inner && inner.querySelector(
      ':scope > :is(.hero,#hero,.home-hero,.swiper,.swiper-container,.hero-full), ' +
      ':scope > .md-typeset > :is(.hero,#hero,.home-hero,.swiper,.swiper-container,.hero-full)'
    );
  if (!header || !inner || !hero) return;

  root.classList.add('has-hero');

  // --- Guard CSS (لا نلمس ملفاتك) ---
  (function injectGuardCSS(){
    const id = 'hero-glue-guards';
    if (document.getElementById(id)) return;
    const s = document.createElement('style');
    s.id = id;
    s.textContent = `
      html,body,.md-main{ overscroll-behavior-y: contain; }
      .has-hero .md-main__inner, .has-hero .md-content__inner{ margin-top:0 !important; padding-top:0 !important; }
      .hero, #hero, .home-hero, .hero-full, .swiper, .swiper-container{ overflow-anchor: none; }
    `;
    document.head.appendChild(s);
  })();

  // نظافة قبل الهيرو لتفادي collapse
  (function stripPrev() {
    let n = hero.previousElementSibling;
    while (n && (n.tagName === 'P' || n.matches(':empty'))) {
      n.style.display = 'none';
      n.style.margin = n.style.padding = '0';
      n = hero.previousElementSibling;
    }
  })();

  // إعدادات رسومية
  inner.style.paddingTop = '0';
  Object.assign(hero.style, {
    position: 'relative',
    transition: 'none',
    willChange: 'transform',
    backfaceVisibility: 'hidden',
    WebkitTransform: 'translateZ(0)'
  });

  // ==== Helpers ====
  function headerH() {
    const h = Math.ceil(header.getBoundingClientRect().height || 84);
    root.style.setProperty('--md-header-height', h + 'px');
    return h;
  }
  function rubberOffset() {
    if (!window.visualViewport) return 0;
    return Math.max(0, Math.round(visualViewport.offsetTop || 0)); // iOS pull-down
  }

  // موضع الهيرو الأصلي داخل المستند (بدون أي transform)
  let heroTopDoc0 = 0;
  function recalcHeroTopDoc() {
    const was = glued;
    if (was) hero.style.transform = ''; // قياس دقيق
    heroTopDoc0 = Math.round(hero.getBoundingClientRect().top + window.scrollY);
    if (was) glueOn(true);              // ارجاع الحالة فورًا
  }

  // Hysteresis thresholds عند الأعلى لمنع النتوء
  function thresholds() {
    const H = headerH();
    return {
      enter: H + 12,  // للدخول في وضع الإلصاق
      exit:  H + 28   // للخروج منه (أكبر قليلًا)
    };
  }

  const EPS = 1;
  let glued = false;
  let lastShift = 0;
  let ticking = false;
  let bottomLock = false;

  function computeShiftFromCache() {
    const H = headerH();
    const headerBottomDoc = window.scrollY + H;
    const gap = heroTopDoc0 - headerBottomDoc;

    // تعويض rubber-band ومنع أي إزاحة موجبة (لا نحرك لأسفل إطلاقًا)
    let shift = Math.round(-gap - rubberOffset());
    if (shift > 0) shift = 0;            // clamp up
    if (shift < -2048) shift = -2048;    // clamp down (حارس)
    return shift;
  }

  // تطبيق التحويل (دوماً translate3d لتثبيت الطبقة)
  function applyShift(shift, instant) {
    if (Math.abs(shift - lastShift) > EPS || instant) {
      // ملاحظة: حتى عند 0 نحافظ على transform لمنع تفليشة الطبقة
      hero.style.transform = `translate3d(0, ${shift}px, 0)`;
      lastShift = shift;
    }
  }

  function glueOn(instant = false) {
    const shift = computeShiftFromCache();
    applyShift(shift, instant);
    glued = true;
  }

  function glueOff() {
    if (!glued && lastShift === 0) return;
    hero.style.transform = ''; // خروجه طبيعيًا من أعلى الشاشة
    lastShift = 0;
    glued = false;
  }

  function shouldGlue() {
    const th = thresholds();
    // rubberOffset>0 يعني نسحب لأعلى -> نعتبره دائمًا داخل منطقة الإلصاق
    if (rubberOffset() > 0) return true;
    const y = window.scrollY;
    return glued ? (y <= th.exit) : (y <= th.enter);
  }

  function atBottom() {
    const vvH = (window.visualViewport ? visualViewport.height : window.innerHeight);
    const docH = Math.ceil(document.documentElement.scrollHeight);
    const y = Math.ceil(window.scrollY);
    return y + vvH >= docH - 1;
  }

  function onScrollLite() {
    // لو نحن قرب الأعلى نحدّث فورًا (بدون rAF) للقضاء على التفليشة
    if (shouldGlue()) {
      bottomLock = false;
      glueOn(true);        // update now, same tick
      return;
    }
    // قفل أسفل الصفحة يمنع إعادة اللصق مباشرة بعد الارتداد
    if (atBottom()) {
      bottomLock = true;
      glueOff();
      return;
    }
    if (bottomLock) { glueOff(); return; }

    // بعيد عن الأعلى: لا حاجة لتحديث فوري—ضبط خفيف بـ rAF لو لزم
    if (ticking) return;
    ticking = true;
    requestAnimationFrame(() => {
      ticking = false;
      if (shouldGlue()) glueOn(true);
      else glueOff();
    });
  }

  function init() {
    headerH();
    recalcHeroTopDoc();
    glueOn(true);       // بداية ملتصق فورًا
    onScrollLite();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init, { once: true });
  } else {
    init();
  }

  // نبضات بعد التحميل لضبط صور/خطوط
  window.addEventListener('load', () => {
    recalcHeroTopDoc(); glueOn(true); onScrollLite();
    setTimeout(() => { recalcHeroTopDoc(); onScrollLite(); }, 120);
    setTimeout(() => { recalcHeroTopDoc(); onScrollLite(); }, 400);
  }, { once: true });

  // تكيف مع تغيير المقاس/الاتجاه
  window.addEventListener('resize', () => {
    headerH(); recalcHeroTopDoc(); onScrollLite();
  }, { passive: true });

  window.addEventListener('orientationchange', () => {
    setTimeout(() => { headerH(); recalcHeroTopDoc(); onScrollLite(); }, 120);
  }, { passive: true });

  // الرجوع من صفحة فرعية / إظهار التبويب
  window.addEventListener('pageshow', () => { headerH(); recalcHeroTopDoc(); onScrollLite(); });
  document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'visible') { headerH(); recalcHeroTopDoc(); onScrollLite(); }
  });

  // مراقبة تغيّر أبعاد الهيدر/الهيرو
  if ('ResizeObserver' in window) {
    const ro = new ResizeObserver(() => { headerH(); recalcHeroTopDoc(); onScrollLite(); });
    ro.observe(header);
    ro.observe(hero);
  }

  // مستمع تمرير (خفيف) + تعقب visualViewport لتعويض المطاطية
  window.addEventListener('scroll', onScrollLite, { passive: true });
  if (window.visualViewport) {
    visualViewport.addEventListener('scroll', onScrollLite, { passive: true });
    visualViewport.addEventListener('resize', onScrollLite, { passive: true });
  }
})();
