import 'package:flutter/material.dart';
import 'package:campus_app/widgets/notes/note.dart';
import 'package:campus_app/widgets/notes/note_dialog.dart';
import 'package:campus_app/widgets/notes/EditNoteDialog.dart';

class NotesPage extends StatefulWidget {
  final String? courseName;

  const NotesPage({super.key, this.courseName});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _searchController = TextEditingController();

  List<Note> _filteredNotes = [];

  final List<Note> _notes = [
    Note(
      title: "CSEN 401 - Introduction to Software Engineering",
      number: "1",
      content: "Introduction to Software Engineering principles and practices.",
      attachmentPaths: [
        "assets/lectures/csen401_intro_software_eng.pdf",
      ],
      comments: [
        Comment(text: "Very insightful lecture!", authorName: "Ahmed Salah"),
        Comment(
            text: "Looking forward to more details on Agile methodologies.",
            authorName: "Mona Ali"),
      ],
    ),
    Note(
      title: "CSEN 402 - Fundamentals of Programming",
      number: "2",
      content: "Basics of programming languages and development practices.",
      attachmentPaths: [
        "assets/lectures/csen402_fundamentals_programming.pdf",
      ],
      comments: [
        Comment(
            text: "Good start, but could use more exercises.",
            authorName: "Omar Khaled"),
        Comment(
            text: "The examples were very helpful.",
            authorName: "Sara Mohamed"),
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
        final lowerCaseNumber = note.number.toLowerCase();
        final lowerCaseTitle = note.title.toLowerCase();
        final lowerCaseQuery = query.toLowerCase();
        return lowerCaseNumber.contains(lowerCaseQuery) ||
            lowerCaseTitle.contains(lowerCaseQuery);
      }).toList();
    });
  }

  void _showEditNoteDialog(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditNoteDialog(
          note: note,
          onUpdateNote: (updatedNote) {
            setState(() {
              final index = _notes.indexOf(note);
              _notes[index] = updatedNote;
              _filteredNotes = List.from(_notes);
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
                          _downloadNote(note);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditNoteDialog(note);
                        },
                      ),
                    ],
                  ),
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

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDialog(
          onAddNote: (note) {
            setState(() {
              _notes.add(note);
              _filteredNotes = List.from(_notes);
            });
          },
        );
      },
    );
  }

  void _downloadNote(Note note) {
    // Implement the logic to download the note
    // This could involve creating a PDF or other file format and saving it to the device
    print('Downloading note: ${note.title}');
  }
}
