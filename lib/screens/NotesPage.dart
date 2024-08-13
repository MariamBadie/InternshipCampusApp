import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class NotesPage extends StatefulWidget {
  final String? courseName;

  NotesPage({this.courseName});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String? _pdfPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NoteCard(note: notes[index]);
              },
            ),
          ),
          ElevatedButton(
            child: Text('Add New Note'),
            onPressed: () => _showAddNoteDialog(),
          ),
        ],
      ),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration:
                      InputDecoration(hintText: 'Lecture/Tutorial Name'),
                ),
                TextField(
                  controller: _numberController,
                  decoration:
                      InputDecoration(hintText: 'Lecture/Tutorial Number'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _contentController,
                  decoration: InputDecoration(hintText: 'Note Content'),
                  maxLines: 3,
                ),
                ElevatedButton(
                  child: Text('Attach PDF'),
                  onPressed: _pickPDF,
                ),
                if (_pdfPath != null)
                  Text('PDF attached: ${_pdfPath!.split('/').last}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                _addNote();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfPath = result.files.single.path;
      });
    }
  }

  void _addNote() {
    if (_titleController.text.isNotEmpty && _numberController.text.isNotEmpty) {
      setState(() {
        notes.add(Note(
          title: _titleController.text,
          number: int.parse(_numberController.text),
          content: _contentController.text,
          pdfPath: _pdfPath,
        ));
        _titleController.clear();
        _numberController.clear();
        _contentController.clear();
        _pdfPath = null;
      });
    }
  }
}

class Note {
  final String title;
  final int number;
  final String content;
  final String? pdfPath;

  Note(
      {required this.title,
      required this.number,
      required this.content,
      this.pdfPath});
}

class NoteCard extends StatelessWidget {
  final Note note;

  NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('${note.title} - #${note.number}'),
        subtitle: Text(note.content),
        trailing: note.pdfPath != null
            ? IconButton(
                icon: Icon(Icons.attachment),
                onPressed: () {
                  // Implement PDF viewing functionality here
                },
              )
            : null,
      ),
    );
  }
}
