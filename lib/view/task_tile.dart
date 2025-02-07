import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmanager/model/task_model.dart';
import 'package:taskmanager/provider/task_provider.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final WidgetRef ref;

  TaskTile({required this.task, required this.ref});

  List<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Jun',
    'Jul',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18),
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          ref.read(taskRepositoryProvider).deleteTask(task.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${task.title} deleted")),
          );
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: ListTile(
            onTap: () {
              showEditDialog(context, task, ref);
            },
            leading: Icon(
              task.completed ? Icons.check_circle : Icons.circle_outlined,
              color: task.completed ? Colors.green : Color(0xFF888AF5),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF111827),
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              '${task.dueDate.day} ${monthNames[task.dueDate.month - 1]}',
              style: TextStyle(fontSize: 12),
            ),
            trailing: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _getPriorityColor(task.priority),
              ),
              child: Text(task.priority),
            ),
          ),
        ),
      ),
    );
  }


  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return Color(0xFF888AF5);
      case 'Medium':
        return Colors.orangeAccent;
      case 'High':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }
}

void showEditDialog(BuildContext context, Task task, WidgetRef ref) {
  TextEditingController titleController = TextEditingController(text: task.title);
  TextEditingController descriptionController = TextEditingController(text: task.description);
  bool isCompleted = task.completed;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Edit Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: isCompleted,
                      onChanged: (value) {
                        setState(() {
                          isCompleted = value!;
                        });
                      },
                    ),
                    Text('Mark as Complete'),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final updatedTask = Task(
                    id: task.id,
                    title: titleController.text,
                    description: descriptionController.text,
                    dueDate: task.dueDate,
                    priority: task.priority,
                    completed: isCompleted,
                  );

                  try {
                    await ref.read(taskRepositoryProvider).updateTask(updatedTask);
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update task')),
                    );
                  }
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}

