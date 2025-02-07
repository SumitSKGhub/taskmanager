import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskmanager/auth.dart';
import 'package:taskmanager/provider/task_filter_provider.dart';
import 'package:taskmanager/view/add_task.dart';
import 'package:taskmanager/view/task_tile.dart';
import '../provider/task_provider.dart';

final authStateProvider = StateProvider<User?>((ref) {
  return FirebaseAuth.instance.currentUser;
});

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;

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

    Future<void> signOut() async {
      await Auth().signOut();
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xFF888AF5),
          toolbarHeight: 140,
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.category_outlined),
                    const Spacer(),
                    Container(
                        height: 40,
                        width: 225,
                        child: TextField(
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                        )),
                    PopupMenuButton(
                        onSelected: (value) {
                          if (value == 2) {
                            signOut();
                          }
                        },
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                child: Text(user?.email ?? 'Please login'),
                                value: 1,
                              ),
                              PopupMenuItem(
                                child: Text('Sign Out'),
                                value: 2,
                              )
                            ])
                  ],
                ),
                Text(
                  '${DateTime.now().day} ${monthNames[DateTime.now().month - 1]} ${DateTime.now().year}',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Text(
                  'My tasks',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
          // TextField(
          //   decoration: InputDecoration(
          //       border:
          //           OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
          // ),
          ),
      backgroundColor: Color(0xFFF7F7F7),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Color(0xFF696DF0),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Text("Tap on the task to see more."),
                Expanded(child: TaskListPage()),
              ],
            ),
          ),
          Container(
            height: 75,
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: Icon(Icons.abc)),
                Expanded(child: Icon(Icons.calendar_today_outlined))
              ],
            ),
          )
        ],
      )),
    );
  }
}

class TaskListPage extends ConsumerWidget {
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

  String month = 'x';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    if (user == null) {
      return Center(child: Text('Please log in!'));
    }

    final taskList = ref.watch(taskListProvider);
    final filter = ref.watch(taskFilterProvider);

    return Column(
      children: [
        buildFilterOptions(context, ref),

        Expanded(
          child: taskList.when(
            data: (tasks) {
              final filteredTasks = tasks.where((task) {
                final matchesPriority = filter['priority'] == null ||
                    task.priority == filter['priority'];
                final matchesCompleted = filter['completed'] == null ||
                    task.completed == filter['completed'];
                return matchesPriority && matchesCompleted;
              }).toList();

              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return TaskTile(task: task, ref: ref);
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ],
    );
  }
}

Widget buildFilterOptions(BuildContext context, WidgetRef ref) {
  final filter = ref.watch(taskFilterProvider);

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      DropdownButton<String>(
        hint: Text("Priority"),
        value: filter['priority'],
        items: ['Low', 'Medium', 'High']
            .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                ))
            .toList(),
        onChanged: (value) {
          ref.read(taskFilterProvider.notifier).state = {
            ...filter,
            'priority': value,
          };
        },
      ),


      Row(
        children: [
          Text("Completed"),
          Switch(
            value: filter['completed'] ?? false,
            onChanged: (value) {
              ref.read(taskFilterProvider.notifier).state = {
                ...filter,
                'completed': value,
              };
            },
          ),
        ],
      ),

      ElevatedButton(
          onPressed: () {
        ref.read(taskFilterProvider.notifier).state = {
          'priority': null,
          'completed': false,
        };
          },
        child: Text('Reset'),
      ),
    ],
  );
}