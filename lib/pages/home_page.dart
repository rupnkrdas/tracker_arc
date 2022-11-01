import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker_arc/components/habit_tile.dart';
import 'package:tracker_arc/components/monthly_summary.dart';
import 'package:tracker_arc/components/my_fab.dart';
import 'package:tracker_arc/components/my_alert_box.dart';
import 'package:tracker_arc/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:tracker_arc/datetime/date_time.dart';

class HomePage extends StatefulWidget {
  static String routeName = 'home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    // if there is no current habit list, then it is the 1st time ever opening the app
    // then create default data
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }

    // there already exists data, this is not the first time
    else {
      db.loadData();
    }

    // update the database
    db.updateDatabase();

    super.initState();
  }

  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    HapticFeedback.selectionClick();
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  // tile was tapped
  void tilePressed(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      db.todaysHabitList[index][1] = !db.todaysHabitList[index][1];
    });
    db.updateDatabase();
  }

  // create a new habit
  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    HapticFeedback.heavyImpact();
    // show alert dialog for user to enter the new habit details
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Enter habit name..',
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save new habit
  void saveNewHabit() {
    if (_newHabitNameController.text.trim() != '') {
      // add new habit to todays habit list
      setState(() {
        db.todaysHabitList.add([_newHabitNameController.text, false]);
      });

      // clear textfield
      _newHabitNameController.clear();
      // pop dialog box
      Navigator.of(context).pop();
      db.updateDatabase();
    } else {
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              backgroundColor: Colors.grey[800],
              content: Text(
                'Please enter a valid Habit!',
                style: TextStyle(color: Colors.grey.shade200),
                textAlign: TextAlign.center,
              ),
            );
          }));
    }
  }

  // cancel new habit
  void cancelDialogBox() {
    // clear textfield
    _newHabitNameController.clear();

    // pop dialog box
    Navigator.of(context).pop();
  }

  // open habit settings to edit
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: db.todaysHabitList[index][0],
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      backgroundColor: Colors.black,
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView(
            children: [
              // greeting
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                child: Text(
                  'signed in as: ${user?.email!}',
                  style: TextStyle(color: Colors.grey.shade200),
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              // todays day
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 16),
                        child: const Text(
                          'Today',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 16),
                        child: Text(
                          '${DateFormat('MMMM').format(DateTime.now())}, ${DateTime.now().day}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      HapticFeedback.lightImpact();
                      await FirebaseAuth.instance.signOut();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.logout,
                        color: Colors.redAccent,
                        size: 28,
                      ),
                    ),
                  )
                ],
              ),
              // monthly summary heat map
              MonthlySummary(
                datasets: db.heatMapDataSet,
                // startDate: _myBox.get("START_DATE"),

                startDate: convertDateTimeToString(
                    DateTime.now().subtract(const Duration(days: 30))),
              ),

              // list of habits
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: db.todaysHabitList.length,
                itemBuilder: (context, index) {
                  return HabitTile(
                    habitName: db.todaysHabitList[index][0],
                    habitCompleted: db.todaysHabitList[index][1],
                    onChanged: (value) => checkBoxTapped(value, index),
                    settingsTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                    onTap: () {
                      setState(() {
                        tilePressed(index);
                      });
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
