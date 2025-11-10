import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../providers/water_consumption_view_model.dart';

class WaterMonthlyConsumptionChartWidget extends StatelessWidget {
  const WaterMonthlyConsumptionChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterConsumptionViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            height: 200,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (viewModel.monthlyData.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.onPrimaryLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primaryContainer.withOpacity(0.2), width: 1),
            ),
            child: Center(
              child: Text(
                'no_monthly_data_available'.tr(),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        final currentYear = DateTime.now().year;
        final currentMonth = DateTime.now().month;

        final dataByMonth = <int, double>{};
        for (final item in viewModel.monthlyData) {
          if (item.invoiceDate.isNotEmpty) {
            try {
              final date = DateTime.parse(item.invoiceDate);
              if (date.year == currentYear) {
                dataByMonth[date.month] = item.quantity;
              }
            } catch (_) {}
          }
        }

        final quantities = <double>[];
        final monthLabels = <String>[];
        for (int month = 1; month <= 12; month++) {
          quantities.add(dataByMonth[month] ?? 0.0);
          monthLabels.add('$month');
        }

        final lastMonthWithData = dataByMonth.keys.isEmpty
            ? 0
            : dataByMonth.keys.reduce((a, b) => a > b ? a : b);
        final displayMonths =
            lastMonthWithData > 0 ? lastMonthWithData : currentMonth;
        final displayQuantities = quantities.take(displayMonths).toList();

        final totalConsumption =
            dataByMonth.values.fold<double>(0, (sum, q) => sum + q);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(top: 20, bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.onPrimaryLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.primaryContainer.withOpacity(0.2), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'monthly_consumption'.tr(),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          viewModel.changeRatioPercent >= 0
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: viewModel.changeRatioPercent <= 0
                              ? Colors.greenAccent
                              : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${viewModel.changeRatioPercent.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: viewModel.changeRatioPercent <= 0
                                ? Colors.greenAccent
                                : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '${totalConsumption.toStringAsFixed(0)} m³',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 160,
                child: CustomPaint(
                  size: const Size(double.infinity, 160),
                  painter: _WaterChartPainter(displayQuantities, displayMonths),
                ),
              ),
              const SizedBox(height: 20),
              Directionality(
                textDirection: TextDirection.ltr,
                child: SizedBox(
                  height: 24,
                  child: CustomPaint(
                    size: const Size(double.infinity, 24),
                    painter:
                        _WaterMonthLabelsPainter(monthLabels, displayMonths),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WaterChartPainter extends CustomPainter {
  final List<double> data;
  final int totalMonths;

  _WaterChartPainter(this.data, this.totalMonths);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.isNotEmpty && data.any((value) => value > 0)
        ? data.reduce((a, b) => a > b ? a : b)
        : 1.0;

    final chartMargin = size.width * 0.05;
    final chartWidth = size.width - (2 * chartMargin);
    final stepX = chartWidth / 11;

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.green.withOpacity(0.2),
          Colors.green.withOpacity(0.05),
          Colors.green.withOpacity(0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final areaPath = Path();

    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = chartMargin + (i * stepX);
      final y = size.height -
          ((data[i] / maxValue) * size.height * 0.8) -
          (size.height * 0.1);
      points.add(Offset(x.toDouble(), y.toDouble()));
    }

    path.moveTo(points[0].dx, points[0].dy);
    areaPath.moveTo(points[0].dx, size.height);
    areaPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlPoint = Offset((current.dx + next.dx) / 2, current.dy);
      path.quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, next.dx, next.dy);
      areaPath.quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, next.dx, next.dy);
    }

    areaPath.lineTo(points.last.dx, size.height);
    areaPath.close();

    canvas.drawPath(areaPath, gradientPaint);
    canvas.drawPath(path, linePaint);

    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      final glowPaint = Paint()
        ..color = Colors.green.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(point, 8, glowPaint);
      canvas.drawCircle(point, 6, Paint()..color = Colors.white);
      canvas.drawCircle(
          point,
          6,
          Paint()
            ..color = Colors.green
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);

      if (data[i] > 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: data[i].toStringAsFixed(0),
            style: TextStyle(
              color: Colors.black.withOpacity(0.6),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: ui.TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
            canvas, Offset(point.dx - textPainter.width / 2, point.dy - 24));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _WaterMonthLabelsPainter extends CustomPainter {
  final List<String> monthLabels;
  final int displayMonths;

  _WaterMonthLabelsPainter(this.monthLabels, this.displayMonths);

  @override
  void paint(Canvas canvas, Size size) {
    final chartMargin = size.width * 0.05;
    final chartWidth = size.width - (2 * chartMargin);
    final fullStepX = chartWidth / 11;

    for (int i = 0; i < 12; i++) {
      final x = chartMargin + (i * fullStepX);
      final isActive = i < displayMonths;
      final monthNumber = i + 1;

      if (isActive) {
        final circlePaint = Paint()
          ..color = Colors.green.withOpacity(0.1)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, 10), 12, circlePaint);
        final borderPaint = Paint()
          ..color = Colors.green.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;
        canvas.drawCircle(Offset(x, 10), 12, borderPaint);
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: monthNumber.toString(),
          style: TextStyle(
            color: isActive
                ? Colors.green.shade700
                : AppColors.textSecondary.withOpacity(0.5),
            fontSize: isActive ? 12 : 11,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout();
      textPainter.paint(canvas,
          Offset(x - textPainter.width / 2, 10 - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
