import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';

import '../data/models/mosque_counts.dart';
import '../data/models/mosques_types_counts.dart';
import '../data/models/verification_counts.dart';
import '../data/repositories/mosque_indicators_repository.dart';

class MosqueIndicatorsViewModel with ChangeNotifier {
  final MosqueIndicatorsRepository _repository;
  final UserProvider _userProvider;

  MosqueCounts? _mosqueCounts;
  VerificationCounts? _verificationCounts;
  MosquesTypesCounts? _mosquesTypesCounts;
  bool _isLoading = false;
  bool _hasMosqueCountsError = false;
  bool _hasVerificationCountsError = false;
  bool _hasMosquesTypesCountsError = false;

  MosqueIndicatorsViewModel(this._repository, this._userProvider) {
    _loadAllData();
  }

  MosqueCounts? get mosqueCounts => _mosqueCounts;
  VerificationCounts? get verificationCounts => _verificationCounts;
  MosquesTypesCounts? get mosquesTypesCounts => _mosquesTypesCounts;
  bool get isLoading => _isLoading;
  bool get hasMosqueCountsError => _hasMosqueCountsError;
  bool get hasVerificationCountsError => _hasVerificationCountsError;
  bool get hasMosquesTypesCountsError => _hasMosquesTypesCountsError;

  Future<void> _loadAllData() async {
    _isLoading = true;
    _hasMosqueCountsError = false;
    _hasVerificationCountsError = false;
    _hasMosquesTypesCountsError = false;
    notifyListeners();

    try {
      final userId = _userProvider.userProfile.userId;

      await Future.wait([
        _loadMosqueCounts(userId),
        _loadVerificationCounts(userId),
        _loadMosquesTypesCounts(userId),
      ], eagerError: false);
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMosqueCounts(int userId) async {
    try {
      _mosqueCounts = await _repository.getMosqueCounts(userId);
      _hasMosqueCountsError = false;
    } catch (e) {
      _hasMosqueCountsError = true;
      _mosqueCounts = null;
      debugPrint('Error loading mosque counts: $e');
    }
  }

  Future<void> _loadVerificationCounts(int userId) async {
    try {
      _verificationCounts = await _repository.getVerificationCounts(userId);
      _hasVerificationCountsError = false;
    } catch (e) {
      _hasVerificationCountsError = true;
      _verificationCounts = null;
      debugPrint('Error loading verification counts: $e');
    }
  }

  Future<void> _loadMosquesTypesCounts(int userId) async {
    try {
      _mosquesTypesCounts = await _repository.getMosquesTypesCounts(userId);
      _hasMosquesTypesCountsError = false;
    } catch (e) {
      _hasMosquesTypesCountsError = true;
      _mosquesTypesCounts = null;
      debugPrint('Error loading mosques types counts: $e');
    }
  }

  Future<void> refresh() async {
    await _loadAllData();
  }
}
