import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/task.dart';

class FireBaseUtils{

  static CollectionReference<Task> getTasksCollection() {
    // Create a CollectionReference that references the firestore collection
    return FirebaseFirestore.instance.collection(
        Task.collectionName).withConverter<Task>(
      fromFirestore: (snapshot, options) => Task.fromFirestore(snapshot.data()!),
      toFirestore: (value, options) => value.toFirestore(),
    );
  }

  static Future<void> addTaskToFireStore(Task task){
    var taskCollection = getTasksCollection(); // collection
    DocumentReference<Task> docRef = taskCollection.doc(); // document
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task) {
    return getTasksCollection().doc(task.id).delete();
  }

}