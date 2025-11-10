import 'package:flutter/material.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';

class TimelineStep {
  final String title;
  final String date;
  final bool isCompleted;
  final IconData icon;

  const TimelineStep({
    required this.title,
    required this.date,
    required this.isCompleted,
    this.icon = Icons.check,
  });
}

class CustomTimelineWidget extends StatelessWidget {
  final List<TimelineStep> steps;
  final Color? completedColor;
  final Color? pendingColor;
  final double indicatorSize;
  final double connectorHeight;

  const CustomTimelineWidget({
    super.key,
    required this.steps,
    this.completedColor,
    this.pendingColor,
    this.indicatorSize = 40.0,
    this.connectorHeight = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        return _buildTimelineStep(index, step);
      }).toList(),
    );
  }

  Widget _buildTimelineStep(int index, TimelineStep step) {
    final isCompleted = step.isCompleted;
    final color = isCompleted 
        ? (completedColor ?? Colors.green) 
        : (pendingColor ?? Colors.grey);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator and connector
        Column(
          children: [
            // Timeline indicator
            Container(
              width: indicatorSize,
              height: indicatorSize,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                step.icon,
                color: Colors.white,
                size: indicatorSize * 0.5,
              ),
            ),
            // Connector line (except for last item)
            if (index < steps.length - 1)
              Container(
                width: 2,
                height: connectorHeight,
                color: color,
                margin: const EdgeInsets.only(top: 8),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: AppTextStyles.formLabel.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step.date,
                style: AppTextStyles.cardSubTitle,
              ),
              if (index < steps.length - 1) 
                SizedBox(height: connectorHeight - 20),
            ],
          ),
        ),
      ],
    );
  }
}
