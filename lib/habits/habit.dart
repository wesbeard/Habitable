import 'package:flutter/material.dart';
import '../saved_data.dart';

// A default habit with common info

class Habit {
  String name;
  String desc;

  Habit(String name, {String desc}) {
    this.name = name;
    this.desc = desc;
  }

  // Build a widget displaying only the name, desc, and delete button
  Widget build(BuildContext context, Function update) {
    return Card(
      child: ListTile(
        title: Text(this.name),
        subtitle: this.desc != null ? Text(this.desc) : null,
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

  void edit(BuildContext context, Function update) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);

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
                      decoration: const InputDecoration(
                        hintText: 'Enter a habit name',
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
                        hintText: 'Optional: Enter a habit description',
                      ),
                      validator: (String testDesc) {
                        if (testDesc == null || testDesc.isEmpty) {
                          desc = null;
                        } else {
                          desc = testDesc;
                        }
                        return null;
                      },
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
                            update();
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
