import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trackit/components/my_drawer.dart';
import 'package:trackit/components/my_habit_tile.dart';
import 'package:trackit/components/my_heat_map.dart';
import 'package:trackit/database/habit_database.dart';
import 'package:trackit/models/habit.dart';
import 'package:trackit/pages/analysis.dart';
import 'package:trackit/pages/notification.dart';
import '../util/habit_util.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  final TextEditingController textController = TextEditingController();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(), // Main Home Page Content
    AnalysisPage(),
    NotificationPage(),
  ];

  void onTabselected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;

        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                style: TextStyle(color: colorScheme.inversePrimary),
                decoration: InputDecoration(
                  hintText: "Create a new habit",
                  hintStyle: TextStyle(color: colorScheme.inversePrimary),
                  filled: true,
                  fillColor: colorScheme.tertiary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                textController.clear();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: colorScheme.inversePrimary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String newHabitData = textController.text;
                context.read<HabitDatabase>().addHabit(newHabitData);
                Navigator.pop(context);
                textController.clear();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  void editHabitBox(Habit habit) {
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(controller: textController),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              context.read<HabitDatabase>().updateHabitName(
                habit.id,
                newHabitName,
              );
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure you want to delete?"),
        actions: [
          MaterialButton(
            onPressed: () {
              context.read<HabitDatabase>().deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Daily Do',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add, color: Colors.blue),
      ),
      body: _selectedIndex == 0
          ? ListView(
        children: [
          //_buildHeatMap(),
          _buildHabitList(),
        ],
      )
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => onTabselected(0),
            ),
            IconButton(
              icon: const Icon(Icons.analytics),
              onPressed: () => onTabselected(1),
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () => onTabselected(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchDate(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    List<Habit> currentHabits = habitDatabase.currentHabits;
    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final habit = currentHabits[index];
        bool isCompletedToday = isHabitCompletedToday(habit.completeDays);
        return MyHabitTile(
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value, habit),
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
