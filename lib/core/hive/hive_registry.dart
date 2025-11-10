import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/hive/hive_boxes.dart';
import 'package:mosque_management_system/core/hive/hive_helper.dart';
import 'package:mosque_management_system/core/models/cached_item.dart';
// import 'package:mosque_management_system/core/models/employee_local.dart';
// import 'package:mosque_management_system/core/models/local_user_info_model.dart';
// import 'package:mosque_management_system/core/models/mosque_edit_request_model.dart';
// import 'package:mosque_management_system/core/models/mosque_local.dart';
import 'package:mosque_management_system/core/models/prayer_time.dart';
import 'package:mosque_management_system/core/models/userProfile.dart';
import 'package:mosque_management_system/features/visit/core/models/regular_visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_female_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_jumma_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_land_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_ondemand_model.dart';
import 'package:mosque_management_system/features/visit/core/models/visit_eid_model.dart';

import '../../features/mosque/core/models/employee_local.dart';
import '../../features/mosque/core/models/mosque_edit_request_model.dart';
import '../../features/mosque/core/models/mosque_local.dart';
import '../models/userProfile.dart';
// import 'package:mosque_management_system/data/models/local_user_info.dart';
// import 'package:mosque_management_system/data/models/local_user_profile.dart';
//
// import '../../data/models/user_profile.dart';

class HiveRegistry {
  static final visits = HiveBoxHelper<VisitModel>(HiveBoxes.visits);
  // static final userInfo = HiveBoxHelper<LocalUserInfo>(HiveBoxes.userInfo);
  // static final profile = HiveBoxHelper<LocalUserProfile>(HiveBoxes.profile);
  static final mosque = HiveBoxHelper<MosqueLocal>(HiveBoxes.mosque);
  static final regularVisit = HiveBoxHelper<RegularVisitModel>(HiveBoxes.regularVisit);
  static final femaleVisit = HiveBoxHelper<VisitFemaleModel>(HiveBoxes.femaleVisit);
  static final jummaVisit = HiveBoxHelper<VisitJummaModel>(HiveBoxes.jummaVisit);
  static final ondemandVisit = HiveBoxHelper<VisitOndemandModel>(HiveBoxes.ondemandVisit);
  static final landVisit = HiveBoxHelper<VisitLandModel>(HiveBoxes.landVisit);
  static final eidVisit = HiveBoxHelper<VisitEidModel>(HiveBoxes.eidVisit);
  static final prayerTime = HiveBoxHelper<PrayerTime>(HiveBoxes.prayerTime);
  static final employee = HiveBoxHelper<EmployeeLocal>(HiveBoxes.employee);
  static final mosqueEditReq = HiveBoxHelper<MosqueEditRequestModel>(HiveBoxes.mosqueEditReq);
  static final crmUserInfo = HiveBoxHelper<UserProfile>(HiveBoxes.crmUserInfo);
  // latest import Needed for user info retrieval

  /// Clears all app boxes (e.g. during logout)
  static Future<void> clearAllBoxes() async {
    if(Config.disableValidation){
      await femaleVisit.clear();
      await regularVisit.clear();
      await ondemandVisit.clear();
      await jummaVisit.clear();
      await eidVisit.clear();
      await landVisit.clear();
    }
     await mosque.clear();
    await prayerTime.clear();
    await employee.clear();
    await crmUserInfo.clear();

    // If you want to also close the boxes (optional):
    await femaleVisit.close();
    await regularVisit.close();
    await ondemandVisit.close();
    await jummaVisit.close();
    await landVisit.close();
    await eidVisit.close();
    // await userInfo.close();
    await prayerTime.close();
    await mosque.clear();
    await employee.clear();
    await crmUserInfo.close();
  }
}