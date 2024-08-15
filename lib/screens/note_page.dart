import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import this to use File class

class NotesPage extends StatefulWidget {
  final String? courseName;

  const NotesPage({super.key, this.courseName});

  @override
  // ignore: library_private_types_in_public_api
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _attachmentPaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
        ),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Add New Note'),
                onPressed: () => _showAddNoteDialog(),
              ),
            ],
          ),
        ));
  }

  void _showAddNoteDialog() {
    _titleController.clear();
    _numberController.clear();
    _contentController.clear();
    _attachmentPaths.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  decoration: const InputDecoration(
                      hintText: 'Lecture/Tutorial Number'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(hintText: 'Note Content'),
                  maxLines: 3,
                ),
                ElevatedButton(
                    onPressed: _showAttachmentSourceDialog,
                    child: const Text('Attach Files')),
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
                //add functionality
              },
            ),
          ],
        );
      },
    );
  }

  void _showAttachmentSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Attachment Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Pick from File System'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickFile();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Photos'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (result != null) {
        setState(() {
          _attachmentPaths.addAll(
              result.paths.where((path) => path != null).cast<String>());
        });
      }
    } catch (e) {
      print('Error picking file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick file.')),
      );
    }
  }

  void _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile>? images = await picker.pickMultiImage();

      if (images != null) {
        setState(() {
          _attachmentPaths.addAll(images.map((image) => image.path));
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick images.')),
      );
    }
  }

  void _clearFields() {
    _titleController.clear();
    _numberController.clear();
    _contentController.clear();
    _attachmentPaths.clear();
  }
}
