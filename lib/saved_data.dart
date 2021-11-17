import 'habits/habit.dart';
import 'habits/checkbox_habit.dart';
import 'habits/reading_habit.dart';
// Used to store static data for related classes

class Data {

  // The list of habits with default debug values
  static var habits = <Habit>[
    Habit('Habit', desc:'A barebones habit'),
    CheckboxHabit('Checkbox', desc: 'A habit with a checkbox'),
    ReadingHabit('Reading', bookName: 'War & Peace', pages: 10)
  ];

  static void newHabit(Function update, Habit habit) {
    habits.add(habit);
    update();
  }

  static void removeHabit(Function update, Habit habit) {
    habits.remove(habit);
    update();
  }
}
