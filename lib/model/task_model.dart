import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  // final String date;
  final String priority;
  final bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    // required this.date,
    required this.priority,
    this.completed = false,
  });

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'],
      description: map['description'],
      dueDate: (map['dueDate'] as Timestamp).toDate(),
      priority: map['priority'],
      completed: map['completed'] ?? false,
      // date: map['date'],
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'completed': completed,
    };
  }
}
