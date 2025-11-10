// docs/js/footer-legal.js
(function () {
  // نص التنبيه داخل المودال
  const LEGAL_TEXT =
    'لا يجوز دون الحصول على إذن خطي من المطور استخدام أي مادة من مواد هذا الدليل أو استنساخها أو نقلها كليا أو جزئيا — في أي شكل وبأي وسيلة، سواء بطرق إلكترونية أو آلية، بما في ذلك الاستنساخ الفوتوغرافي، أو التسجيل أو استخدام أي نظام من نظم تخزين المعلومات واسترجاعها';

  // ابحث عن حاوية حقوق النشر في فوتر ثيم Material
  function findCopyrightEl() {
    // الأكثر شيوعًا في Material 9+
    let el =
      document.querySelector('.md-footer .md-copyright__highlight') ||
      document.querySelector('.md-footer .md-copyright') ||
      document.querySelector('footer .md-copyright') ||
      document.querySelector('footer [class*=copyright]');
    return el || null;
  }

  // لفّ نص الحقوق داخل trigger مع كلاسّاتنا (لأنيميشن اللمعان + ripple)
  function wrapAsTrigger(node) {
    if (!node) return null;

    // لا تكرار
    if (node.querySelector('.footer-legal__trigger')) {
      return node.querySelector('.footer-legal__trigger');
    }

    const host = document.createElement('span');
    host.className = 'footer-legal__host';

    const trigger = document.createElement('span');
    trigger.className = 'footer-legal__trigger';
    trigger.tabIndex = 0;

    // انقل الأطفال الأصليين للـtrigger
    while (node.firstChild) trigger.appendChild(node.firstChild);

    host.appendChild(trigger);
    node.appendChild(host);
    return trigger;
  }

  // أنشئ المودال (مرة واحدة)
  function ensureModal() {
    let modal = document.getElementById('legal-modal');
    if (modal) return modal;

    modal = document.createElement('div');
    modal.className = 'legal-modal';
    modal.id = 'legal-modal';
    modal.setAttribute('hidden', '');

    modal.innerHTML = `
      <div class="legal-modal__backdrop" data-close="1"></div>
      <div class="legal-modal__dialog" role="dialog" aria-modal="true">
        <div class="legal-modal__header">
          <button type="button" class="legal-modal__close" aria-label="إغلاق" data-close="1">×</button>
        </div>
        <div class="legal-modal__body">
          ${LEGAL_TEXT}
        </div>
      </div>
    `;

    document.body.appendChild(modal);

    // إغلاق بالضغط على الخلفية أو زر × أو زر Esc
    modal.addEventListener('click', (e) => {
      const t = e.target;
      if (t && t.getAttribute && t.getAttribute('data-close') === '1') hideModal();
    });
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') hideModal();
    });

    return modal;
  }

  function showModal() {
    const modal = ensureModal();
    modal.removeAttribute('hidden');
    document.documentElement.style.overflow = 'hidden';
  }
  function hideModal() {
    const modal = document.getElementById('legal-modal');
    if (!modal) return;
    modal.setAttribute('hidden', '');
    document.documentElement.style.overflow = '';
  }

  // Ripple عند الضغط
  function makeRipple(e, trigger) {
    const r = document.createElement('span');
    r.className = 'footer-legal__ripple';
    const rect = trigger.getBoundingClientRect();
    const x = (e && e.clientX ? e.clientX : rect.left + rect.width / 2) - rect.left;
    const y = (e && e.clientY ? e.clientY : rect.top + rect.height / 2) - rect.top;
    r.style.setProperty('--x', x + 'px');
    r.style.setProperty('--y', y + 'px');
    trigger.appendChild(r);
    r.addEventListener('animationend', () => r.remove(), { once: true });
  }

  function mount() {
    const copyEl = findCopyrightEl();
    if (!copyEl) return;

    const trigger = wrapAsTrigger(copyEl);
    if (!trigger) return;

    // أنيميشن اللمعان شغّال من CSS ::before، هنا فقط نهتم بالـripple والفتح
    trigger.addEventListener('click', (e) => {
      makeRipple(e, trigger);
      showModal();
    });
    trigger.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') {
        e.preventDefault();
        makeRipple(null, trigger);
        showModal();
      }
    });
  }

  // دعم تنقّل صفحات MkDocs Material
  if (window.document$) {
    document$.subscribe(() => setTimeout(mount, 0));
  } else if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', mount);
  } else {
    mount();
  }
})();
