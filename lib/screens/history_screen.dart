import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, HistoryEntry> _historyMap = {};
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final entries = await _historyService.getHistory(days: 90);
    final stats = await _historyService.getStats();

    final Map<DateTime, HistoryEntry> historyMap = {};
    for (var entry in entries) {
      final parts = entry.date.split('-');
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      historyMap[date] = entry;
    }

    setState(() {
      _historyMap = historyMap;
      _stats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCard(),
            const SizedBox(height: 16),
            _buildCalendar(),
            const SizedBox(height: 16),
            if (_selectedDay != null) _buildDayDetail(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _StatRow(
              label: 'Total Days',
              value: '${_stats['totalDays'] ?? 0}',
              icon: Icons.calendar_today,
            ),
            _StatRow(
              label: 'Completion Rate',
              value:
                  '${(_stats['completionRate'] as num?)?.toStringAsFixed(0) ?? 0}%',
              icon: Icons.pie_chart,
              color: (_stats['completionRate'] as num?) != null &&
                      (_stats['completionRate'] as num) >= 80
                  ? Colors.green
                  : Colors.blue,
            ),
            _StatRow(
              label: 'Perfect Days',
              value: '${_stats['perfectDays'] ?? 0}',
              icon: Icons.star,
              color: Colors.amber,
            ),
            _StatRow(
              label: 'Best Streak',
              value: '${_stats['bestStreak'] ?? 0} days',
              icon: Icons.local_fire_department,
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: TableCalendar(
          firstDay: DateTime.utc(2024, 1, 1),
          lastDay: DateTime.now(),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarFormat: CalendarFormat.month,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          eventLoader: (day) {
            final entry = _getEntryForDay(day);
            return entry != null ? [entry] : [];
          },
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayDetail() {
    final entry = _getEntryForDay(_selectedDay!);
    if (entry == null) return const SizedBox();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMEd().format(_selectedDay!),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: entry.completionRate,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 8),
            Text(
              '${entry.completedTasks}/${entry.totalTasks} tasks completed',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Consistency Score: ${entry.consistencyScore}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  HistoryEntry? _getEntryForDay(DateTime day) {
    return _historyMap[DateTime(day.year, day.month, day.day)];
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }
}