import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/task_model.dart';

class FirebaseFunctions {
  static CollectionReference<TaskModel> getTasksCollection() =>
      FirebaseFirestore.instance.collection('tasks').withConverter<TaskModel>(
            fromFirestore: (docSnapshot, _) =>
                TaskModel.fromJson(docSnapshot.data()!),
            toFirestore: (taskModel, _) => taskModel.toJson(),
          );

  static Future<void> addTaskToFireStore(TaskModel task) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    DocumentReference<TaskModel> docRef = tasksCollection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<void> editTaskToFireStore(TaskModel task) async {
    // CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    // DocumentReference<TaskModel> docRef = tasksCollection.doc(task.id);
    // return docRef.update(task.toJson());
    // return tasksCollection.doc(task.id).update(task.toJson());
    try {
      CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('tasks');
      DocumentReference taskSoc = tasksCollection.doc(task.id);
      await taskSoc.update(task.toJson());
    } catch (e) {
      // print('error$e');
    }
  }

  static Future<List<TaskModel>> getAllTasksFromFirestore() async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  static Future<void> deleteTaskFromFirestore(String taskId) {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection();
    return tasksCollection.doc(taskId).delete();
  }
}
