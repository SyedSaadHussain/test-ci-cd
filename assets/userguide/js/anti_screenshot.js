// anti_screenshot.js — Blackout-only guard for MkDocs (no app changes)

// ===== ثابتات =====
const GUARD = {
  DUR_MS: 1600,           // مدة السواد
  HIDE_DELAY_MS: 50,      // تأخير بسيط قبل إخفاء الغطاء بعد العودة
  DEMO_HOLD_MS: 700,      // مدة الضغط المطوّل للهوت-زون
  DEMO_ZONE_SIZE: 28,     // حجم الهوت-زون
  Z: 2147483647,
  LS_KEY: 'MK_GUARD_DEMO' // مفتاح حفظ وضع العرض في localStorage
};

// قراءة وضع العرض من التخزين المحلي
function isDemoOn() { try { return localStorage.getItem(GUARD.LS_KEY) === '1'; } catch { return false; } }
function setDemo(on){ try { localStorage.setItem(GUARD.LS_KEY, on?'1':'0'); } catch {} }

// ===== CSS خفيف =====
(function injectCSS(){
  if (document.getElementById('anti-capture-style')) return;
  const s = document.createElement('style');
  s.id = 'anti-capture-style';
  s.textContent = `
    #capture-guard-cover{
      position:fixed; inset:0; background:#000; display:none;
      pointer-events:none; z-index:${GUARD.Z};
      transform:translateZ(0); backface-visibility:hidden; will-change:opacity;
    }
    #guard-demo-zone{
      position:fixed; left:0; top:0; width:${GUARD.DEMO_ZONE_SIZE}px; height:${GUARD.DEMO_ZONE_SIZE}px;
      opacity:0; z-index:${GUARD.Z}; pointer-events:auto; touch-action:none; display:none;
    }
  `;
  document.head.appendChild(s);
})();

// ===== عناصر الطبقة =====
function coverEl(){
  let el = document.getElementById('capture-guard-cover');
  if(!el){ el = document.createElement('div'); el.id='capture-guard-cover'; el.setAttribute('aria-hidden','true'); el.setAttribute('role','presentation'); document.body.appendChild(el); }
  return el;
}
let hideTimer=null;
function blackout(ms=GUARD.DUR_MS){
  const c = coverEl();
  c.style.display='block';
  clearTimeout(hideTimer);
  hideTimer = setTimeout(()=>{
    if(!document.hidden && document.hasFocus()) c.style.display='none';
    else setTimeout(()=>{ if(!document.hidden && document.hasFocus()) c.style.display='none'; }, GUARD.HIDE_DELAY_MS);
  }, ms);
}

// ===== أحداث يُمكن للويب التقاطها =====
function onBlur(){ blackout(); }
function onFocus(){ setTimeout(()=>{ if(!document.hidden) coverEl().style.display='none'; }, GUARD.HIDE_DELAY_MS); }
function onVis(){ document.hidden ? blackout() : onFocus(); }
function onBeforePrint(){ blackout(); }
function onAfterPrint(){ onFocus(); }
function onPageHide(){ blackout(); }
function onPageShow(){ onFocus(); }
function onFullscreen(){ blackout(); }

// ===== وضع العرض (للاختبار بدون تعديل التطبيق) =====
function ensureDemoZone(){
  let z = document.getElementById('guard-demo-zone');
  if(!z){ z=document.createElement('div'); z.id='guard-demo-zone'; document.body.appendChild(z); }
  z.style.display = isDemoOn() ? 'block' : 'none';
  return z;
}
function mountDemo(){
  // هوت-زون (ضغط مطوّل أعلى-يسار)
  const z = ensureDemoZone();
  let t=null;
  const start=()=>{ clearTimeout(t); t=setTimeout(()=>blackout(), GUARD.DEMO_HOLD_MS); };
  const cancel=()=> clearTimeout(t);
  z.addEventListener('mousedown', start);
  z.addEventListener('mouseup', cancel);
  z.addEventListener('mouseleave', cancel);
  z.addEventListener('touchstart', start, {passive:true});
  z.addEventListener('touchend', cancel);
  z.addEventListener('touchcancel', cancel);

  // اختصارات:
  // Shift + D  => تشغيل/إيقاف وضع العرض (يحفظ في localStorage)
  // Shift + S  => سواد فوري (للالتقاط)
  document.addEventListener('keydown', (e)=>{
    const key=(e.key||'').toUpperCase();
    if(e.shiftKey && key==='D'){
      const on = !isDemoOn();
      setDemo(on);
      ensureDemoZone(); // لتحديث العرض
    } else if(e.shiftKey && key==='S'){
      if(isDemoOn()) blackout();
    }
  });
}

// ===== Init =====
(function init(){
  coverEl();
  // سواد تلقائي للحالات المدعومة
  window.addEventListener('blur', onBlur);
  window.addEventListener('focus', onFocus);
  document.addEventListener('visibilitychange', onVis);
  document.addEventListener('webkitvisibilitychange', onVis);
  window.addEventListener('beforeprint', onBeforePrint);
  window.addEventListener('afterprint', onAfterPrint);
  window.addEventListener('pagehide', onPageHide);
  window.addEventListener('pageshow', onPageShow);
  document.addEventListener('fullscreenchange', onFullscreen);

  // وضع العرض للاختبار
  mountDemo();
})();
