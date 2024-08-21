class Note {
  final String title;
  final String number;
  final String content;
  final List<String> attachmentPaths;
  final List<Comment> comments;

  Note({
    required this.title,
    required this.number,
    required this.content,
    required this.attachmentPaths,
    required this.comments,
  });

  void deleteComment(Comment comment) {
    comments.remove(comment);
  }
}

class Comment {
  final String text;
  final String authorName;
  final bool isOwnComment;

  Comment({
    required this.text,
    required this.authorName,
    this.isOwnComment = false,
  });
}
