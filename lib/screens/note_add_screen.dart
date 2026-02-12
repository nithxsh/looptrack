import 'package:flutter/material.dart';
import '../services/persistent_notes_service.dart';

class NoteAddScreen extends StatefulWidget {
  const NoteAddScreen({super.key});

  @override
  State<NoteAddScreen> createState() => _NoteAddScreenState();
}

class _NoteAddScreenState extends State<NoteAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final PersistentNotesService _notesService = PersistentNotesService();

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
        title: const Text('Add Persistent Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Note Title',
                border: OutlineInputBorder(),
                hintText: 'e.g., Project Ideas',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content (optional)',
                border: OutlineInputBorder(),
                hintText: 'Write your notes here...',
              ),
              maxLines: 10,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.note_add),
              label: const Text('Add Note'),
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      _notesService
          .addNote(
        _titleController.text.trim(),
        content: _contentController.text.trim().isEmpty
            ? null
            : _contentController.text.trim(),
      )
          .then((_) {
        Navigator.pop(context);
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      });
    }
  }
}