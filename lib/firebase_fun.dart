import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/task_model.dart';

class FirebaseFunctions {
  /// ✅ إرجاع كوليكشن البيانات
  static CollectionReference<TaskModel> getTasksCollection() {
    return FirebaseFirestore.instance
        .collection("Tasks")
        .withConverter<TaskModel>(
          fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
          toFirestore: (taskModel, _) => taskModel.toJson(),
        );
  }

  /// ✅ إضافة مهمة جديدة
  Future<void> addTask(TaskModel model) async {
    try {
      var collection = getTasksCollection();
      var docRef = collection.doc();
      model.id = docRef.id;
      await docRef.set(model); // استخدم await لضمان إضافة المهمة
      print("✅ Task Added Successfully: ${model.id}");
    } catch (e) {
      print("❌ Error Adding Task: $e");
      throw e;
    }
  }

  static Future<List<TaskModel>> getTasks(DateTime dateTime) async {
    try {
      // تحويل التاريخ إلى بداية اليوم
      DateTime onlyDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
      int timestamp =
          onlyDate.millisecondsSinceEpoch; // ✅ استخدم millisecondsSinceEpoch

      var collection = getTasksCollection();
      var snapshot = await collection.where("date", isEqualTo: timestamp).get();

      List<TaskModel> tasks = snapshot.docs.map((doc) => doc.data()).toList();

      print(
          "✅ Retrieved ${tasks.length} tasks for date: ${onlyDate.toIso8601String()}");
      return tasks;
    } catch (e) {
      print("❌ Error Fetching Tasks: $e");
      throw e;
    }
  }
  static Future<void> deletTask(String id){
   return getTasksCollection().doc(id).delete();
  }
  static Future<void> updateTask(TaskModel model){
   return getTasksCollection().doc(model.id).update(model.toJson());
  }
}
