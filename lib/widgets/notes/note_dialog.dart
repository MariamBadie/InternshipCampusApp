import 'package:flutter/material.dart';
import 'package:campus_app/backend/Model/notesbackend.dart';
import 'package:campus_app/widgets/notes/note_dialog.dart';
import 'package:campus_app/backend/Controller/notescontroller.dart';

import 'dart:io';

class NoteDialog extends StatefulWidget {
  final NotesController notesController;

  const NoteDialog({Key? key, required this.notesController}) : super(key: key);

  @override
  _NoteDialogState createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _attachmentPaths = [];

  @override
  void dispose() {
    _titleController.dispose();
    _numberController.dispose();
    _contentController.dispose();
    super.dispose();
  }

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
    Navigator.of(context).pop(); // Close the attachment source dialog
  }

  void _pickImageFromGallery() async {
    // Logic to pick images
    Navigator.of(context).pop(); // Close the attachment source dialog
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
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          File(path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () => _removeAttachment(path),
                        ),
                      ),
                    ],
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
          onPressed: () async {
            if (_titleController.text.isEmpty ||
                _numberController.text.isEmpty ||
                _contentController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please fill in all fields')),
              );
              return;
            }
            final note = Note(
              title: _titleController.text,
              number: _numberController.text,
              content: _contentController.text,
              attachmentPaths: List.from(_attachmentPaths),
              comments: [],
            );
            try {
              await widget.notesController.addNote(note);
              Navigator.of(context).pop();
              _clearFields();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error adding note: $e')),
              );
            }
          },
        ),
      ],
    );
  }

  void _removeAttachment(String path) {
    setState(() {
      _attachmentPaths.remove(path);
    });
  }
}
