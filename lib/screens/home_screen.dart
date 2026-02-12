import 'package:flutter/material.dart';
import '../services/daily_tasks_service.dart';
import '../services/persistent_notes_service.dart';
import '../services/history_service.dart';
import '../services/reset_service.dart';
import 'history_screen.dart';
import 'task_add_screen.dart';
import 'note_add_screen.dart';
import 'note_detail_screen.dart';
import 'widgets/home_widget.dart';
import 'widgets/daily_task_item.dart';
import 'widgets/note_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DailyTasksService _tasksService = DailyTasksService();
  final PersistentNotesService _notesService = PersistentNotesService();
  final HistoryService _historyService = HistoryService();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LoopTrack'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Daily Loop'),
              Tab(text: 'Persistent Notes'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _DailyTasksTab(
              tasksService: _tasksService,
            ),
            _PersistentNotesTab(
              notesService: _notesService,
            ),
          ],
        ),
        floatingActionButton: _buildFab(),
      ),
    );
  }

  Widget? _buildFab() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () async {
        final index = DefaultTabController.of(context).index;
        if (index == 0) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskAddScreen()),
          );
          setState(() {});
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteAddScreen()),
          );
          setState(() {});
        }
      },
    );
  }
}

class _DailyTasksTab extends StatefulWidget {
  final DailyTasksService tasksService;

  const _DailyTasksTab({required this.tasksService});

  @override
  State<_DailyTasksTab> createState() => _DailyTasksTabState();
}

class _DailyTasksTabState extends State<_DailyTasksTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.tasksService.getAllTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data ?? [];

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.checklist, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No daily tasks yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TaskAddScreen()),
                    );
                    setState(() {});
                  },
                  child: const Text('Add your first task'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildProgressHeader(tasks),
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) async {
                  await widget.tasksService
                      .reorderTasks(oldIndex, newIndex);
                  setState(() {});
                },
                children: [
                  for (int i = 0; i < tasks.length; i++)
                    DailyTaskItem(
                      key: ValueKey(tasks[i].id),
                      task: tasks[i],
                      onTap: () async {
                        await widget.tasksService.toggleTask(tasks[i]);
                        setState(() {});
                      },
                      onDelete: () async {
                        await widget.tasksService.deleteTask(tasks[i].id!);
                        setState(() {});
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProgressHeader(List tasks) {
    final completed = tasks.where((t) => t.isCompleted).length;
    final total = tasks.length;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$completed / $completed',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: progress == 1.0 ? Colors.green : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress == 1.0 ? Colors.green : Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PersistentNotesTab extends StatefulWidget {
  final PersistentNotesService notesService;

  const _PersistentNotesTab({required this.notesService});

  @override
  State<_PersistentNotesTab> createState() => _PersistentNotesTabState();
}

class _PersistentNotesTabState extends State<_PersistentNotesTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.notesService.getAllNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final notes = snapshot.data ?? [];

        if (notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.note, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No persistent notes yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NoteAddScreen()),
                    );
                    setState(() {});
                  },
                  child: const Text('Add your first note'),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteItem(
              note: notes[index],
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteDetailScreen(note: notes[index]),
                  ),
                );
                setState(() {});
              },
              onDelete: () async {
                await widget.notesService.deleteNote(notes[index].id!);
                setState(() {});
              },
            );
          },
        );
      },
    );
  }
}