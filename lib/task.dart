// task.dart
class Task {
  String name;
  bool isCompleted;
  String priority;

  var dueDate;

  Task({
    required this.name,
    this.isCompleted = false,
    this.priority = 'Low',
    this.dueDate,
  });
}
