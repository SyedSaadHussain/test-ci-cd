import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:mosque_management_system/core/models/field_list.dart';
import 'package:mosque_management_system/features/mosque/core/constants/form_mode.dart';
import 'package:mosque_management_system/features/mosque/core/models/mosque_local.dart';
import 'package:mosque_management_system/features/mosque/core/viewmodel/create_mosque_base_view_model.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_declaration_field.dart';
import 'package:mosque_management_system/shared/widgets/form_controls/app_single_selection_field.dart';

class MosqueFacilitiesTab extends StatefulWidget {
  final MosqueLocal local;
  final bool editing;
  final FieldListData fields;
  final void Function(void Function(MosqueLocal m) apply) updateLocal;

  const MosqueFacilitiesTab({
    super.key,
    required this.local,
    required this.editing,
    required this.fields,
    required this.updateLocal,
  });

  @override
  State<MosqueFacilitiesTab> createState() => _MosqueFacilitiesTabState();
}

class _MosqueFacilitiesTabState extends State<MosqueFacilitiesTab> {
  List<Map<String, dynamic>> allQuestions = [];
  bool questionsLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (questionsLoaded && allQuestions.isNotEmpty) {
        _initializePropertyTypeIds();
      }
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-initialize when tab is viewed to ensure all questions are displayed
    _checkAndInitializePropertyTypes();
  }

  Future<void> _loadQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/mosque/property_type_questions.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      setState(() {
        allQuestions = jsonList.cast<Map<String, dynamic>>();
        questionsLoaded = true;
      });
      _initializePropertyTypeIds();
    } catch (e) {
      debugPrint('Error loading property type questions: $e');
      setState(() {
        questionsLoaded = true;
      });
    }
  }

  /// Check if property types need to be initialized from offline data
  void _checkAndInitializePropertyTypes() {
    if (!questionsLoaded || allQuestions.isEmpty) {
      return;
    }
    
    final vm = context.read<CreateMosqueBaseViewModel>();
    
    // If propertyTypeIds is null or empty, initialize with offline questions
    if (vm.mosqueObj.propertyTypeIds == null || vm.mosqueObj.propertyTypeIds!.isEmpty) {
      debugPrint('🔄 [property_type_ids] API returned 0 records, initializing with offline questions...');
      
      // Defer the state change until after the build phase is complete
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializePropertyTypeIds();
      });
    }
  }

  void _initializePropertyTypeIds() {
    // Don't initialize if questions haven't been loaded yet
    if (allQuestions.isEmpty) {
      debugPrint('Cannot initialize property types: questions not loaded');
      return;
    }
    
    final vm = context.read<CreateMosqueBaseViewModel>();
    
    // Always ensure all questions are displayed, even if no answers exist
    // Build a map of existing answers for quick lookup
    final existing = <dynamic, Map<String, dynamic>>{};
    if (vm.mosqueObj.propertyTypeIds != null && vm.mosqueObj.propertyTypeIds!.isNotEmpty) {
      for (var item in vm.mosqueObj.propertyTypeIds!) {
        final questionId = item['question_id'] is List 
            ? item['question_id'][0] 
            : item['question_id'];
        if (questionId != null) {
          existing[questionId] = item;
        }
      }
    }
    
    // Always initialize with ALL questions from JSON, preserving existing answers
    vm.mosqueObj.propertyTypeIds = allQuestions.map((question) {
      final questionId = question['id'];
      final existingItem = existing[questionId];
      
      final newItem = {
        'question_id': [questionId, question['name']],
        'question_name': question['name'],
        'answer': existingItem?['answer'],
        'land_location': existingItem?['land_location'],
      };
      
      // ⚠️ CRITICAL: Preserve the record 'id' field for existing items
      // This is the database record ID (e.g., 248, 249) needed for updates
      if (existingItem != null && existingItem['id'] != null) {
        newItem['id'] = existingItem['id'];
      }
      
      return newItem;
    }).toList();
    
    debugPrint('Initialized ${vm.mosqueObj.propertyTypeIds!.length} property type questions');
    
    // Debug: Verify record IDs are preserved
    final withIds = vm.mosqueObj.propertyTypeIds!.where((item) => item['id'] != null).length;
    if (withIds > 0) {
      debugPrint('  → $withIds questions have existing record IDs (good for updates)');
    } else {
      debugPrint('  → All questions initialized from offline data (no existing answers)');
    }
    
    vm.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    if (!questionsLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final vm = context.watch<CreateMosqueBaseViewModel>();
    final isEditReq = vm.mode == FormMode.editRequest;
    
    // Ensure property types are initialized
    final propertyTypeList = vm.mosqueObj.propertyTypeIds ?? [];
    
    // If somehow the list is empty after initialization, show message
    if (propertyTypeList.isEmpty) {
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
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
        ...propertyTypeList.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final questionName = _getQuestionName(item, index);
          final answer = item['answer']?.toString();
          final landLocation = item['land_location']?.toString();
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Answer field (yes/no) - REQUIRED
                AppSelectionField(
                  title: questionName,
                  value: answer,
                  type: SingleSelectionFieldType.radio,
                  options: vm.fields.getField('property_type_ids').child?.getComboList('answer'),
                  isRequired: true, // Make all questions mandatory
                  action: isEditReq
                      ? AppDeclarationField(
                          value: vm.getAgree(_getFieldKey('property_type_$index')),
                          onChanged: (v) => vm.updateAgreeField(_getFieldKey('property_type_$index'), v),
                        )
                      : null,
                  onChanged: widget.editing ? (val) => _onAnswerChanged(index, val, vm, isEditReq) : null,
                ),
                
                // Land location field (conditional on 'yes' answer)
                if (answer == 'yes')
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: AppSelectionField(
                      title: vm.fields.getField('property_type_ids').child?.getField('land_location').label,
                      value: landLocation,
                      type: SingleSelectionFieldType.selection,
                      options: vm.fields.getField('property_type_ids').child?.getComboList('land_location'),
                      isRequired: true, // Required when answer is yes
                      action: isEditReq
                          ? AppDeclarationField(
                              value: vm.getAgree(_getFieldKey('property_type_location_$index')),
                              onChanged: (v) => vm.updateAgreeField(_getFieldKey('property_type_location_$index'), v),
                            )
                          : null,
                      onChanged: widget.editing ? (val) => _onLandLocationChanged(index, val, vm, isEditReq) : null,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
          ],
        ),
      ),
    );
  }

  /// Extracts question name from item data
  /// Handles both API format (question_id: [id, name]) and local format (question_name)
  String _getQuestionName(Map<String, dynamic> item, int index) {
    final questionId = item['question_id'];
    
    // Try to extract from array format: [id, name]
    if (questionId is List && questionId.length > 1) {
      return questionId[1]?.toString() ?? '';
    }
    
    // Fallback to question_name field
    if (item['question_name'] != null) {
      return item['question_name'].toString();
    }
    
    // Default fallback
    return 'Property Type Question ${index + 1}';
  }

  /// Generates field key for agreement tracking
  String _getFieldKey(String field) => 'mosque_facilities.$field';

  /// Handles answer field changes
  void _onAnswerChanged(int index, String? val, CreateMosqueBaseViewModel vm, bool isEditReq) {
    final propertyTypeList = vm.mosqueObj.propertyTypeIds!;
    setState(() {
      propertyTypeList[index]['answer'] = val;
      if (val == 'no') {
        propertyTypeList[index]['land_location'] = null;
      }
    });
    vm.notifyListeners();
    
    if (isEditReq) {
      vm.updateAgreeField(_getFieldKey('property_type_$index'), true);
    }
  }

  /// Handles land location field changes
  void _onLandLocationChanged(int index, String? val, CreateMosqueBaseViewModel vm, bool isEditReq) {
    final propertyTypeList = vm.mosqueObj.propertyTypeIds!;
    setState(() {
      propertyTypeList[index]['land_location'] = val;
    });
    vm.notifyListeners();
    
    if (isEditReq) {
      vm.updateAgreeField(_getFieldKey('property_type_location_$index'), true);
    }
  }
}