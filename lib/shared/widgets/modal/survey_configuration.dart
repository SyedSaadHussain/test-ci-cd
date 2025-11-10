import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:mosque_management_system/core/models/combo_list.dart';
import 'package:mosque_management_system/core/constants/config.dart';
import 'package:mosque_management_system/core/utils/extension.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';
import 'package:mosque_management_system/core/utils/paged_data.dart';
import 'package:mosque_management_system/shared/widgets/app_form_field.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class VisitConfigurationData{



  String sectionName="";
  int? pageId;

  List<VisitConfiguration>? list;


  // String get pageId{
  //
  //     if(list!.length>0 && list!.first.pageId!=null)
  //       return list!.first.pageId.toString();
  //     else
  //       return "";
  // }


  VisitConfigurationData({
    this.sectionName="",
    this.pageId,
    this.list,
  });



  bool isVisible(VisitConfiguration config) {

    if (config.visibleFieldQuestion == null) {
      return true;
    } else {
      VisitConfiguration? visibleField =
          list!.where((rec) => rec.id == config.visibleFieldQuestion).firstOrNull;

      if (visibleField != null &&
          visibleField.value.toString() == config.visibleFieldAnswer.toString()) {
        print('yahooo');
        print(config.visibleFieldAnswer);
        return true;
      }

      // NEW: Also check originalAnswers if value match fails
      // final actualAnswers = visibleField?.originalAnswers; //  NEW
      // final originalAnswersMatch = actualAnswers?.any((answer) { //  NEW
      //   final key = answer['suggested_answer_id']; //  NEW
      //   if (key is List && key.isNotEmpty) { // NEW
      //     return key.first.toString() == config.visibleFieldAnswer.toString(); //  NEW
      //   } //  NEW
      //   if (key is String) { // NEW
      //     return key == config.visibleFieldAnswer.toString(); //  NEW
      //   } // NEW
      //   return false; // NEW
      // }) ?? false; // NEW
      //
      // if (originalAnswersMatch) { // ✅ NEW
      //   print('[Visibility via originalAnswers] Showing → ${config.name}'); //  NEW
      //   print("Checking visibility for: ${config.name} (ID: ${config.id})");
      //   print(" Expected trigger: Question ${config.visibleFieldQuestion} → Answer ${config.visibleFieldAnswer}");
      //   print(" Actual trigger value: ${visibleField?.value}");
      //   print("Original Answers: ${visibleField?.originalAnswers}");
      //   return true; //
      // }

      config.value = config.defaultValue;

      return false;
    }

  }

  bool isVisibleView(VisitConfiguration config) {
    if (config.visibleFieldQuestion == null) {
      return true;
    } else {
      VisitConfiguration? visibleField =
          list?.where((rec) => rec.id == config.visibleFieldQuestion).firstOrNull;

      if (visibleField != null &&
          visibleField.value.toString() == config.visibleFieldAnswer.toString()) {
        print('[VisibleView] Basic match: Showing → ${config.name}');
        print(config.visibleFieldAnswer);
        return true;
      }

      // Check originalAnswers fallback
      final actualAnswers = visibleField?.originalAnswers;
      final originalAnswersMatch = actualAnswers?.any((answer) {
        final key = answer['suggested_answer_id'];
        if (key is List && key.isNotEmpty) {
          return key.first.toString() == config.visibleFieldAnswer.toString();
        }
        if (key is String || key is int) {
          return key.toString() == config.visibleFieldAnswer.toString();
        }
        return false;
      }) ?? false;

      if (originalAnswersMatch) {
        print('[VisibleView] originalAnswers match → Showing → ${config.name}');
        // NEW: Also check originalAnswers if value match fails
        final actualAnswers = visibleField?.originalAnswers; //  NEW
        final originalAnswersMatch = actualAnswers?.any((answer) { //  NEW
          final key = answer['suggested_answer_id']; //  NEW
          if (key is List && key.isNotEmpty) { // NEW
            return key.first.toString() == config.visibleFieldAnswer.toString(); //  NEW
          } //  NEW
          if (key is String) { // NEW
            return key == config.visibleFieldAnswer.toString(); //  NEW
          } // NEW
          return false; // NEW
        }) ?? false; // NEW

        if (originalAnswersMatch) { // ✅ NEW
          print('[Visibility via originalAnswers] Showing → ${config.name}'); //  NEW
          print("Checking visibility for: ${config.name} (ID: ${config.id})");
          print("Expected trigger: Question ${config.visibleFieldQuestion} → Answer ${config.visibleFieldAnswer}");
          print("Actual value: ${visibleField?.value}");
          print(" Expected trigger: Question ${config.visibleFieldQuestion} → Answer ${config.visibleFieldAnswer}");
          print(" Actual trigger value: ${visibleField?.value}");
          print("Original Answers: ${visibleField?.originalAnswers}");
          return true;
          return true; //
        }

        // Reset if not visible
        config.value = config.defaultValue;

        return false;
      }
    }

    return true;
  }

  factory VisitConfigurationData.fromJson(dynamic json) {



    //json['no_planned']=false;
    return VisitConfigurationData(
      sectionName: JsonUtils.getName(json[0])??"",
      pageId: JsonUtils.getId(json[0]),
      list: (json.length > 1 && json[1] is List)
          ? (json[1] as List).map((item) => VisitConfiguration.fromJson(item)).toList()
          : [],
    );
  }
}
class VisitConfiguration  {
  String? name;
   // FieldType? fieldType;
  String? questionType;
  int id;
  int? visibleFieldQuestion;
  dynamic visibleFieldAnswer;
  List<ComboItem>? options;
  List<ComboItem>? matrixOptions;
  dynamic value;
  dynamic comments;
  dynamic defaultValue;
  bool? isRequired;
  bool? isYakeen;
  bool? isComments;
  bool? showComments;
  String? commentsHint;
  dynamic systemAnswer;
  dynamic systemAnswerName;
  int? pageId;
  String? isFromSystem;
  String? userComment;
  List<Map<String, dynamic>>? originalAnswers; // 👈 NEW FIELD


