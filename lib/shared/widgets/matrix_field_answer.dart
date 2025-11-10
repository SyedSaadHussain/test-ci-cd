import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/combo_list.dart';
//import '../booleans/boolean.dart';
import 'app_list_title.dart';

class MatrixFieldAnswers extends StatefulWidget {
  final String? title;
  final TextStyle? labelStyle;
  final List<ComboItem>? verticalOptions;
  final List<ComboItem>? horizontalOptions;
  final List<dynamic> values;

  const MatrixFieldAnswers({
    super.key,
    this.title,
    this.labelStyle,
    required this.verticalOptions,
    required this.horizontalOptions,
    required this.values,
  });

  @override
  State<MatrixFieldAnswers> createState() => _MatrixFieldAnswersState();
}

class _MatrixFieldAnswersState extends State<MatrixFieldAnswers> {
  bool isSelected(int rowId, int colId) {
    return widget.values.any((pair) =>
    pair is List &&
        pair.length == 2 &&
        pair[0] == rowId &&
        pair[1] == colId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          widget.title ?? "",
          style: widget.labelStyle ??
              TextStyle(
                color: Colors.black.withOpacity(.7),
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
        ),
        Container(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              // Header Row
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: AppColors.gray.withOpacity(.3),
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: AppColors.gray.withOpacity(.3),
                        child: Row(
                          children: widget.horizontalOptions!.map((option) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 15),
                                child: Center(child: Text(option.value ?? "")),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Answer Rows
              ...widget.verticalOptions!.map((row) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: AppColors.gray.withOpacity(.3),
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Text(row.value ?? ""),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          color: AppColors.backgroundColor,
                          child: Row(
                            children: widget.horizontalOptions!.map((col) {
                              final selected = isSelected(row.key!, col.key!);
                              return Expanded(
                                child: Container(
                                  height: 50,
                                  child: Center(child: AppBoolean(value: selected)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
