
// Habit Database

import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trackit/models/app_settings.dart';
import 'package:trackit/models/habit.dart';

class HabitDatabase extends  ChangeNotifier {
  static late Isar isar;

  // set up

  // initialize
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,

    );
  }

  // save first date of app startup (for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if(existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  // get first date of app startup (for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // C R U D Operations

  // list of habits
  final List<Habit> currentHabits = [];

  // create - add a new habits
  Future<void> addHabit(String habitName) async {
    // create a new habit
    final newHabit = Habit()..name = habitName;
    // save to db
    await isar.writeTxn(() => isar.habits.put(newHabit));
    // re-read from db
    readHabits();
  }

  // read - read saved habit from db
  Future<void> readHabits() async {
    // fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();
    // give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);
    // update UI
    notifyListeners();
  }

  // update - check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the specific habit
    final habit = await isar.habits.get(id);

    // update completion status
    if(habit != null) {
      await isar.writeTxn(() async {
        // if habit is completed -> add the current date to the completedDays list
        if(isCompleted && !habit.completeDays.contains(DateTime.now())) {
          // today
          final today = DateTime.now();
          // add the current date if it's not already in the list
          habit.completeDays.add(
            DateTime(
              today.year,
              today.month,
              today.day,
            ),
          );
        }
        // if habit is NoT completed -> remove the current date from the list
        else {
          // remove the current date if the habit is marked as not completed
          habit.completeDays.removeWhere((date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day
          );
        }
        // save the update habits back to the db
        await isar.habits.put(habit);
      });
    }
    // re-read from db
    readHabits();
  }

  // update - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    // find the specific habit
    final habit = await isar.habits.get(id);
    // update habit name
    if(habit != null) {
      // update name
      await isar.writeTxn(() async{
        habit.name = newName;
        // save update habit back to the db
        await isar.habits.put(habit);
      });
    }
    // re-read from db
    readHabits();
  }

  // delete - delete habit
  Future<void> deleteHabit(int id) async {
    // perform the delete
    await isar.writeTxn(() async{
      await isar.habits.delete(id);
    });
    // re-read from db
    readHabits();
  }
}