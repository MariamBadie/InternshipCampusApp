import 'package:flutter/material.dart';
import 'dart:io';
import 'package:campus_app/backend/Model/notesbackend.dart';
import 'package:campus_app/backend/Controller/notescontroller.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class EditNoteDialog extends StatefulWidget {
  final Note note;
  final NotesController notesController;

  const EditNoteDialog({
    Key? key,
    required this.note,
    required this.notesController,
  }) : super(key: key);

  @override
  _EditNoteDialogState createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _numberController;
  late final TextEditingController _contentController;
  late List<String> _attachmentPaths;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _numberController = TextEditingController(text: widget.note.number);
    _contentController = TextEditingController(text: widget.note.content);
    _attachmentPaths = List.from(widget.note.attachmentPaths);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _numberController.dispose();
    _contentController.dispose();
    super.dispose();
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
          onPressed: () async {
            final updatedNote = Note(
              id: widget.note.id,
              title: _titleController.text,
              number: _numberController.text,
              content: _contentController.text,
              attachmentPaths: _attachmentPaths,
              comments: widget.note.comments,
            );
            await widget.notesController.updateNote(updatedNote);
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
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildAttachmentThumbnail(path),
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
    );
  }

  Widget _buildAttachmentThumbnail(String path) {
    try {
      return Image.file(
        File(path),
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 100,
            height: 100,
            color: Colors.grey[300],
            child: Icon(Icons.broken_image, color: Colors.grey[600]),
          );
        },
      );
    } catch (e) {
      return Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        child: Icon(Icons.error, color: Colors.grey[600]),
      );
    }
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
    // For now, just close the dialog
    Navigator.of(context).pop();
  }

  void _pickImageFromGallery() async {
    // Logic to pick images
    // For now, just close the dialog
    Navigator.of(context).pop();
  }

  void _removeAttachment(String path) {
    setState(() {
      _attachmentPaths.remove(path);
    });
  }
}
