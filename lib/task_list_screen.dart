// task_list_screen.dart
import 'package:flutter/material.dart';
import 'task.dart';
// Package to format dates

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> tasks = []; // List to store tasks
  final TextEditingController _taskController = TextEditingController();
  String _selectedPriority = 'Low'; // Default priority
  DateTime? _selectedDueDate;
  String _filter = 'All Tasks'; // Default filter

  // Method to add a task
  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(Task(
          name: _taskController.text,
          priority: _selectedPriority,
          dueDate: _selectedDueDate,
        ));
        _taskController.clear();
        _selectedDueDate = null; // Reset due date
      });
    }
  }

  // Method to toggle task completion
  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].isCompleted = !tasks[index].isCompleted;
    });
  }

  // Method to delete a task
  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  // Method to edit task name
  void _editTaskName(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        _taskController.text = tasks[index].name;
        return AlertDialog(
          title: const Text("Edit Task Name"),
          content: TextField(
            controller: _taskController,
            decoration: const InputDecoration(hintText: 'Enter new task name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  tasks[index].name = _taskController.text;
                  _taskController.clear();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Method to set due date
  void _pickDueDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      setState(() {
        _selectedDueDate = selectedDate;
      });
    }
  }

  // Method to filter tasks
  List<Task> _filteredTasks() {
    if (_filter == 'All Tasks') {
      return tasks;
    } else if (_filter == 'Completed Tasks') {
      return tasks.where((task) => task.isCompleted).toList();
    } else {
      return tasks.where((task) => !task.isCompleted).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          // Dropdown to filter tasks
          DropdownButton<String>(
            value: _filter,
            items: ['All Tasks', 'Completed Tasks', 'Pending Tasks']
                .map((filter) => DropdownMenuItem<String>(
                      value: filter,
                      child: Text(filter),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _filter = value!;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                // Text input field
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      hintText: 'Enter task name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Priority Dropdown
                DropdownButton<String>(
                  value: _selectedPriority,
                  items: ['Low', 'Medium', 'High']
                      .map((priority) => DropdownMenuItem<String>(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                // Due Date Picker
                ElevatedButton(
                  onPressed: _pickDueDate,
                  child: Text(
                    _selectedDueDate == null
                        ? 'Set Due Date'
                        : DateFormat('MM/dd/yyyy').format(_selectedDueDate!),
                  ),
                ),
                const SizedBox(width: 10),
                // Add button
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Task list view
            Expanded(
              child: ListView.builder(
                itemCount: _filteredTasks().length,
                itemBuilder: (context, index) {
                  final task = _filteredTasks()[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (_) => _toggleTaskCompletion(index),
                      ),
                      title: GestureDetector(
                        onTap: () => _editTaskName(index),
                        child: Text(
                          task.name,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Priority: ${task.priority}'),
                          if (task.dueDate != null)
                            Text(
                                'Due: ${DateFormat('MM/dd/yyyy').format(task.dueDate!)}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DateFormat {
  DateFormat(String s);

  format(DateTime dateTime) {}
}
