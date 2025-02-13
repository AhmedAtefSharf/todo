import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:todo/firebase_fun.dart';
import 'package:todo/task_item.dart';
import 'package:todo/task_model.dart';

class TasksTap extends StatefulWidget {
   TasksTap({super.key});

  @override
  State<TasksTap> createState() => _TasksTapState();
}

class _TasksTapState extends State<TasksTap> {
  DateTime dateTime =DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarTimeline(
          initialDate: dateTime,
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          onDateSelected: (date){
            dateTime =date;
            setState(() {

            });
          },
          leftMargin: 20,
          monthColor: Colors.black,
          dayColor: Colors.blue,
          activeDayColor: Colors.white,
          activeBackgroundDayColor: Colors.blueAccent,
          selectableDayPredicate: (date) => date.day != 23,
          locale: 'en',
        ),
        SizedBox(height: 24),
        Expanded(
          child: FutureBuilder<List<TaskModel>>(
            future: FirebaseFunctions.getTasks(dateTime),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              var tasks = snapshot.data ?? [];

              if (tasks.isEmpty) {
                return Center(child: Text("No Tasks Available"));
              }

              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return TaskItem(task: tasks[index]);
                },
              );
            },
          ),
        )

      ],
    );
  }
}
