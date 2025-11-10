
import 'package:mosque_management_system/core/constants/config.dart';

class VisitDefaults {
  static const String declarationText = "أقر بأنه تم مراجعة جميع البيانات وأتحمل كامل المسؤولية عن صحتها";
  static const String draftStateValue = 'draft';
  static const int defaultIdVisitRegular = 312;
  static const int defaultIdVisitOndemand = 334;
  static const int defaultIdVisitJumma = 357;
  static const int defaultIdVisitFemale = 379;
  static const int defaultIdVisitLand = 423;
  static const int defaultIdVisitEid = 401;
  static const int supervisorVisitIdOndemand = 345;
  static const int compressedValue = 50;
  static const int supervisorId = 27;
  static const int observerId = 28;
  static const int allowPrayerHours = Config.disableValidation?10
      :1;
}