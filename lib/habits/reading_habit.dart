import 'package:flutter/material.dart';
import 'habit.dart';
import '../saved_data.dart';
import '../custom-widgets/custom_number_picker.dart';

class ReadingHabit extends Habit {

  bool complete;
  int pages;
  String bookName;

  ReadingHabit(String name, {String bookName = '', int pages = 0, bool checked = false})
      : super(name) {
    this.complete = checked;
    this.pages = pages;
    this.bookName = bookName;
  }

  // Overridden from parent, displays name, desc, delete, and checkbox
  @override
  Widget build(BuildContext context, Function update) {
    return Card(
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Checkbox(
            activeColor: Colors.amber,
            value: this.complete,
            onChanged: (bool newValue) {
              this.complete = newValue;
              update();
              },
            ),
            SizedBox(width: 10),
            Icon(Icons.book_outlined),
          ],
        ),
        title: this.bookName != null ? Text(this.name + ': ' + this.bookName) : Text(this.name),
        subtitle: Text('Page Goal: ${this.pages}'),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => {this.edit(context, update)},
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => {Data.removeHabit(update, this)},
              ),
            ],
        ),
      ),
    );
  }

  // TODO: Add time interval (daily, weekly, etc)
  static void newReadingForm(BuildContext context, Function update) {

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    String name;
    int pages = 0;
    String bookName;
    Habit newHabit;

    void updatePages(int currentPages) {
      pages = currentPages;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Create a Reading Habit'),
        ),
        body: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      initialValue: 'Reading',
                      decoration: const InputDecoration(
                        hintText: 'What should the habit be called?',
                      ),
                      validator: (String testName) {
                        if (testName == null || testName.isEmpty) {
                          return 'Please enter a name';
                        }
                        name = testName;
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Optional: What\'re you reading?',
                      ),
                      validator: (String testBook) {
                        if (testBook == null || testBook.isEmpty) {
                          bookName = null;
                        } else {
                          print(testBook);
                          bookName = testBook;
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('How many pages do you want to read?'),
                    ),
                    CustomNumberPicker(
                      update: updatePages,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: theme.primaryColor,
                          onPrimary: theme.primaryColorDark,
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            newHabit = ReadingHabit(name, bookName: bookName, pages: pages);
                            Data.newHabit(update, newHabit);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Create'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }));
  }

  @override
  void edit(BuildContext context, Function update) {

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);

    void updatePages(int currentPages) {
      pages = currentPages;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Habit'),
        ),
        body: Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      initialValue: this.name,
                      decoration: const InputDecoration(
                        hintText: 'What should the habit be called?',
                      ),
                      validator: (String testName) {
                        if (testName == null || testName.isEmpty) {
                          return 'Please enter a name';
                        }
                        name = testName;
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: this.bookName != null ? this.bookName : null,
                      decoration: const InputDecoration(
                        hintText: 'Optional: What\'re you reading?',
                      ),
                      validator: (String testBook) {
                        if (testBook == null || testBook.isEmpty) {
                          bookName = null;
                        } else {
                          print(testBook);
                          bookName = testBook;
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('How many pages do you want to read?'),
                    ),
                    CustomNumberPicker(
                      update: updatePages,
                      initialValue: pages != null ? pages : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: theme.primaryColor,
                          onPrimary: theme.primaryColorDark,
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }));
  }
}
