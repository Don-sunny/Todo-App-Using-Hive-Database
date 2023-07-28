import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/add_todo.dart';
import 'package:todo_app/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Box todoBox = Hive.box<Todo>('todo');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: ValueListenableBuilder(
        valueListenable: todoBox.listenable(),
        builder: (BuildContext context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No Todo is available',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            );
          } else {
            return ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: box.length,
              itemBuilder: (context, index) {
                Todo todo = box.getAt(index);
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: todo.isCompleted ? Colors.green : Colors.black,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      Todo newTodo =
                          Todo(title: todo.title, isCompleted: value!);
                      box.putAt(index, newTodo);
                    },
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        box.deleteAt(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Todo Deleted successfully'),
                          ),
                        );
                      },
                      icon: const Icon(
                        CupertinoIcons.delete,
                        color: Colors.red,
                      )),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTodo(),
              ));
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
