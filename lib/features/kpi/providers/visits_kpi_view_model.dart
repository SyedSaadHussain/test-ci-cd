import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';

import '../data/models/visits_draft_counts.dart';
import '../data/repositories/visits_kpi_repository.dart';

class VisitsKpiViewModel with ChangeNotifier {
  final VisitsKpiRepository _repository;
  final UserProvider _userProvider;

  VisitsDraftCounts? _counts;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  VisitsKpiViewModel(this._repository, this._userProvider) {
    _loadAllData();
  }

  VisitsDraftCounts? get counts => _counts;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  Future<void> _loadAllData() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = _userProvider.userProfile.userId;
      await _getObserverDraftVisits(userId);
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      debugPrint('Error loading visits KPI data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _getObserverDraftVisits(int userId) async {
    try {
      _counts = await _repository.getObserverDraftVisits(userId);
      _hasError = false;
      _errorMessage = null;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to load data';
      _counts = null;
      debugPrint('Error loading visits draft counts: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    await _loadAllData();
  }

  // Keep public load method for compatibility
  Future<void> load() => _loadAllData();
}


