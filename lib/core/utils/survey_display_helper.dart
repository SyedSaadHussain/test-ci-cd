import 'package:flutter/foundation.dart';
import 'package:mosque_management_system/shared/widgets/modal/survey_configuration.dart';
import 'package:mosque_management_system/core/utils/json_utils.dart';

import '../../shared/widgets/app_form_field.dart';

class SurveyDisplayHelper {
  static String getSubtitle(VisitConfiguration question) {
    final value = question.value;
    final comment = question.userComment?.toString().trim();
    final rawAnswers = question.originalAnswers;

    try {
      // ✅ Handle simple_choice with combined suggestion + char_box
      // if (question.questionType == 'simple_choice' &&
      //     rawAnswers != null &&
      //     rawAnswers.isNotEmpty) {
      //   final suggestion = rawAnswers.firstWhere(
      //         (e) => e['answer_type'] == 'suggestion',
      //     orElse: () => <String, dynamic>{},
      //   );
      //
      //   final charBox = rawAnswers.firstWhere(
      //         (e) => e['answer_type'] == 'char_box',
      //     orElse: () => <String, dynamic>{},
      //   );
      //
      //   String? label;
      //
      //   // ✅ Try custom_answer_ids first
      //   if (suggestion['custom_answer_ids'] is List &&
      //       suggestion['custom_answer_ids'].isNotEmpty) {
      //     final custom = suggestion['custom_answer_ids'][0];
      //     label = (custom is List && custom.length > 1)
      //         ? custom[1].toString()
      //         : (custom is String ? custom : custom.toString());
      //   }
      //
      //   // ✅ Then fallback to suggested_answer_id if needed
      //   else if (suggestion['suggested_answer_id'] is List &&
      //       suggestion['suggested_answer_id'].length > 1) {
      //     label = suggestion['suggested_answer_id'][1].toString();
      //   } else if (suggestion['suggested_answer_id'] is String) {
      //     label = suggestion['suggested_answer_id'];
      //   }
      //
      //   final charBoxText = (charBox['value_char_box'] ?? '').toString().trim();
      //   debugPrint("📌 QuestionTest: ${question.name}");
      //   debugPrint("Suggestion:$suggestion");
      //   debugPrint("🔤 Label: $label");
      //   debugPrint("✏️ CharBox: $charBoxText");
      //   return [
      //     if (label != null && label.isNotEmpty) label,
      //     if (charBoxText.isNotEmpty) charBoxText,
      //     if (comment != null && comment.isNotEmpty) '🗒 $comment',
      //   ].join('\n');
      // }

      // ✅ Handle "simple_choice" with special case for
      if (question.questionType == 'simple_choice' &&
          rawAnswers != null &&
          rawAnswers.isNotEmpty) {

        final suggestion = rawAnswers.firstWhere(
              (e) => e['answer_type'] == 'suggestion',
          orElse: () => <String, dynamic>{},
        );

        final charBox = rawAnswers.firstWhere(
              (e) => e['answer_type'] == 'char_box',
          orElse: () => <String, dynamic>{},
        );

        String? label;

        // ✅ Parse label from custom_answer_ids
        if (suggestion['custom_answer_ids'] is List &&
            suggestion['custom_answer_ids'].isNotEmpty) {
          final custom = suggestion['custom_answer_ids'][0];
          label = (custom is List && custom.length > 1)
              ? custom[1].toString()
              : (custom is String ? custom : custom.toString());
        } else if (suggestion['suggested_answer_id'] is List &&
            suggestion['suggested_answer_id'].length > 1) {
          label = suggestion['suggested_answer_id'][1].toString();
        } else if (suggestion['suggested_answer_id'] is String) {
          label = suggestion['suggested_answer_id'];
        }

        final charBoxText = charBox['value_char_box']?.toString().trim() ?? '';

        debugPrint(" QuestionTest: ${question.name}");
        debugPrint("Suggestion:$suggestion");
        debugPrint(" Label: $label");
        debugPrint(" CharBox: $charBoxText");

        return [
          if (label != null && label.isNotEmpty) label,
          if (charBoxText.isNotEmpty) charBoxText, // 👈 this will show your `"o"`
          if (comment != null && comment.isNotEmpty) '🗒 $comment',
        ].join('\n');
      }


      print('🔍 Question1 name: "${question.name}"');

      // // ✅ Special case for "اسم الإمام", "اسم المؤذن", or "اسم الخادم"
      // if (question.name!.contains('اسم الإمام') ||
      //     question.name!.contains('اسم المؤذن') ||
      //     question.name!.contains('اسم الخادم')) {
      //
      //   String? name;
      //   String? charBox;
      //
      //   // Extract name from custom_answer_ids
      //   final suggestion = rawAnswers?.firstWhere(
      //         (e) => e['answer_type'] == 'suggestion',
      //     orElse: () => <String, dynamic>{},
      //   );
      //
      //   if (suggestion != null &&
      //       suggestion['custom_answer_ids'] is List &&
      //       suggestion['custom_answer_ids'].isNotEmpty) {
      //     final custom = suggestion['custom_answer_ids'][0];
      //     name = (custom is List && custom.length > 1)
      //         ? custom[1].toString()
      //         : (custom is String ? custom : custom.toString());
      //   }
      //
      //   // Extract manual name from char_box
      //   final charBoxAnswer = rawAnswers?.firstWhere(
      //         (e) => e['answer_type'] == 'char_box',
      //     orElse: () => <String, dynamic>{},
      //   );
      //
      //   charBox = charBoxAnswer?['value_char_box']?.toString();
      //
      //   return [
      //     if (name != null && name.isNotEmpty) name,
      //     if (charBox != null && charBox.isNotEmpty) charBox,
      //     if (comment != null && comment.isNotEmpty) '🗒 $comment',
      //   ].join('\n');
      // }




      // 🗓 Date field
      if (question.fieldType == FieldType.date && value is Map) {
        final g = value['gregorian'] ?? '';
        final h = value['hijri'] ?? '';
        return '📅 $g\n🗓 $h';
      }

      // 🧾 Standalone char_box field (e.g. Imam/Muazzin name)



      // 📝 Text field
      if (question.fieldType == FieldType.textField && value is String) {
        return '📝 $value';
      }

      // 📋 List of plain strings
      if (value is List && value.every((e) => e is String)) {
        return value.join('، ');
      }

      // 🧠 Fallback from options or raw value
      final parsed = JsonUtils.getNameFromKey(question.options, value);
      return [
        if (parsed != null && parsed.isNotEmpty) parsed,
        if (comment != null && comment.isNotEmpty) '🗒 $comment',
      ].join('\n');
    }

    catch (e, stack) {
      debugPrint("❌ Error parsing subtitle for question [${question.name}]: $e");


      return '';
    }
  }
}

bool hasUserAnswer(VisitConfiguration question) {
  if (question.value != null && question.value.toString().trim().isNotEmpty) return true;

  final answers = question.originalAnswers;
  if (answers != null && answers is List && answers.isNotEmpty) {
    final hasContent = answers.any((ans) {
      if (ans['answer_type'] == 'suggestion' &&
          ans['custom_answer_ids'] != null &&
          ans['custom_answer_ids'].isNotEmpty) return true;

      if (ans['answer_type'] == 'char_box' &&
          ans['value_char_box'] != null &&
          ans['value_char_box'].toString().trim().isNotEmpty) return true;

      return false;
    });
    return hasContent;
  }

  return false;
}


