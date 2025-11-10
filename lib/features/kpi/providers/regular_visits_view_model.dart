import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/core/providers/user_provider.dart';
import 'package:mosque_management_system/features/kpi/data/models/regular_visit_stats.dart';
import 'package:mosque_management_system/features/kpi/data/repositories/visits_kpi_repository.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class RegularVisitsViewModel extends ChangeNotifier {
  final VisitsKpiRepository _repository;
  final UserProvider _userProvider;

  RegularVisitsViewModel({
    required VisitsKpiRepository repository,
    required UserProvider userProvider,
  })  : _repository = repository,
        _userProvider = userProvider;

  RegularVisitStats? _stats;
  List<DailyKpi> _dailyKpis = [];
  bool _isLoading = false;
  bool _hasStatsError = false;
  bool _hasDailyProgressError = false;
  int? _currentMonth;

  RegularVisitStats? get stats => _stats;
  List<DailyKpi> get dailyKpis => _dailyKpis;
  bool get isLoading => _isLoading;
  bool get hasStatsError => _hasStatsError;
  bool get hasDailyProgressError => _hasDailyProgressError;
  int? get currentMonth => _currentMonth;

  /// Calculate the date to send based on selected month
  /// If selected month is current month, use current date
  /// Otherwise, use first day of the selected month (in current year)
  String _calculateDateForMonth(int month) {
    final now = DateTime.now();
    final currentYear = now.year;
    
    // Check if selected month is the current month
    if (month == now.month) {
      // Use current date
      return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    } else {
      // Use first day of the selected month (assume current year)
      return '${currentYear}-${month.toString().padLeft(2, '0')}-01';
    }
  }

  Future<void> loadStats(int month) async {
    // If already loaded for this month, skip
    if (_currentMonth == month && _stats != null && !_isLoading) {
      return;
    }

    _isLoading = true;
    _hasStatsError = false;
    _hasDailyProgressError = false;
    _currentMonth = month;
    notifyListeners();

    try {
      final userId = _userProvider.userProfile.userId;
      
      // Calculate the date to send based on business logic
      final date = _calculateDateForMonth(month);

      // Load both stats and daily progress in parallel - don't fail fast
      await Future.wait([
        _loadStats(userId, date),
        _loadDailyProgress(userId, month),
      ], eagerError: false);
    } catch (e, stackTrace) {
      debugPrint('Error in loadStats: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'method': 'loadStats',
          'userId': _userProvider.userProfile.userId,
          'month': month,
        }),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadStats(int userId, String date) async {
    try {
      _stats = await _repository.getRegularVisitStats(
        userId: userId,
        date: date,
      );
      _hasStatsError = false;
    } catch (e, stackTrace) {
      _hasStatsError = true;
      _stats = null;
      debugPrint('Error loading regular visit stats: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'method': '_loadStats',
          'userId': userId,
          'date': date,
        }),
      );
    }
  }

  Future<void> _loadDailyProgress(int userId, int month) async {
    try {
      _dailyKpis = await _repository.getRegularDailyProgress(
        userId: userId,
        month: month,
      );
      _hasDailyProgressError = false;
    } catch (e, stackTrace) {
      _hasDailyProgressError = true;
      _dailyKpis = [];
      debugPrint('Error loading regular daily progress: $e');
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
        hint: Hint.withMap({
          'method': '_loadDailyProgress',
          'userId': userId,
          'month': month,
        }),
      );
    }
  }

  void clearData() {
    _stats = null;
    _dailyKpis = [];
    _hasStatsError = false;
    _hasDailyProgressError = false;
    _currentMonth = null;
    notifyListeners();
  }
}

