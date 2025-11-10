import 'package:intl/intl.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model_base.dart';

extension VisitModelBaseHiveExtensions on HiveBoxHelper<VisitModelBase> {
  Future<void> deleteOldRecords() async {
    final visits = await getAll();

    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);

    for (final visit in visits) {
      if (visit.createdAt == null || visit.createdAt!.isBefore(todayDateOnly)) {
        await delete(visit.id);
      }
    }
  }

}
extension VisitModelHiveExtensions on HiveBoxHelper<VisitModel> {


  Future<bool> isPrayerTimeExist(String currentPrayer) async {
    final visits = await getAll();
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    for (final visit in visits) {
      if (visit.startDatetime != null) {
          try {
            final parsedDate = DateTime.parse(visit.startDatetime!);
            final visitDateStr = DateFormat('yyyy-MM-dd').format(parsedDate);

            if (visitDateStr == todayStr && (visit.prayerName == currentPrayer ||
                (currentPrayer == 'duhar' && visit.prayerName == 'jumma'))) {
              return true;
            }
          } catch (e) {

          }
        }
      }
      return false;
    }

  Future<bool> isTodayVisited() async {
    final visits = await getAll();
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    for (final visit in visits) {
      if (visit.startDatetime != null) {
        try {
          final parsedDate = DateTime.parse(visit.startDatetime!);
          final visitDateStr = DateFormat('yyyy-MM-dd').format(parsedDate);

          if (visitDateStr == todayStr) {
            return true;
          }
        } catch (e) {

        }
      }
    }
    return false;
  }
}