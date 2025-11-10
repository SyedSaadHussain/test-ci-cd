import 'package:flutter/material.dart';
import 'validation_rules.dart'; // for ValidationIssue

class ValidationController extends ChangeNotifier {
  final Map<String, String> _errors = {};

  void  setIssues(List<ValidationIssue> issues) {
    _errors
      ..clear()
      ..addEntries(issues.map((e) => MapEntry(e.field, e.message)));
    notifyListeners();
  }

  String? errorOf(String field) => _errors[field];

  void clearError(String field) {
    if (_errors.remove(field) != null) notifyListeners();
  }

  void setError(String key, String message) {
    _errors[key] = message;
    notifyListeners();
  }

  void clearAll() {
    if (_errors.isNotEmpty) {
      _errors.clear();
      notifyListeners();
    }
  }

  bool get hasErrors => _errors.isNotEmpty;
}

/// Inherited wrapper so children can read errors and rebuild automatically.
class ValidationScope extends InheritedNotifier<ValidationController> {
  const ValidationScope({
    Key? key,
    required ValidationController controller,
    required Widget child,
  }) : super(key: key, notifier: controller, child: child);

  static ValidationController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ValidationScope>()?.notifier;
}
