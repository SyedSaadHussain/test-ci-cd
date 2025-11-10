/* chatbot-shim.js — افتراضيات آمنة تمنع أخطاء undefined (متوافقة مع file://) */
(function () {
  'use strict';

  if (typeof window.CHATBOT_VERSION === 'undefined' || !window.CHATBOT_VERSION) {
    window.CHATBOT_VERSION = 'v1';
  }

  // قاعدة صفحات الدليل: فاضية على file:// (بدون سلاش أولي)
  if (typeof window.CHATBOT_DOCS_BASE === 'undefined') {
    window.CHATBOT_DOCS_BASE = '';
  } else {
    window.CHATBOT_DOCS_BASE = String(window.CHATBOT_DOCS_BASE || '').replace(/^\/+/, '');
  }

  // مسار بيانات البوت (بدون سلاش أولي)
  if (typeof window.CHATBOT_JSON_BASE === 'undefined' || !window.CHATBOT_JSON_BASE) {
    window.CHATBOT_JSON_BASE = 'chatbot';
  } else {
    window.CHATBOT_JSON_BASE = String(window.CHATBOT_JSON_BASE).replace(/^\/+/, '');
  }

  if (typeof window.CHATBOT_USE_INAPP_ROUTER === 'undefined') {
    window.CHATBOT_USE_INAPP_ROUTER = false;
  }
  if (typeof window.CHATBOT_OPEN_EXTERNAL_IN_WEBVIEW === 'undefined') {
    window.CHATBOT_OPEN_EXTERNAL_IN_WEBVIEW = true;
  }
})();
