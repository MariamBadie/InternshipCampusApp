import 'package:flutter/material.dart';
import 'package:campus_app/backend/Model/notesbackend.dart';
import 'package:campus_app/widgets/notes/note_dialog.dart';
import 'package:campus_app/widgets/notes/EditNoteDialog.dart';
import 'package:campus_app/backend/Controller/notescontroller.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesController _notesController = NotesController();
  final TextEditingController _searchController = TextEditingController();

  // Define your color scheme
  final Color primaryColor = const Color(0xFF006C60); // Deep Teal
  final Color secondaryColor = const Color(0xFFF0F4F4); // Light Gray
  final Color accentColor = const Color(0xFFFF9B50); // Soft Orange
  final Color textColor = const Color(0xFF333333); // Dark Gray
  final Color backgroundColor = const Color(0xFFE6EDED); // Pale Teal

  @override
  void dispose() {
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
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
                child: ValueListenableBuilder<List<Note>>(
                  valueListenable: _notesController.filteredNotes,
                  builder: (context, notes, child) {
                    if (notes.isEmpty) {
                      return Center(child: Text('No notes found'));
                    }
                    return _buildNotesList(notes);
                  },
                ),
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
        controller: _searchController,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: 'Search by lecture/tutorial number or title',
          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
          prefixIcon: Icon(Icons.search, color: primaryColor),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          _notesController.filterNotes(value);
        },
      ),
    );
  }

  Widget _buildNotesList(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
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
      child: CustomExpansionTile(
        title: Text(
          note.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
        ),
        subtitle: Text(note.number,
            style: TextStyle(color: textColor.withOpacity(0.7))),
        deleteButton: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteNote(note.id!),
        ),
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
                    _buildActionButton(Icons.download, 'Download', accentColor,
                        () => _downloadNote(note)),
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
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(label, style: TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
    );
  }

  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final numberController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Add New Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: numberController,
                decoration: InputDecoration(hintText: 'Number'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: 'Content'),
                maxLines: 3,
              ),
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
            onPressed: () async {
              await _notesController.addNote(Note(
                title: titleController.text,
                number: numberController.text,
                content: contentController.text,
                attachmentPaths: [],
                comments: [],
              ));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showEditNoteDialog(Note note) {
    final titleController = TextEditingController(text: note.title);
    final numberController = TextEditingController(text: note.number);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Edit Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: numberController,
                decoration: InputDecoration(hintText: 'Number'),
              ),
              TextField(
                controller: contentController,
                decoration: InputDecoration(hintText: 'Content'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Update'),
            onPressed: () async {
              await _notesController.updateNote(Note(
                id: note.id,
                title: titleController.text,
                number: numberController.text,
                content: contentController.text,
                attachmentPaths: note.attachmentPaths,
                comments: note.comments,
              ));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _deleteNote(String noteId) async {
    // Consider adding a confirmation dialog before deleting
    await _notesController.deleteNote(noteId);
  }

  void _downloadNote(Note note) async {
    String result = await _notesController.downloadNote(note);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result)),
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
              onPressed: () async {
                await _notesController.addComment(
                  note.id!,
                  Comment(
                    text: controller.text,
                    authorName: 'You',
                    isOwnComment: true,
                  ),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  final Widget title;
  final Widget? subtitle;
  final List<Widget> children;
  final Widget deleteButton;

  const CustomExpansionTile({
    Key? key,
    required this.title,
    this.subtitle,
    required this.children,
    required this.deleteButton,
  }) : super(key: key);

  @override
  _CustomExpansionTileState createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: widget.title,
        subtitle: widget.subtitle,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isExpanded) widget.deleteButton,
            Icon(_isExpanded ? Icons.expand_less : Icons.expand_more,
                color: _NotesPageState().primaryColor),
          ],
        ),
        children: widget.children,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
      ),
    );
  }
}
