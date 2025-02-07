import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'model/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  Future<void> _createUserDocumentIfNeeded() async {
    if (_userId == null) return;

    final userDocRef = _firestore.collection('users').doc(_userId);
    final userDoc = await userDocRef.get();

    if (!userDoc.exists) {
      await userDocRef.set({'createdAt': FieldValue.serverTimestamp()});
    }
  }

  Future<void> addTask(Task task) async {
    if (_userId == null) return;
    await _createUserDocumentIfNeeded();

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .add(task.toMap());
  }

  Stream<List<Task>> getTasks() {
    if (_userId == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .orderBy('dueDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Task.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> updateTask(Task task) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  Future<void> deleteTask(String taskId) async {
    if (_userId == null) return;

    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}
