import 'package:flutter/material.dart';
import 'package:task_list/models/task.dart';
import 'package:task_list/widgets/task_list_item.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> tasks = [];
  Task? taskDeleted;
  int? taskDeletedPosition;

  final TextEditingController taskController = TextEditingController();

  void add() {
    setState(() {
      Task newTask = Task(title: taskController.text, dateTime: DateTime.now());
      tasks.add(newTask);
      taskController.clear();
    });
  }

  void clearAllTasksConfirm() {
    Navigator.of(context).pop();

    setState(() {
      tasks.clear();
    });
  }

  void clearAllTasksCancel() {
    Navigator.of(context).pop();
  }

  void showClearAllTasks() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Limpar tudo?"),
              content: const Text(
                  "Você tem certeza que deseja apagar todas tarefas?"),
              actions: [
                TextButton(
                    onPressed: clearAllTasksCancel,
                    style: TextButton.styleFrom(primary: Colors.blue),
                    child: const Text("Cancelar")),
                TextButton(
                    onPressed: clearAllTasksConfirm,
                    style: TextButton.styleFrom(primary: Colors.red),
                    child: const Text("Limpar Tudo"))
              ],
            ));
  }

  void insertTaskDeleted(Task task) {
    setState(() {
      tasks.insert(taskDeletedPosition!, taskDeleted!);
    });
  }

  void onDelete(Task task) {
    taskDeleted = task;
    taskDeletedPosition = tasks.indexOf(task);

    setState(() {
      tasks.remove(task);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tarefa ${task.title} foi removida com sucesso!",
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "Desfazer",
          textColor: Colors.blue,
          onPressed: () => {insertTaskDeleted(task)},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: taskController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Adicione uma tarefa",
                          hintText: "Ex: Estudar Flutter"),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  ElevatedButton(
                      onPressed: add,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ))
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (Task task in tasks)
                      TaskListItem(task: task, onDelete: onDelete)
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child:
                        Text("Você possui ${tasks.length} tarefas pendentes"),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: showClearAllTasks,
                    child: const Text(
                      "Limpar tudo",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.all(14),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
