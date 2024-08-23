import 'package:flutter/material.dart';
import 'package:campus_app/widgets/notes/note.dart';

// for editing a note

class NoteListItem extends StatelessWidget {
  final Note note;
  final VoidCallback onEdit;
  final VoidCallback onDownload;
  final Function(Comment) onAddComment;

  const NoteListItem({
    Key? key,
    required this.note,
    required this.onEdit,
    required this.onDownload,
    required this.onAddComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(note.title),
      subtitle: Text("Number: ${note.number}\n${note.content}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: onDownload,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
        ],
      ),
      children: [
        ...note.comments.map((comment) => CommentListItem(comment: comment)),
        AddCommentField(onSubmitted: onAddComment),
      ],
    );
  }
}

class CommentListItem extends StatelessWidget {
  final Comment comment;

  const CommentListItem({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(comment.text),
      subtitle: Text(comment.authorName),
    );
  }
}

class AddCommentField extends StatelessWidget {
  final Function(Comment) onSubmitted;

  const AddCommentField({Key? key, required this.onSubmitted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Leave a comment',
      ),
      onSubmitted: (value) {
        onSubmitted(Comment(
          text: value,
          authorName: 'You',
          isOwnComment: true,
        ));
      },
    );
  }
}
