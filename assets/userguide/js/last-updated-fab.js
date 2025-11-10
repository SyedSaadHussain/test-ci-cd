// docs/js/last-updated-fab.js
(function () {
  const TEXT = 'آخر تحديث 21 أكتوبر 2025';

  function ensureFab(text){
    let fab = document.getElementById('lu-fab');
    if(!fab){
      fab = document.createElement('button');
      fab.id = 'lu-fab';
      fab.type = 'button';
      fab.className = 'lu-fab';
      fab.setAttribute('aria-live','polite');

      const rotor = document.createElement('span');
      rotor.className = 'lu-rotor';
      fab.appendChild(rotor);

      document.body.appendChild(fab);
    }
    fab.querySelector('.lu-rotor').textContent = text;
    return fab;
  }

  // إخفاء عند ظهور Overlay فقط — بدون أي قياسات (لا ارتداد)
  function watchOverlayVisibility(fab){
    const overlay = document.querySelector('.md-overlay');
    if(!overlay) return;
    const recompute = () => {
      try{
        const st = getComputedStyle(overlay);
        const visible = st.visibility!=='hidden' && st.pointerEvents!=='none' &&
                        st.opacity!=='0' && overlay.offsetParent!==null;
        fab.classList.toggle('lu-fab--hidden', !!visible);
      }catch(_){}
    };
    const mo = new MutationObserver(recompute);
    mo.observe(overlay,{attributes:true,attributeFilter:['class','style','aria-hidden','hidden']});
    recompute();
  }

  // استثناء صفحة CreatingTicket
  function shouldSkip(){
    const path = decodeURIComponent((location.pathname||'')).toLowerCase();
    const tokens = ['creatingticket','creating-ticket','creating%20ticket','creating_ticket'];
    if(tokens.some(t=>path.includes(t))) return true;
    const h1 = document.querySelector('.md-content h1, .md-typeset h1');
    const title = (document.title||'').toLowerCase();
    const h1t = (h1 && h1.textContent || '').toLowerCase();
    if(h1t.includes('creating ticket') || title.includes('creating ticket')) return true;
    if((h1t.includes('إنشاء')&&h1t.includes('تذ')) || (title.includes('إنشاء')&&title.includes('تذ'))) return true;
    return false;
  }

  function mount(){
    if(shouldSkip()){ const old=document.getElementById('lu-fab'); if(old) old.remove(); return; }
    const fab = ensureFab(TEXT);
    watchOverlayVisibility(fab);
  }

  if(window.document$){ document$.subscribe(()=>setTimeout(mount,0)); }
  else if(document.readyState==='loading'){ document.addEventListener('DOMContentLoaded',mount); }
  else{ mount(); }
})();
