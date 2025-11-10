import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class StepTabsWidget extends StatefulWidget {
  final int currentStep;
  final Function(int) onStepChanged;

  const StepTabsWidget({
    super.key,
    required this.currentStep,
    required this.onStepChanged,
  });

  @override
  State<StepTabsWidget> createState() => _StepTabsWidgetState();
}

class _StepTabsWidgetState extends State<StepTabsWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StepTabsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep) {
      _scrollToCurrentTab();
    }
  }

  void _scrollToCurrentTab() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        double targetOffset = widget.currentStep * 124.0; // 120 width + 4 margin
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(), // Disable manual scrolling
          child: Row(
            children: [
              _buildTab(0, "employee_info".tr()),
              _buildTab(1, "assigned_mosques_info".tr()),
              _buildTab(2, "new_mosque_info".tr()),
              _buildTab(3, "required_documents_info".tr()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index, String title) {
    final isSelected = widget.currentStep == index;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade100 : Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.green.shade900 : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
