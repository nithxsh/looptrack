import 'package:flutter/material.dart';
import '../models/daily_task.dart';

class DailyTaskItem extends StatelessWidget {
  final DailyTask task;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const DailyTaskItem({
    super.key,
    required this.task,
    required this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      onDismissed: (_) {
        onDelete?.call();
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          return await _showConfirmationDialog(context);
        }
        return false;
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          leading: Checkbox(
            value: task.isCompleted,
            onChanged: (_) => onTap(),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: task.isCompleted ? Colors.grey : null,
            ),
          ),
          subtitle: task.description != null && task.description!.isNotEmpty
              ? Text(
                  task.description!,
                  style: const TextStyle(fontSize: 12),
                )
              : null,
          trailing: task.isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
              : const Icon(Icons.radio_button_unchecked, size: 20),
        ),
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text('This will delete "${task.title}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}