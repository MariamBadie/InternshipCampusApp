import 'package:flutter/material.dart';
import 'package:campus_app/widgets/notes/note.dart';
import 'package:campus_app/widgets/notes/note_dialog.dart';
import 'package:campus_app/widgets/notes/EditNoteDialog.dart';
import 'package:campus_app/widgets/notes/note_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NoteService _noteService = NoteService();
  List<Note> _filteredNotes = [];

  // Define our Deep Teal color scheme
  final Color primaryColor = const Color(0xFF006C60); // Deep Teal
  final Color secondaryColor = const Color(0xFFF0F4F4); // Light Gray
  final Color accentColor = const Color(0xFFFF9B50); // Soft Orange
  final Color textColor = const Color(0xFF333333); // Dark Gray
  final Color backgroundColor = const Color(0xFFE6EDED); // Pale Teal

  @override
  void initState() {
    super.initState();
    _filteredNotes = _noteService.notes;
  }

  void _filterNotes(String query) {
    setState(() {
      _filteredNotes = _noteService.filterNotes(query);
    });
  }

  void _showEditNoteDialog(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) => EditNoteDialog(
        note: note,
        onUpdateNote: (updatedNote) {
          setState(() {
            _noteService.updateNote(updatedNote);
            _filteredNotes = _noteService.notes;
          });
        },
      ),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => NoteDialog(
        onAddNote: (note) {
          setState(() {
            _noteService.addNote(note);
            _filteredNotes = _noteService.notes;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes', style: TextStyle(color: secondaryColor)),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: secondaryColor),
      ),
      body: Container(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 16),
              Expanded(
                child: _buildNotesList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        child: Icon(Icons.add, color: secondaryColor),
        onPressed: _showAddNoteDialog,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: 'Search by lecture/tutorial number',
          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
          prefixIcon: Icon(Icons.search, color: primaryColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: _filterNotes,
      ),
    );
  }

  Widget _buildNotesList() {
    return ListView.builder(
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        final note = _filteredNotes[index];
        return _buildNoteCard(note);
      },
    );
  }

  Widget _buildNoteCard(Note note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: secondaryColor,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            note.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
          ),
          subtitle: Text(' ${note.number}',
              style: TextStyle(color: textColor.withOpacity(0.7))),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(note.content, style: TextStyle(color: textColor)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(Icons.edit, 'Edit', primaryColor,
                          () => _showEditNoteDialog(note)),
                      _buildActionButton(Icons.download, 'Download',
                          accentColor, () => _noteService.downloadNote(note)),
                      _buildActionButton(Icons.comment, 'Comment',
                          Colors.blueGrey, () => _showAddCommentDialog(note)),
                    ],
                  ),
                  if (note.comments.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('Comments:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: primaryColor)),
                    ...note.comments.map((comment) => ListTile(
                          title: Text(comment.text,
                              style: TextStyle(color: textColor)),
                          subtitle: Text(comment.authorName,
                              style: TextStyle(color: accentColor)),
                        )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16), // Reduced icon size
      label: Text(label, style: TextStyle(fontSize: 12)), // Reduced text size
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
    );
  }

  void _showAddCommentDialog(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Add Comment', style: TextStyle(color: primaryColor)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter your comment',
              hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel', style: TextStyle(color: Colors.blueGrey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add', style: TextStyle(color: accentColor)),
              onPressed: () {
                setState(() {
                  _noteService.addComment(
                      note,
                      Comment(
                        text: controller.text,
                        authorName: 'You',
                        isOwnComment: true,
                      ));
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
