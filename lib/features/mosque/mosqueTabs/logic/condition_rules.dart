import 'package:localize_and_translate/localize_and_translate.dart';

class ConditionOption {
  final String code;   // DB / API value
  final String label;  // UI label (pre-i18n)
  const ConditionOption(this.code, this.label);
}

/// Odoo selection you shared
class MosqueConditionData {
  static const options = <ConditionOption>[
    ConditionOption('existing_mosque',           'Existing Mosque'),
    ConditionOption('abandoned_mosque',          'Abandoned Mosque'),
    ConditionOption('mosque_under_construction', 'Mosque Project Under Construction'),
    ConditionOption('mosque_under_restoration',  'Mosque Project Under Restoration'),
  ];

  static const _codes = {
    'existing_mosque',
    'abandoned_mosque',
    'mosque_under_construction',
    'mosque_under_restoration',
  };

  /// If older rows stored the *label*, convert to the code.
  static String? normalizeToCode(String? v) {
    if (v == null || v.isEmpty) return null;
    if (_codes.contains(v)) return v; // already a code
    final s = v.toLowerCase().trim();
    for (final o in options) {
      if (o.label.toLowerCase() == s) return o.code;
    }
    return v; // unknown - keep as-is
  }

  static String labelOf(String? code) {
    final match = options.firstWhere(
          (o) => o.code == (code ?? ''),
      orElse: () => const ConditionOption('', ''),
    );
    return match.label.isEmpty ? '' : match.label.tr();
  }

  /// Show structure/prayer tabs only in these two states:
  static bool showDependentTabs(String? code) =>
      code == 'existing_mosque' || code == 'abandoned_mosque';
}
