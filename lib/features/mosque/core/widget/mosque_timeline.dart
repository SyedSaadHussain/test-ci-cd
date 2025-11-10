import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/constants/app_colors.dart';
import 'package:mosque_management_system/core/styles/app_text_styles.dart';
import 'package:timelines_plus/timelines_plus.dart';
import '../models/mosque_workflow.dart';

class MosqueTimeline extends StatelessWidget {
  final List<MosqueWorkflow>? items;

  const MosqueTimeline({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (items??[]).isEmpty?Container():Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('workflow'.tr(),style: AppTextStyles.headingLG.copyWith(color: AppColors.primary),),
        const SizedBox(height: 10),
        Timeline.tileBuilder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          theme: TimelineThemeData(
            nodePosition: 0.05,
            connectorTheme: ConnectorThemeData(
              thickness: 2,
              color: Colors.grey.shade300,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            itemCount: items!.length,
            contentsBuilder: (context, index) {
              final event = items![index];
              return Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      event.title,
                      style: event.icon == Icons.hourglass_bottom
                          ? AppTextStyles.cardTitle.copyWith()
                          : AppTextStyles.cardTitle,
                    ),
                    if (event.dateTime.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        event.dateTime,
                        style: AppTextStyles.cardSubTitle,
                      ),
                    ],
                  ],
                ),
              );
            },
            indicatorBuilder: (context, index) {
              final event = items![index];
              return DotIndicator(
                color: event.color,
                child: Container(
                  margin: const EdgeInsets.all(6),
                  child: Icon(
                    event.icon,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              );
            },
            connectorBuilder: (context, index, type) {
              return SolidLineConnector(
                color: Colors.green.shade500,
              );
            },
          ),
        ),
      ],
    );
  }
}

