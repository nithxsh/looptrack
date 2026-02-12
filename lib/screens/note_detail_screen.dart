import 'package:flutter/material.dart';
import '../models/persistent_note.dart';
import '../services/persistent_notes_service.dart';

class NoteDetailScreen extends StatefulWidget {
  final PersistentNote note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final PersistentNotesService _notesService = PersistentNotesService();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController =
        TextEditingController(text: widget.note.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: 'Content',
              border: OutlineInputBorder(),
              hintText: 'Write your notes here...',
            ),
            maxLines: 15,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save Changes'),
            onPressed: _saveNote,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: Icon(Icons.delete_outline, color: Colors.red),
            label: Text(
              'Delete Note',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: _deleteNote,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }

  void _saveNote() {
    final updatedNote = widget.note.copyWith(
      title: _titleController.text.trim(),
      content: _contentController.text.trim().isEmpty
          ? null
          : _contentController.text.trim(),
    );

    _notesService.updateNote(updatedNote).then((_) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note saved')),
      );
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  void _deleteNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _notesService.deleteNote(widget.note.id!).then((_) {
                Navigator.pop(context); // dialog
                Navigator.pop(context); // screen
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}