  FieldType get  fieldType {
    if (questionType == "simple_choice") {
       return FieldType.selection;
    }else if (questionType == "date") {
       return FieldType.date;
    }  else if (questionType == "datetime") {
       return FieldType.datetime;
    }  else if (questionType == "text_box") {
       return FieldType.textArea;
    }  else if (questionType == "numerical_box") {
       return FieldType.number;
    }else if (questionType == "multiple_choice") {
       return FieldType.checkBox;
    } else if (questionType == "upload_file") {
       return FieldType.image;
    }  else if (questionType == "matrix") {
       return FieldType.matrix;
    }  else {
       return FieldType.textField; // default fallback
    }
  }

  bool get  isSystem {
    // return false;
    return (isFromSystem??"")=="is_field_calculation"?true:false;
  }

  // dynamic get  value {
  //   return (isFromSystem??"")=="is_field_calculation"?true:false;
  // }

  VisitConfiguration({
    required this.id,
    this.name,
    // this.fieldType,
    this.questionType,
    this.options,
    this.matrixOptions,
    this.visibleFieldAnswer,
    this.visibleFieldQuestion,
    this.value,
    this.defaultValue=null,
    this.isRequired,
    this.isFromSystem,
    this.systemAnswer,
    this.isComments,
    this.commentsHint,
    this.comments,
    this.showComments,
    this.isYakeen,
    this.pageId,
    this.userComment,
    this.originalAnswers

  });
  factory VisitConfiguration.fromJson(Map<String, dynamic> json) {


    //json['no_planned']=false;
    dynamic obj = VisitConfiguration(
      id: JsonUtils.toInt(json['question_id'])!.toInt(),
      name: JsonUtils.toText(json['title']),
      pageId: JsonUtils.toInt(json['section_id']),
      isFromSystem: JsonUtils.toText(json['is_from_system']),
      commentsHint: JsonUtils.toText(json['comments_message']),
      isRequired: JsonUtils.toBoolean(json['required'])??false,
      // isRequired: false,//JsonUtils.toBoolean(json['required'])??false,
      // value: getDefaultValue(json['required']),
      isComments: JsonUtils.toBoolean(json['comments_allowed']),
      isYakeen: JsonUtils.toBoolean(json['is_yakeen']),
      questionType: JsonUtils.toText(json['question_type']),
      systemAnswer: JsonUtils.getKey(json['system_answer']),
      visibleFieldQuestion: JsonUtils.toInt(json['triggering_question_id']),
      visibleFieldAnswer: JsonUtils.getKey(json['triggering_answer_id']),
      options: (json['options'] as List).map((item) => ComboItem.fromJsonDynamic(item)).toList(),
      matrixOptions: (json['matrix_options'] as List).map((item) => ComboItem.fromJsonDynamic(item)).toList(),
      userComment: JsonUtils.toText(json['user_comment']),
      originalAnswers: (json['user_answer'] is List)
          ? List<Map<String, dynamic>>.from(json['user_answer'])
          : null,
    );
    obj.getDefaultValue();
    return obj;
  }
  dynamic getDefaultValue(){
      if(isSystem){
        value=systemAnswer;
      }
  }
}