import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmanager/auth.dart';
import '../model/task_model.dart';
import '../task_repository.dart';

final taskRepositoryProvider = Provider((ref) => TaskRepository());

final userProvider = StateProvider<User?>((ref){
  return Auth().currentUser;
});

final taskListProvider = StreamProvider<List<Task>>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasks();
});
