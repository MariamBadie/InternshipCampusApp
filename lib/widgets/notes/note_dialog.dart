import 'package:flutter/material.dart';
import 'package:campus_app/widgets/notes/note.dart';
import 'package:campus_app/widgets/notes/note_dialog.dart';
import 'dart:io';

class NoteDialog extends StatefulWidget {
  final void Function(Note) onAddNote;

  const NoteDialog({super.key, required this.onAddNote});

  @override
  _NoteDialogState createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _attachmentPaths = [];

  void _showAttachmentSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Attachment Source'),
          content: _buildAttachmentSourceDialogContent(),
        );
      },
    );
  }

  Widget _buildAttachmentSourceDialogContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.insert_drive_file),
          title: const Text('Pick from File System'),
          onTap: _pickFile,
        ),
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Pick from Photos'),
          onTap: _pickImageFromGallery,
        ),
      ],
    );
  }

  void _pickFile() async {
    // Logic to pick files
  }

  void _pickImageFromGallery() async {
    // Logic to pick images
  }

  void _clearFields() {
    _titleController.clear();
    _numberController.clear();
    _contentController.clear();
    _attachmentPaths.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Note'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Subject name'),
            ),
            TextField(
              controller: _numberController,
              decoration:
                  const InputDecoration(hintText: 'Lecture/Tutorial Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(hintText: 'Note Content'),
              maxLines: 3,
            ),
            ElevatedButton(
              onPressed: _showAttachmentSourceDialog,
              child: const Text('Attach Files'),
            ),
            if (_attachmentPaths.isNotEmpty)
              Wrap(
                children: _attachmentPaths.map((path) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(path),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
            _clearFields();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            final note = Note(
              title: _titleController.text,
              number: _numberController.text,
              content: _contentController.text,
              attachmentPaths: List.from(_attachmentPaths),
              comments: [],
            );
            widget.onAddNote(note);
            Navigator.of(context).pop();
            _clearFields();
          },
        ),
      ],
    );
  }
}
