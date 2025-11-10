/* Masajid – WebView-safe video fixes (drop-in, no app changes)
   v1.0
   - يمنع قصّ الفيديو (contain) ويضبط الفل-سكرين
   - يخفي زر التشغيل الكبير بعد البدء
   - يخفّف "التفليشة" عند الخروج من الفل-سكرين
   - يحاول تلقائياً تشغيل نسخ أعلى جودة (-1080 ثم -720) إن وُجدت بنفس الاسم
   - لا يلمس شيئاً خارج .section-box .vframe > video
*/
(function () {
  // ========= 0) حقن CSS مخصّص للفيديو فقط =========
  function injectStyles() {
    if (document.getElementById('masajid-video-style')) return;
    var css = `
/* منع القصّ وضبط الفل-سكرين + إخفاء زر التشغيل الكبير بعد البدء */
.md-content .section-box .vframe>video{
  object-fit: contain !important;
  object-position: center center !important;
  background:#000;
  backface-visibility:hidden;
  transform:translateZ(0);
}
.md-content .section-box .vframe>video:fullscreen,
.md-content .section-box .vframe>video:-webkit-full-screen{
  width:100vw !important;
  height:100vh !important;
  max-width:none !important;
  max-height:none !important;
  object-fit:contain !important;
  object-position:center center !important;
  background:#000 !important;
}
/* إخفاء زر التشغيل الكبير بعد البدء (WebKit) */
.vframe video.is-playing::-webkit-media-controls-start-playback-button{display:none !important;}
.vframe video.is-playing::-webkit-media-controls-overlay-play-button{display:none !important;}

/* تقليل "النفضة/الفلاش" بعد الخروج من فل سكرين */
.md-content, .md-main{ overscroll-behavior:contain; }
    `.trim();
    var s = document.createElement('style');
    s.id = 'masajid-video-style';
    s.textContent = css;
    document.head.appendChild(s);
  }

  // ========= 1) إخفاء زر التشغيل الكبير بعد البدء =========
  function hideBigPlayOnStart(video) {
    function mark()   { video.classList.add('is-playing'); if (video.hasAttribute('poster')) video.removeAttribute('poster'); }
    function unmark() { video.classList.remove('is-playing'); }
    ['play','playing'].forEach(ev => video.addEventListener(ev, mark,   { passive: true }));
    ['pause','ended'].forEach(ev => video.addEventListener(ev, unmark,  { passive: true }));
  }

  // ========= 2) توليد روابط الجودات بناءً على اسم الملف الأصلي =========
  function deriveQualityUrls(src) {
    try {
      var u = new URL(src, location.href);
      var path = u.pathname;
      if (!/\.mp4(\?|#|$)/i.test(path)) return { original: src, q1080: null, q720: null };

      // إن كان الاسم يحتوي -480/-720/-1080 نرجعه للاسم الأساسي
      var qless = path.replace(/-(480|720|1080)\.mp4$/i, '.mp4');
      var base = src.replace(path, qless);

      var q1080 = base.replace(/\.mp4(\?|#|$)/i, '-1080.mp4');
      var q720  = base.replace(/\.mp4(\?|#|$)/i, '-720.mp4');

      return { original: src, q1080, q720 };
    } catch (e) {
      return { original: src, q1080: null, q720: null };
    }
  }

  // ========= 3) محاولة تشغيل جودة أعلى (1080 ثم 720) ثم الرجوع للأصلي =========
  function forceBetterQuality(video, originalSrc) {
    var urls = deriveQualityUrls(originalSrc);
    var tried = new Set();

    function trySet(src) {
      if (!src || tried.has(src)) return false;
      tried.add(src);

      var onErr = function () {
        video.removeEventListener('error', onErr, true);
        next();
      };

      video.addEventListener('error', onErr, true);
      video.src = src;
      try { video.load(); } catch(_) {}
      return true;
    }

    function next() {
      if (trySet(urls.q1080)) return;  // جرّب 1080 أولاً
      if (trySet(urls.q720))  return;  // ثم 720
      trySet(urls.original);           // ثم رجوع للأصلي
    }

    next();
  }

  // ========= 4) تهيئة فيديو واحد =========
  function initOne(video) {
    if (!video || video.__masajid_init) return;
    video.__masajid_init = true;

    // خصائص تشغيل موحدة (لا تغيّر سلوكك الحالي ولكن توحّد التجرِبة)
    video.setAttribute('playsinline','');
    video.setAttribute('webkit-playsinline','');
    video.setAttribute('preload','metadata');
    video.setAttribute('controls','');
    video.setAttribute('disablepictureinpicture','');
    video.setAttribute('controlsList','noremoteplayback nodownload');

    hideBigPlayOnStart(video);

    // انتظر حتى يضع سكربت الصفحة src ثم طبّق تحسين الجودة
    var applied = false;
    function applyOnce() {
      if (applied) return;
      var current = video.currentSrc || video.src;
      if (current) {
        applied = true;
        forceBetterQuality(video, current); // 1080 ← 720 ← الأصلي
      }
    }

    window.addEventListener('load', applyOnce, { once: true });
    var mo = new MutationObserver(applyOnce);
    mo.observe(video, { attributes: true, attributeFilter: ['src'] });
    video.addEventListener('play', applyOnce, { once: true, passive: true });
  }

  // ========= 5) تقليل تفليشة ما بعد فل سكرين =========
  document.addEventListener('fullscreenchange', function(){
    setTimeout(function(){
      document.documentElement.style.scrollBehavior = 'auto';
      void document.body.offsetHeight; // reflow
      document.documentElement.style.scrollBehavior = '';
    }, 90);
  }, { passive: true });

  // ========= 6) تشغيل عام =========
  function boot() {
    injectStyles();
    // الفيديوهات ضمن البنية الحالية لديك
    var vids = document.querySelectorAll('.vframe video');
    vids.forEach(initOne);

    // لو أضيف محتوى لاحقاً
    var rootMo = new MutationObserver(function(muts){
      muts.forEach(function(m){
        if (!m.addedNodes) return;
        for (var i=0;i<m.addedNodes.length;i++){
          var n = m.addedNodes[i];
          if (!(n && n.nodeType === 1)) continue;
          if (n.matches && n.matches('.vframe video')) initOne(n);
          var more = n.querySelectorAll ? n.querySelectorAll('.vframe video') : [];
          if (more && more.length) more.forEach(initOne);
        }
      });
    });
    rootMo.observe(document.body, { childList: true, subtree: true });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot, { once: true });
  } else {
    boot();
  }
})();
