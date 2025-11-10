// docs/js/header-datetime.js
// يضيف زر الوضع الليلي + شريحة تاريخ تتناوب (هجري/ميلادي) داخل هيدر MkDocs Material
(() => {
  const onReady = (fn) => {
    if (document.readyState !== 'loading') fn();
    else document.addEventListener('DOMContentLoaded', fn);
  };

  const formatGregorian = (d) => {
    try {
      const weekday = new Intl.DateTimeFormat('ar', { weekday: 'long' }).format(d);
      const day = new Intl.DateTimeFormat('ar', { day: '2-digit' }).format(d);
      const month = new Intl.DateTimeFormat('en', { month: 'short' }).format(d);
      return `${weekday} · ${day} ${month}`;
    } catch (e) {
      return d.toLocaleDateString('ar');
    }
  };

  const formatHijriIntl = (d) => {
    const opts = { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' };
    const tries = ['ar-SA-u-ca-islamic-umalqura', 'ar-SA-u-ca-islamic'];
    for (const loc of tries) {
      try { return new Intl.DateTimeFormat(loc, opts).format(d) + 'هـ'; } catch (e) {}
    }
    return null;
  };

  // تحويل تقريبي (Civil) في حال عدم توفّر Intl Islamic
  const hijriFallback = (d) => {
    const toJD = (y, m, day) => {
      if (m <= 2) { y -= 1; m += 12; }
      const A = Math.floor(y / 100);
      const B = 2 - A + Math.floor(A / 4);
      const jd = Math.floor(365.25 * (y + 4716)) + Math.floor(30.6001 * (m + 1)) + day + B - 1524.5;
      return Math.floor(jd + 0.5);
    };
    const jd = toJD(d.getFullYear(), d.getMonth() + 1, d.getDate());
    const days = jd - 1948439; // 1 محرم 1هـ ~ JD 1948439 (تقريبي)
    const hYear = Math.floor((30 * days + 10646) / 10631);
    const firstDayOfYear = 1948439 + Math.floor((10631 * hYear - 10646) / 30);
    const dayOfYear = jd - firstDayOfYear + 1;
    const hMonth = Math.min(12, Math.ceil(dayOfYear / 29.5));
    const monthStart = Math.round((hMonth - 1) * 29.5);
    const hDay = dayOfYear - monthStart;
    const months = ['محرم', 'صفر', 'ربيع الأول', 'ربيع الآخر', 'جمادى الأولى', 'جمادى الآخرة', 'رجب', 'شعبان', 'رمضان', 'شوال', 'ذو القعدة', 'ذو الحجة'];
    const weekday = new Intl.DateTimeFormat('ar', { weekday: 'long' }).format(d);
    const dayStr = new Intl.NumberFormat('ar').format(hDay);
    const yStr = new Intl.NumberFormat('ar').format(hYear);
    return `${weekday} · ${dayStr} ${months[hMonth - 1]} ${yStr}هـ`;
  };

  onReady(() => {
    const headerInner = document.querySelector('.md-header__inner');
    if (!headerInner) return;

    // حاوية عناصر الهيدر (يسار)
    const actions = document.createElement('div');
    actions.className = 'mh-actions';
    actions.setAttribute('dir', 'rtl');

    // زر الوضع الليلي
    const darkBtn = document.createElement('button');
    darkBtn.className = 'icon-btn night-toggle';
    darkBtn.title = 'الوضع الليلي';
    darkBtn.setAttribute('aria-label', 'تبديل الوضع الليلي');

    const iconSpan = document.createElement('span');
    iconSpan.className = 'icon';
    iconSpan.innerHTML = '🌙'; // يمكن استبدالها بـ SVG لاحقًا
    darkBtn.appendChild(iconSpan);

    // شريحة التاريخ
    const datePill = document.createElement('div');
    datePill.className = 'date-pill';
    const label = document.createElement('span');
    label.className = 'date-label';
    datePill.appendChild(label);

    actions.appendChild(darkBtn);
    actions.appendChild(datePill);
    headerInner.appendChild(actions);

    // تفعيل/حفظ الوضع الليلي (مبدئيًا يبدّل Attribute فقط، وأنت لديك/سنضيف CSS لاحقًا)
    const applyNight = (on) => {
      const root = document.documentElement;
      if (on) root.setAttribute('data-night', '1'); else root.removeAttribute('data-night');
      iconSpan.textContent = on ? '☀️' : '🌙';
    };
    let night = localStorage.getItem('site:night') === '1';
    applyNight(night);
    darkBtn.addEventListener('click', () => {
      night = !night;
      localStorage.setItem('site:night', night ? '1' : '0');
      applyNight(night);
    });

    // حساب التاريخين + التناوب
    let showHijri = true;
    const compute = () => {
      const now = new Date();
      const hijriIntl = formatHijriIntl(now);
      const hijri = hijriIntl || hijriFallback(now);
      const greg = formatGregorian(now);
      return { hijri, greg };
    };
    let cache = compute();

    const paint = () => {
      datePill.classList.add('is-fading');
      setTimeout(() => {
        label.textContent = showHijri ? cache.hijri : cache.greg;
        datePill.classList.remove('is-fading');
        showHijri = !showHijri;
      }, 140);
    };

    // البداية: هجري
    label.textContent = cache.hijri;

    // تناوب كل 3.5 ثانية
    setInterval(paint, 3500);

    // تحديث القيم كل دقيقة (حتى ينتقل التاريخ عند منتصف الليل تلقائيًا)
    setInterval(() => { cache = compute(); }, 60 * 1000);
  });
})();
