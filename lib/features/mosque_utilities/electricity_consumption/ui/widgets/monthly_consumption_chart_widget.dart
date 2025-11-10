import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../providers/meter_consumption_view_model.dart';

class MonthlyConsumptionChartWidget extends StatelessWidget {
  const MonthlyConsumptionChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MeterConsumptionViewModel>(
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
              border: Border.all(color: AppColors.primaryContainer.withOpacity(0.2), width: 1),
            ),
            child: Center(
              child: Text(
                'no_monthly_data_available'.tr(),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        // Process data to show all months of current year
        final currentYear = DateTime.now().year;
        final currentMonth = DateTime.now().month;
        
        // Create a map of existing data by month (only current year)
        final dataByMonth = <int, double>{};
        for (final item in viewModel.monthlyData) {
          if (item.invoiceDate != null && item.invoiceDate!.isNotEmpty) {
            try {
              final date = DateTime.parse(item.invoiceDate!);
              // Only include data from current year
              if (date.year == currentYear) {
                dataByMonth[date.month] = item.quantity.toDouble();
              }
            } catch (e) {
              // Skip invalid dates
              print('Invalid date format: ${item.invoiceDate}');
            }
          }
        }
        
        // Generate data for all months (1-12) with zeros for missing months
        final quantities = <double>[];
        final monthLabels = <String>[];
        
        for (int month = 1; month <= 12; month++) {
          // Add quantity (0 if no data for this month)
          quantities.add(dataByMonth[month] ?? 0.0);
          
          // Add clean month number
          monthLabels.add('$month');
        }
        
        // Only show data for months that have actual data or up to the last month with data
        final lastMonthWithData = dataByMonth.keys.isEmpty ? 0 : dataByMonth.keys.reduce((a, b) => a > b ? a : b);
        final displayMonths = lastMonthWithData > 0 ? lastMonthWithData : currentMonth;
        final displayQuantities = quantities.take(displayMonths).toList();

        // Calculate total consumption from current year data only
        final totalConsumption = dataByMonth.values
            .fold<double>(0, (sum, quantity) => sum + quantity);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.only(top: 20, bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.onPrimaryLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primaryContainer.withOpacity(0.2), width: 1),
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
                            ? Colors.green 
                            : Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${viewModel.changeRatioPercent.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: viewModel.changeRatioPercent <= 0 
                              ? Colors.green 
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
                  '${totalConsumption.toStringAsFixed(0)} ${'kwh_unit'.tr()}',
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
                  painter: ChartPainter(displayQuantities, displayMonths),
                ),
              ),
              const SizedBox(height: 20),
              // Show month labels aligned with chart points
              Directionality(
                textDirection: TextDirection.ltr,
                child: SizedBox(
                  height: 24,
                  child: CustomPaint(
                    size: Size(double.infinity, 24),
                    painter: MonthLabelsPainter(monthLabels, displayMonths),
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


class ChartPainter extends CustomPainter {
  final List<double> data;
  final int totalMonths;

  ChartPainter(this.data, this.totalMonths);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.isNotEmpty && data.any((value) => value > 0) 
        ? data.reduce((a, b) => a > b ? a : b) 
        : 1.0; // Default to 1 if all values are 0
    
    // Use full width with minimal margins for maximum space
    final chartMargin = size.width * 0.05; // 5% margin on each side
    final chartWidth = size.width - (2 * chartMargin);
    final stepX = chartWidth / 11; // 11 intervals for 12 months

    // Create gradient for area fill
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

    // Create line paint
    final linePaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final areaPath = Path();

    // Draw smooth curve aligned with 12-month grid
    List<Offset> points = [];
    for (int i = 0; i < data.length; i++) {
      final x = chartMargin + (i * stepX); // Position on 12-month grid
      final y = size.height - ((data[i] / maxValue) * size.height * 0.8) - (size.height * 0.1);
      points.add(Offset(x.toDouble(), y.toDouble()));
    }

    // Create smooth curve through points
    path.moveTo(points[0].dx, points[0].dy);
    areaPath.moveTo(points[0].dx, size.height);
    areaPath.lineTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlPoint = Offset(
        (current.dx + next.dx) / 2,
        current.dy,
      );
      
      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        next.dx,
        next.dy,
      );
      
      areaPath.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        next.dx,
        next.dy,
      );
    }

    // Complete area path
    areaPath.lineTo(points.last.dx, size.height);
    areaPath.close();

    // Draw area and line
    canvas.drawPath(areaPath, gradientPaint);
    canvas.drawPath(path, linePaint);

    // Draw points and labels
    for (int i = 0; i < points.length; i++) {
      final point = points[i];
      
      // Outer glow
      final glowPaint = Paint()
        ..color = Colors.green.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(point, 8, glowPaint);

      // White fill
      canvas.drawCircle(
        point,
        6,
        Paint()..color = Colors.white,
      );

      // Green border
      canvas.drawCircle(
        point,
        6,
        Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      // Value label - show actual consumption value
      if (data[i] > 0) { // Only show label if there's actual data
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
          canvas,
          Offset(
            point.dx - textPainter.width / 2,
            point.dy - 24,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MonthLabelsPainter extends CustomPainter {
  final List<String> monthLabels;
  final int displayMonths;

  MonthLabelsPainter(this.monthLabels, this.displayMonths);

  @override
  void paint(Canvas canvas, Size size) {
    // Use full width with minimal margins for maximum space
    final chartMargin = size.width * 0.05; // 5% margin on each side
    final chartWidth = size.width - (2 * chartMargin);
    final fullStepX = chartWidth / 11; // 11 intervals for 12 months

    // Draw all 12 month labels with cool modern design
    for (int i = 0; i < 12; i++) {
      final x = chartMargin + (i * fullStepX);
      final isActive = i < displayMonths;
      final monthNumber = i + 1;
      
      // Draw background circle for active months
      if (isActive) {
        final circlePaint = Paint()
          ..color = Colors.green.withOpacity(0.1)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(x, 10), 12, circlePaint);
        
        // Draw border circle
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
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, 10 - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}