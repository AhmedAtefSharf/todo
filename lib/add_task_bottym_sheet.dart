import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/firebase_fun.dart';
import 'package:todo/task_model.dart';

class AddTaskBottomSheet extends StatefulWidget {
  AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Add New Task",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 18),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
          SizedBox(height: 24),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
          SizedBox(height: 18),
          Text("Select Date", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          GestureDetector(
            onTap: chooseYourDate,
            child: Center(
              child: Text(
                DateFormat('yyyy-MM-dd').format(selectedDate),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.blue),
              ),
            ),
          ),
          SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                "Add",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// اختيار التاريخ
  Future<void> chooseYourDate() async {
    DateTime? chosenDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: selectedDate,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (chosenDate != null) {
      setState(() {
        selectedDate = chosenDate;
      });
    }
  }

  /// إضافة المهمة إلى Firebase
  Future<void> addTask() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isEmpty || title.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title must be at least 3 characters")),
      );
      return;
    }

    if (description.isEmpty || description.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Description must be at least 5 characters")),
      );
      return;
    }

    TaskModel model = TaskModel(
      title: title,
      description: description,
      date: DateTime(selectedDate.year, selectedDate.month, selectedDate.day).millisecondsSinceEpoch, // ✅ حفظ التاريخ فقط بدون الوقت
    );

    try {
      await FirebaseFunctions().addTask(model);
      Navigator.pop(context); // إغلاق الـ BottomSheet عند النجاح
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add task: $error")),
      );
    }
  }
}
