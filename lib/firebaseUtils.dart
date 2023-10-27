import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/model/myUser.dart';
import 'model/task.dart';

class FireBaseUtils{

  static CollectionReference<Task> getTasksCollection(String uId) {
    // Create a CollectionReference that references the firestore collection
    return getUserCollection().doc(uId).collection(
        Task.collectionName).withConverter<Task>(
      fromFirestore: (snapshot, options) => Task.fromFirestore(snapshot.data()!),
      toFirestore: (value, options) => value.toFirestore(),
    );
  }

  static Future<void> addTaskToFireStore(Task task, String uId){
    var taskCollection = getTasksCollection(uId); // collection
    DocumentReference<Task> docRef = taskCollection.doc(); // document
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<void> deleteTaskFromFireStore(Task task, String uId) {
    return getTasksCollection(uId).doc(task.id).delete();
  }

  static Future<void> editTaskFireStore(Task task, String uId){
    return getTasksCollection(uId).doc(task.id).update({
      'title' : task.title,
      'description' : task.description,
      'date' : task.date?.millisecondsSinceEpoch, // Epoch time
      'isDone' : task.isDone
    });
  }

  static CollectionReference<MyUser> getUserCollection() {
    return FirebaseFirestore.instance.collection(
        MyUser.collectionName).withConverter<MyUser>(
      fromFirestore: (snapshot, options)
        => MyUser.fromFirestore(snapshot.data()),
      toFirestore: (user, options) => user.toFirestore()
    );

  }

  static Future<void> addUserToFirestore(MyUser myUser) {
    return getUserCollection().doc(myUser.id).set(myUser);
  }

  static Future<MyUser?> readUserFromFirestore(String uId) async {
    var querySnapshot = await getUserCollection().doc(uId).get();
    return querySnapshot.data();
  }

}