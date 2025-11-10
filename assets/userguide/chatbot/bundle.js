// docs/chatbot/bundle.js
// =====================================================
// روابط صفحات "وحدة صيانة المساجد" الجديدة (use_directory_urls:false ⇒ .html)
const MAINT_LINKS = {
  intro          : "/maintenance/01-intro.html",
  contractor     : "/maintenance/03-entry.html",
  companyMember  : "/maintenance/02-company-member.html",
  insertContract : "/maintenance/04-reviewer.html",
  approver       : "/maintenance/05-approver.html"
};
// =====================================================

window.__CB_DATA__ = [].concat(
  /* === محتوى chatbot.json (إن وجد) === */ [ /* … (فارغ) … */ ],

  /* === employees.json === */ [
    {
      "intent": "employees_hub",
      "isHub": true,
      "answer": "<div class='kb-links'><a class='kb-link' href='/employees/02-add-level.html'>➕ إضافة منسوب</a><a class='kb-link' href='/employees/04-transfer.html'>🔄 نقل منسوب</a><a class='kb-link' href='/employees/05-update.html'>✏ تحديث بيانات منسوب</a><a class='kb-link' href='/employees/03-assign-mosques.html'>🏛 إسناد المساجد للمراقبين</a><a class='kb-link' href='/employees/06-resignation.html'>📤 الاستقالات</a></div>",
      "options": [
        { "title": "إضافة منسوب", "link": "/employees/02-add-level.html" },
        { "title": "نقل منسوب", "link": "/employees/04-transfer.html" },
        { "title": "تحديث بيانات منسوب", "link": "/employees/05-update.html" },
        { "title": "إسناد المساجد للمراقبين", "link": "/employees/03-assign-mosques.html" },
        { "title": "الاستقالات", "link": "/employees/06-resignation.html" }
      ],
      "keywordsExact": ["منسوب","المنسوب","منسوبين","المنسوبين","إدارة المنسوبين","ادارة المنسوبين","موظف","الموظف","الموظفين"]
    },
    /* … بقية عناصر employees … */
  ],

  /* === visits.json === */ [
    {
      "intent": "visits_hub",
      "isHub": true,
      "options": [
        { "title": "📄 أنواع النماذج", "link": "/visits/types.html" },
        { "title": "🔎 زيارة المتابعة", "link": "/visits/assign.html" },
        { "title": "✅ اعتماد الزيارات", "link": "/visits/approval.html" },
        { "title": "📊 تقارير الزيارات", "link": "/visits/reports.html" }
      ],
      "keywordsExact": ["زيارة","زياره","الزيارة","الزياره","الزيارات","زيارات","زياراتي"]
    },
    /* … بقية عناصر visits … */
  ],

  /* === maintenance.json (الجديدة) === */ [
    {
      "intent": "maint_hub",
      "isHub": true,
      "options": [
        { "title": "📘 مقدمة وحدة صيانة المساجد", "link": MAINT_LINKS.intro },
        { "title": "🧾 تسجيل متعهد صيانة (مدخل الصيانة)", "link": MAINT_LINKS.contractor },
        { "title": "👤 تسجيل عضو شركة صيانة", "link": MAINT_LINKS.companyMember },
        { "title": "📄 إدراج/مراجعة عقد صيانة (مدقق الصيانة)", "link": MAINT_LINKS.insertContract },
        { "title": "✅ اعتماد عقد صيانة (معتمد الصيانة)", "link": MAINT_LINKS.approver }
      ],
      "keywordsExact": ["صيانة","الصيانة","وحدة صيانة","عقد صيانة","عقود الصيانة","نظام الصيانة","إدارة الصيانة","ادارة الصيانة","صيان","متعهد صيانة","عضو شركة صيانة"]
    },
    /* … بقية عناصر maintenance … */
  ],

  /* === filters.json (إن وجد) === */ [ /* … */ ]
);

// توافق رجعي
window._CB_DATA_ = window.__CB_DATA__;
