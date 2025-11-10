/* ضغطة واحدة لتبديل الليلي + حفظ التفضيل (الأيقونة ثابتة) */
(function(){
  const html = document.documentElement;
  const LS_NIGHT = 'night';

  try{
    if (localStorage.getItem(LS_NIGHT) === '1'){
      html.setAttribute('data-night','1');
    }
  }catch(e){}

  function init(){
    const btn = document.getElementById('night-toggle-btn');
    if (!btn) return;

    btn.addEventListener('click', ()=>{
      const on = html.hasAttribute('data-night');
      if (on){
        html.removeAttribute('data-night');
        try{ localStorage.setItem(LS_NIGHT,'0'); }catch(e){}
      } else {
        html.setAttribute('data-night','1');
        try{ localStorage.setItem(LS_NIGHT,'1'); }catch(e){}
      }
    });
  }

  if (document.readyState === 'loading'){
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
