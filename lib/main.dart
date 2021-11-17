import 'package:flutter/material.dart';
import 'saved_data.dart';
import 'custom-widgets/expandable_fab.dart';
import 'habits/checkbox_habit.dart';
import 'habits/reading_habit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habitable',
      home: MyHomePage(title: 'Habitable'),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amber,
        accentColor: Colors.amber,
        buttonColor: Colors.amber,
        primaryColorLight: Colors.white,

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Update the state based on the values in data
  // Passed into sub-functions and called to update data in parent
  void _update() {
    setState(() {});
  }

  // List widget that displays a list of habit cards
  Widget _habitsDisplay(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: Data.habits.length,
      itemBuilder: (context, i) {
        var habit = Data.habits[i];
        return habit.build(context, _update);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _habitsDisplay(context),
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: () {
              CheckboxHabit.newCheckboxForm(context, _update);
            },
            icon: const Icon(Icons.check_box),
            tooltip: 'Checkbox',
          ),
          ActionButton(
            onPressed: () {
              CheckboxHabit.newCheckboxForm(context, _update);
            },
            icon: const Icon(Icons.directions_run),
            tooltip: 'Exercise',
          ),
          ActionButton(
            onPressed: () {
              ReadingHabit.newReadingForm(context, _update);
            },
            icon: const Icon(Icons.menu_book_sharp),
            tooltip: 'Reading',
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
