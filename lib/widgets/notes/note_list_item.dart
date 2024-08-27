// import 'package:flutter/material.dart';
// import 'package:campus_app/backend/Model/notesbackend.dart';
// import 'package:campus_app/backend/Controller/notescontroller.dart';

// class NoteListItem extends StatelessWidget {
//   final Note note;
//   final VoidCallback onEdit;
//   final VoidCallback onDownload;
//   final NotesController notesController;

//   const NoteListItem({
//     Key? key,
//     required this.note,
//     required this.onEdit,
//     required this.onDownload,
//     required this.notesController,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: Text(note.title),
//       subtitle: Text("Number: ${note.number}\n${note.content}"),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: const Icon(Icons.download),
//             onPressed: onDownload,
//           ),
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: onEdit,
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () => _deleteNote(context),
//           ),
//         ],
//       ),
//       children: [
//         ...note.comments.map((comment) => CommentListItem(comment: comment)),
//         AddCommentField(
//           onSubmitted: (comment) async {
//             try {
//               await notesController.addComment(note.id!, comment);
//             } catch (e) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Error adding comment: $e')),
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }

//   void _deleteNote(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Note'),
//           content: Text('Are you sure you want to delete this note?'),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             TextButton(
//               child: Text('Delete'),
//               onPressed: () async {
//                 try {
//                   await notesController.deleteNote(note.id!);
//                   Navigator.of(context).pop();
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error deleting note: $e')),
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class CommentListItem extends StatelessWidget {
//   final Comment comment;

//   const CommentListItem({Key? key, required this.comment}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(comment.text),
//       subtitle: Text(comment.authorName),
//       trailing: Text(comment.createdAt.toDate().toString()),
//     );
//   }
// }

// class AddCommentField extends StatelessWidget {
//   final Function(Comment) onSubmitted;

//   const AddCommentField({Key? key, required this.onSubmitted})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       decoration: const InputDecoration(
//         hintText: 'Leave a comment',
//         suffixIcon: Icon(Icons.send),
//       ),
//       onSubmitted: (value) {
//         if (value.isNotEmpty) {
//           onSubmitted(Comment(
//             text: value,
//             authorName: 'You',
//             isOwnComment: true,
//           ));
//         }
//       },
//     );
//   }
// }
