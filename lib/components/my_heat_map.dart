import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final Map<DateTime, int> datasets;
  final DateTime startDate;

  const MyHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
  });

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: startDate,
        endDate: DateTime.now(),
        datasets: datasets,
        colorMode: ColorMode.color,
        defaultColor: Theme.of(context).colorScheme.secondary,
        textColor: Colors.white,
        showColorTip: false,
        showText: false,
        scrollable: true,
        size: 30,
        colorsets:{
          1: Colors.indigo.shade200, // calendar color scheme
          2: Colors.indigo.shade300,
          3: Colors.indigo.shade400,
          4: Colors.indigo.shade500,
          5: Colors.indigo.shade600,
        },
    );
  }
}
