import 'package:flutter/material.dart';
import 'package:campus_app/widgets/notes/note.dart';
import 'package:campus_app/widgets/notes/note_dialog.dart';

class NotesPage extends StatefulWidget {
  final String? courseName;

  const NotesPage({super.key, this.courseName});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _attachmentPaths = [];
  final TextEditingController _searchController = TextEditingController();

  List<Note> _filteredNotes = [];

  final List<Note> _notes = [
    Note(
      title: "Lecture 1",
      number: "1",
      content: "Introduction to Flutter",
      attachmentPaths: [],
      comments: [
        Comment(text: "Great introduction!", authorName: "John Doe"),
        Comment(text: "Could use more examples.", authorName: "Jane Smith"),
      ],
    ),
  ];

  void initState() {
    super.initState();
    _filteredNotes = List.from(_notes);
  }

  void _filterNotes(String query) {
    setState(() {
      _filteredNotes = _notes.where((note) {
        return note.number.contains(query) || note.title.contains(query);
      }).toList();
    });
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDialog(
          onAddNote: (note) {
            setState(() {
              _notes.add(note);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by lecture/tutorial number',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _filterNotes,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredNotes.length,
              itemBuilder: (context, index) {
                final note = _filteredNotes[index];
                return ExpansionTile(
                  title: Text(note.title),
                  subtitle: Text("Number: ${note.number}\n${note.content}"),
                  children: [
                    ...note.comments.map((comment) => ListTile(
                          title: Text(comment.text),
                          subtitle: Text(comment.authorName),
                        )),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Leave a comment',
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          note.comments.add(Comment(
                            text: value,
                            authorName: 'You',
                          ));
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              child: const Text('Add New Note'),
              onPressed: () => _showAddNoteDialog(),
            ),
          ),
        ],
      ),
    );
  }
}
