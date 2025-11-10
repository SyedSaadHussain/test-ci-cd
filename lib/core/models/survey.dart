import 'package:mosque_management_system/core/models/survey_user_input.dart';

class Survey {
  final SurveyUserInput? userInput;

  Survey({this.userInput});

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      userInput: json['user_input'] != null
          ? SurveyUserInput.fromJson(json['user_input'])
          : null,
    );
  }
}

class UserSurvey {
  int? mosqueId;
  String? mosqueName;
  int? employeeId;
  String? employeeName;
  int? visitFormId;
  String? visitForm;
  String? onDate;

  UserSurvey({
    this.mosqueId,
    this.mosqueName,
    this.employeeId,
    this.employeeName,
    this.visitFormId,
    this.visitForm,
    this.onDate
  });

  reset(){
    mosqueId=null;
    mosqueName='';
    employeeId=null;
    employeeName=null;
    visitFormId=null;
    visitForm=null;
    onDate=null;
  }
}
