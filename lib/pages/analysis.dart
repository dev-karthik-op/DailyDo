
// Analysis Page

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackit/database/habit_database.dart';
import 'package:trackit/models/habit.dart';
import 'package:intl/intl.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  static const Color heatActiveColor = Colors.indigo; // active day box
  static const Color heatInactiveColor = Colors.grey; // inactive day box
  static const Color cardBackgroundColor = Colors.indigo;
  static const Color cardTextColor = Colors.white;

  String _selectedView = 'Monthly';
  String _selectedGrid = 'Detailed';

  final List<String> viewOptions = ['Weekly', 'Monthly'];
  final List<String> gridOptions = ['Compact', 'Detailed'];

  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final habitDatabase = context.watch<HabitDatabase>();
    final habits = habitDatabase.currentHabits;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildHeatMap(context, habits),
            const SizedBox(height: 16),
            Expanded(child: _buildHabitGrid(context, habits)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // View Dropdown
          Row(
            children: [
              const SizedBox(width: 8),
              _buildDropdown(
                items: viewOptions,
                currentValue: _selectedView,
                onChanged: (val) => setState(() => _selectedView = val!),
              ),
            ],
          ),
          // Grid Dropdown
          Row(
            children: [
              const SizedBox(width: 8),
              _buildDropdown(
                items: gridOptions,
                currentValue: _selectedGrid,
                onChanged: (val) => setState(() => _selectedGrid = val!),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required List<String> items,
    required String currentValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: currentValue,
        items:
            items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                )
                .toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        dropdownColor: Theme.of(context).colorScheme.surface,
        iconEnabledColor: Theme.of(context).colorScheme.onSecondaryContainer,
      ),
    );
  }

  Widget _buildHeatMap(BuildContext context, List<Habit> habits) {
    // Build heatmap dataset
    final Map<String, int> heatMap = {};
    for (final habit in habits) {
      for (final date in habit.completeDays) {
        final include =
            _selectedView == 'Monthly'
                ? date.year == now.year && date.month == now.month
                : date.isAfter(now.subtract(const Duration(days: 7)));
        if (!include) continue;
        final key = DateFormat('yyyy-MM-dd').format(date);
        heatMap[key] = (heatMap[key] ?? 0) + 1;
      }
    }

    // Determine days to show
    final List<DateTime> daysToShow =
        _selectedView == 'Monthly'
            ? List.generate(
              DateUtils.getDaysInMonth(now.year, now.month),
              (i) => DateTime(now.year, now.month, i + 1),
            )
            : List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));

    // Scrollable strip
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 60,
        child: LayoutBuilder(
          builder:
              (ctx, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // ← add this
                    children:
                        daysToShow.map((date) {
                          final key = DateFormat('yyyy-MM-dd').format(date);
                          final count = heatMap[key] ?? 0;
                          return Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color:
                                  count > 0
                                      ? heatActiveColor
                                      : heatInactiveColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              DateFormat('d').format(date),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildHabitGrid(BuildContext context, List<Habit> habits) {
    final crossAxisCount = _selectedGrid == 'Compact' ? 2 : 1;
    final aspectRatio = _selectedGrid == 'Compact' ? 1.2 : 3.0;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: habits.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: aspectRatio,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final habit = habits[index];
        final count =
            habit.completeDays.where((date) {
              return _selectedView == 'Monthly'
                  ? date.year == now.year && date.month == now.month
                  : date.isAfter(now.subtract(const Duration(days: 7)));
            }).length;

        return Container(
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cardTextColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Completed : $count',
                style: TextStyle(
                  color: cardTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
