import 'package:flutter/material.dart';
import 'dart:io';
import 'note.dart';

class EditNoteDialog extends StatefulWidget {
  final Note note;
  final void Function(Note) onUpdateNote;

  const EditNoteDialog({
    super.key,
    required this.note,
    required this.onUpdateNote,
  });

  @override
  _EditNoteDialogState createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _numberController;
  late final TextEditingController _contentController;
  final List<String> _attachmentPaths = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _numberController = TextEditingController(text: widget.note.number);
    _contentController = TextEditingController(text: widget.note.content);
    _attachmentPaths.addAll(widget.note.attachmentPaths);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Note'),
      content: _buildEditNoteDialogContent(),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            final updatedNote = Note(
              title: _titleController.text,
              number: _numberController.text,
              content: _contentController.text,
              attachmentPaths: List.from(_attachmentPaths),
              comments: widget.note.comments,
            );
            widget.onUpdateNote(updatedNote);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildEditNoteDialogContent() {
    return SingleChildScrollView(
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
    );
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
  }

  void _pickImageFromGallery() async {
    // Logic to pick images
  }
}
