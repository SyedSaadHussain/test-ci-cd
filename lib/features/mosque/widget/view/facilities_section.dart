import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_input_view.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/mosque_base_view_model.dart';

class FacilitiesSection extends StatefulWidget {
  const FacilitiesSection({super.key});

  @override
  State<FacilitiesSection> createState() => _FacilitiesSectionState();
}

class _FacilitiesSectionState extends State<FacilitiesSection> {
  List<Map<String, dynamic>> allQuestions = [];
  bool questionsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/mosque/property_type_questions.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        allQuestions = jsonList.cast<Map<String, dynamic>>();
        questionsLoaded = true;
      });
    } catch (e) {
      debugPrint('Error loading property type questions: $e');
      setState(() {
        questionsLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!questionsLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (allQuestions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'No property type questions available in configuration',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Consumer<MosqueBaseViewModel>(
      builder: (context, vm, _) {
        // Get existing answers
        final existingAnswers = <dynamic, Map<String, dynamic>>{};
        final propertyTypeList = vm.mosqueObj.propertyTypeIds ?? [];
        
        for (var item in propertyTypeList) {
          dynamic questionIdRaw = item['question_id'];
          int? questionId;
          
          // Extract integer ID from different formats
          if (questionIdRaw is List && questionIdRaw.isNotEmpty) {
            questionId = questionIdRaw[0];  // [id, name] format
          } else if (questionIdRaw is Map && questionIdRaw['id'] != null) {
            questionId = questionIdRaw['id'];  // {id: X, name: Y} format
          } else if (questionIdRaw is int) {
            questionId = questionIdRaw;  // Direct integer
          }
          
          if (questionId != null) {
            existingAnswers[questionId] = item;
          }
        }
        
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            ...allQuestions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              final questionId = question['id'];
              final questionName = question['name'] ?? 'Property Type Question ${index + 1}';
              
              // Get existing answer if available
              final existingItem = existingAnswers[questionId];
              final answer = existingItem?['answer']?.toString() ?? '';
              final landLocation = existingItem?['land_location']?.toString() ?? '';
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInputView(
                      title: questionName,
                      value: answer,  // Pass the actual value (empty string or value)
                      options: vm.fields.getField('property_type_ids').child?.getComboList('answer'),
                    ),
                    
                    if (answer == 'yes')
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: AppInputView(
                          title: vm.fields.getField('property_type_ids').child?.getField('land_location').label ?? 'Land Location',
                          value: landLocation,  // Pass the actual value
                          options: vm.fields.getField('property_type_ids').child?.getComboList('land_location'),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
