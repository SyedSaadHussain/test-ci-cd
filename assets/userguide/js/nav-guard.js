// js/nav-guard.js — v2 (قفل روابط الثيم ومنع إعادة كتابتها)
(function () {
  // مناطق آمنة: هيدرنا + هيدر/سايدبار الثيم
  var SAFE_SCOPES = [
    '.mk-header', '.md-header',
    '.md-sidebar--primary', '.md-sidebar--secondary',
    '.md-nav', '.mk-h-actions'
  ];
  // مناطق الشات بوت (مسموح له يتحكم بروابطه فقط)
  var BOT_SCOPES = ['.cb-panel', '#cb-panel', '.chatbot'];

  function inBotScope(node){
    return !!node && (node.closest(BOT_SCOPES.join(',')) !== null);
  }
  function inSafeScope(node){
    return !!node && (node.closest(SAFE_SCOPES.join(',')) !== null);
  }

  function freezeLinks() {
    SAFE_SCOPES.forEach(function(selector){
      document.querySelectorAll(selector + ' a[href]').forEach(function(a){
        if (inBotScope(a)) return; // لا نلمس روابط الشات بوت
        if (!a.dataset.navHref) {
          a.dataset.navHref = a.getAttribute('href') || '';
        }
      });
    });
  }

  function restoreLink(a){
    if (!a) return;
    if (inBotScope(a)) return;
    if (a.dataset && a.dataset.navHref && a.getAttribute('href') !== a.dataset.navHref){
      a.setAttribute('href', a.dataset.navHref);
    }
  }

  // 1) جمّد الروابط فورًا بعد التحميل
  if (document.readyState !== 'loading') freezeLinks();
  else document.addEventListener('DOMContentLoaded', freezeLinks);

  // 2) راقب أي محاولة لتغيير href ضمن المناطق الآمنة وأعده فورًا
  var obs = new MutationObserver(function(muts){
    muts.forEach(function(m){
      if (m.type === 'attributes' && m.target && m.target.tagName === 'A' && m.attributeName === 'href'){
        if (inSafeScope(m.target)) restoreLink(m.target);
      }
      // لو أُضيفت عناصر جديدة (توسّع القائمة)، جمّدها
      if (m.type === 'childList' && (m.addedNodes||[]).length){
        freezeLinks();
      }
    });
  });
  obs.observe(document.documentElement, { subtree:true, childList:true, attributes:true, attributeFilter:['href'] });

  // 3) على النقر: نضمن استخدام الرابط الأصلي + نمنع أي مستمعات عامة تخرّب المسار
  document.addEventListener('click', function(e){
    var a = e.target && e.target.closest('a');
    if (!a) return;

    if (inBotScope(a)) return; // روابط الشات بوت خارج نطاقنا

    if (inSafeScope(a)) {
      // أعِد href الأصلي قبل أن يتدخل أي سكربت
      restoreLink(a);
      // منع أي مستمعات عامة (رواتر/شيم) من تغيير الوجهة
      e.stopImmediatePropagation();
      // لا نمنع السلوك الافتراضي (لا preventDefault): المتصفح يذهب لوجهته الطبيعية
    }
  }, true); // capture=true حتى نسبق أي سكربتات أخرى
})();
