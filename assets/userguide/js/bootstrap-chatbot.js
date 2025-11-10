/* bootstrap-chatbot.js — تهيئة تدعم file:// وتقرأ base_url من main.html */
(function () {
  'use strict';
  var BASE = (typeof window.DOCS_BASE === 'string') ? window.DOCS_BASE : '';

  function join(a, b) {
    if (!a) return String(b).replace(/^\/+/, '');
    return a.replace(/\/+$/, '') + '/' + String(b).replace(/^\/+/, '');
  }

  if (typeof window.CHATBOT_VERSION === 'undefined') window.CHATBOT_VERSION = 'v1';
  if (typeof window.CHATBOT_DOCS_BASE === 'undefined') window.CHATBOT_DOCS_BASE = BASE || '';
  if (typeof window.CHATBOT_JSON_BASE === 'undefined') window.CHATBOT_JSON_BASE = join(BASE, 'chatbot');
  if (typeof window.CHATBOT_USE_INAPP_ROUTER === 'undefined') window.CHATBOT_USE_INAPP_ROUTER = false;
  if (typeof window.CHATBOT_OPEN_EXTERNAL_IN_WEBVIEW === 'undefined') window.CHATBOT_OPEN_EXTERNAL_IN_WEBVIEW = true;
})();
