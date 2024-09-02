import 'package:flutter/material.dart';
import 'package:campus_app/backend/Model/notesbackend.dart';
import 'package:campus_app/backend/Controller/notescontroller.dart';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesController _notesController = NotesController();
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _expandedComments = {};

  // Color scheme
  static const Color primaryColor = Color(0xFF006C60);
  static const Color secondaryColor = Color(0xFFF0F4F4);
  static const Color accentColor = Color(0xFFFF9B50);
  static const Color textColor = Color(0xFF333333);
  static const Color backgroundColor = Color(0xFFE6EDED);

  @override
  void dispose() {
    _notesController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Notes', style: TextStyle(color: secondaryColor)),
      backgroundColor: primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: secondaryColor),
    );
  }

  Widget _buildBody() {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildNotesList()),
          ],
        ),
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
        onChanged: _notesController.filterNotes,
      ),
    );
  }

  Widget _buildNotesList() {
    return ValueListenableBuilder<List<Note>>(
      valueListenable: _notesController.filteredNotes,
      builder: (context, notes, child) {
        if (notes.isEmpty) {
          return const Center(child: Text('No notes found'));
        }
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) => _buildNoteCard(notes[index]),
        );
      },
    );
  }

  Widget _buildNoteCard(Note note) {
    _expandedComments.putIfAbsent(note.id!, () => false);

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: secondaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNoteHeader(note),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          'Posted by: ${note.userId}',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildNoteContent(note),
                    const SizedBox(height: 12),
                    if (note.attachmentUrl != null &&
                        note.attachmentUrl!.isNotEmpty)
                      _buildAttachmentPreview(
                          note.attachmentUrl!, note.attachmentType ?? 'file'),
                    const SizedBox(height: 16),
                    _buildNoteActions(note),
                  ],
                ),
              ),
              if (_expandedComments[note.id]! && note.comments.isNotEmpty)
                _buildCommentsDropdown(note),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoteHeader(Note note) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primaryColor,
                ),
              ),
              Text(
                note.number,
                style: TextStyle(color: textColor.withOpacity(0.7)),
              ),
            ],
          ),
        ),
        if (_notesController.canEditNote(note))
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: primaryColor),
            onSelected: (String result) {
              if (result == 'edit') {
                _showEditNoteDialog(note);
              } else if (result == 'delete') {
                _showDeleteConfirmationDialog(note);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildNoteContent(Note note) {
    return Text(
      note.content,
      style: TextStyle(color: textColor, fontSize: 16),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildNoteActions(Note note) {
    return Row(
      children: [
        _buildIconButton(
            Icons.download, 'Download', accentColor, () => _downloadNote(note)),
        const SizedBox(width: 16),
        _buildIconButton(Icons.comment, 'Comment', primaryColor,
            () => _showAddCommentDialog(note)),
        if (note.comments.isNotEmpty) ...[
          const Spacer(),
          InkWell(
            onTap: () {
              setState(() {
                _expandedComments[note.id!] = !_expandedComments[note.id!]!;
              });
            },
            child: Text(
              'View all Comments (${note.comments.length})',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIconButton(
      IconData icon, String label, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsDropdown(Note note) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: note.comments
            .map((comment) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            comment.authorName,
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            DateFormat('MMM d, yyyy h:mm a')
                                .format(comment.createdAt.toDate()),
                            style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontSize: 10),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        comment.text,
                        style: TextStyle(color: textColor),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: accentColor,
      onPressed: _showAddNoteDialog,
      child: Icon(Icons.add, color: secondaryColor),
    );
  }

//////////////////////////
  void _showAddNoteDialog() {
    final titleController = TextEditingController();
    final numberController = TextEditingController();
    final contentController = TextEditingController();
    String? attachmentPath;
    String? attachmentType;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) =>
          StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text('Add New Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: 'Title'),
                ),
                TextField(
                  controller: numberController,
                  decoration: const InputDecoration(hintText: 'Number'),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(hintText: 'Content'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.attach_file),
                  label: Text(
                    attachmentPath != null
                        ? 'Attachment Added'
                        : 'Add Attachment',
                  ),
                  onPressed: () => _showAttachmentSourceDialog(
                    (path, type) {
                      setState(() {
                        attachmentPath = path;
                        attachmentType = type;
                      });
                    },
                  ),
                ),
                if (attachmentPath != null)
                  _buildAttachmentPreview(attachmentPath!, attachmentType!),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _addNote(
                  titleController.text,
                  numberController.text,
                  contentController.text,
                  attachmentPath,
                  attachmentType,
                );
              },
            ),
          ],
        );
      }),
    );
  }

  void _showEditNoteDialog(Note note) {
    if (!_notesController.canEditNote(note)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You do not have permission to edit this note.')),
      );
      return;
    }
    final titleController = TextEditingController(text: note.title);
    final numberController = TextEditingController(text: note.number);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(hintText: 'Number'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(hintText: 'Content'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Update'),
            onPressed: () async {
              await _notesController.updateNote(Note(
                id: note.id,
                userId: note.userId, // Add this line
                title: titleController.text,
                number: numberController.text,
                content: contentController.text,
                attachmentUrl: note.attachmentUrl,
                attachmentType: note
                    .attachmentType, // Add this line if it exists in your Note class
                comments: note.comments,
              ));
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(Note note) {
    if (!_notesController.canEditNote(note)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('You do not have permission to delete this note.')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteNote(note.id!);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddCommentDialog(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.blueGrey)),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('Add', style: TextStyle(color: accentColor)),
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(); // Close the dialog immediately
                _addComment(note, controller.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _addNote(String title, String number, String content,
      String? attachmentPath, String? attachmentType) async {
    try {
      Note newNote = Note(
        userId: _notesController.testUserId,
        title: title,
        number: number,
        content: content,
      );
      if (attachmentPath != null && attachmentType != null) {
        final attachment = await _notesController.uploadAttachment(
          attachmentPath,
          attachmentType,
        );
        if (attachment['error'] != null) {
          throw Exception(attachment['error']);
        }
        newNote.attachmentUrl = attachment['url'];
        newNote.attachmentType = attachment['type'];
      }
      await _notesController.addNote(newNote);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add note: ${e.toString()}')),
      );
    }
  }

  void _addComment(Note note, String commentText) async {
    await _notesController.addComment(
      note.id!,
      Comment(
        text: commentText,
        authorName: 'You',
        isOwnComment: true,
        createdAt: Timestamp.now(),
      ),
    );
    // Show a snackbar for feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment added successfully')),
    );
  }

  void _deleteNote(String noteId) async {
    await _notesController.deleteNote(noteId);
  }

  void _downloadNote(Note note) async {
    if (note.attachmentUrl != null) {
      File? file = await _notesController.downloadAttachment(
          note.attachmentUrl!, note.attachmentType ?? 'file');
      if (file != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attachment downloaded: ${file.path}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download attachment')),
        );
      }
    } else {
      String result = await _notesController.downloadNoteContent(note);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  Widget _buildAttachmentPreview(String path, String type) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: type.toLowerCase() == 'image'
            ? _buildImagePreview(path)
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getFileIcon(path),
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      type.toUpperCase(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildImagePreview(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      );
    }
  }

  IconData _getFileIcon(String url) {
    final extension = url.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _showAttachmentSourceDialog(
      Function(String, String) onAttachmentSelected) {
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
                  Navigator.of(context).pop();
                  _pickFile(onAttachmentSelected);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Photos'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImageFromGallery(onAttachmentSelected);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _captureImageFromCamera(onAttachmentSelected);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickFile(Function(String, String) onAttachmentSelected) async {
    String? filePath = await _notesController.pickFile();
    if (filePath != null) {
      onAttachmentSelected(filePath, 'file');
    }
  }

  void _pickImageFromGallery(
      Function(String, String) onAttachmentSelected) async {
    String? imagePath = await _notesController.pickImageFromGallery();
    if (imagePath != null) {
      onAttachmentSelected(imagePath, 'image');
    }
  }

  void _captureImageFromCamera(
      Function(String, String) onAttachmentSelected) async {
    String? imagePath = await _notesController.captureImageFromCamera();
    if (imagePath != null) {
      onAttachmentSelected(imagePath, 'image');
    }
  }
}
