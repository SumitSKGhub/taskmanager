import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/task_model.dart';
import '../provider/task_provider.dart';

class AddTaskPage extends ConsumerStatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends ConsumerState<AddTaskPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String? _date = '1';
  String _priority = 'Medium';

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Color lowColor = Colors.white;
  Color mediumColor = Colors.white;
  Color highColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF888AF5),
        title: Text(
          'Add Task',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFF7F7F7),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter task details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 16),
            // Title Input
            TextField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.text,
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: TextEditingController(
                text: _dueDate != null
                    ? "${_dueDate!.day} ${monthNames[_dueDate!.month - 1]}"
                    : "",
              ),
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Due Date",
                suffixIcon: Icon(Icons.calendar_today),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _priority = 'Low';
                      lowColor = Colors.blue;
                      mediumColor = Colors.white;
                      highColor = Colors.white;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: lowColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text('Low', style: TextStyle(color: Colors.black)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _priority = 'Medium';
                      lowColor = Colors.white;
                      mediumColor = Colors.orange;
                      highColor = Colors.white;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: mediumColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text('Medium', style: TextStyle(color: Colors.black)),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _priority = 'High';
                      lowColor = Colors.white;
                      mediumColor = Colors.white;
                      highColor = Colors.red;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: highColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text('High', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Align(
            alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  final task = Task(
                    id: '',
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dueDate: _dueDate!,
                    priority: _priority,
                  );
                  await ref.read(taskRepositoryProvider).addTask(task);
                  Navigator.pop(context);
                },
                child: Text('Add',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF696DF0),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
