import 'package:flutter/material.dart';

/// Home Screen Widget for quick task toggling
/// Implementation using home_widget package (optional)
/// 
/// Note: Full widget implementation requires:
/// 1. home_widget package in pubspec.yaml
/// 2. Android widget configuration in AndroidManifest.xml
/// 3. Widget registration in MainActivity.kt or via BroadcastReceiver
/// 
/// For complete home screen widget, add these to pubspec.yaml:
/// dependencies:
///   home_widget: ^0.2.0
/// 
/// Android widget XML would be in:
/// android/app/src/main/res/xml/home_widget.xml

class HomeWidget {
  static const String widgetGroupId = 'com.looptrack.app.home_widget';

  static Future<void> updateWidget({
    required int completedTasks,
    required int totalTasks,
  }) async {
    final data = {
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
      'completionRate': totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0.0,
      'lastUpdated': DateTime.now().toIso8601String(),
    };

    await _sendDataToWidget(data);
  }

  static Future<void> _sendDataToWidget(Map<String, dynamic> data) async {
    // This would use home_widget package when integrated
    debugPrint('📱 Widget data: $data');
  }

  static Future<bool> isWidgetActive() async {
    // Check if home widget is enabled
    return false;
  }

  static Future<void> toggleTask(int taskId) async {
    // Toggle task from widget
    debugPrint('🎯 Toggle task $taskId from widget');
  }
}

class WidgetPlaceholder extends StatelessWidget {
  const WidgetPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.apps, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              const Text(
                'Home Screen Widget',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Add LoopTrack widget to your home screen for quick task access without opening the app.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}