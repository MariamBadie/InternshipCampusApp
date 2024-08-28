
class Post {

  String id;
  String userID;
  DateTime postDate;
  String title;
  String content;
  String communityID;
  List<String> comments;
  bool isConfession; // If true, do not display likes and dislikes
  List<String> upVoters;
  List<String> downVoters;

  Post({required this.id, required this.userID, required this.postDate,  required this.title,
    required this.content, required this.communityID, this.comments = const [], required this.isConfession, required this.upVoters,
  required this.downVoters});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userID': userID,
      'postDate': postDate,
      'title': title,
      'content': content,
      'communityID': communityID,
      'blocked': comments,
      'isConfession': isConfession,
      'upVoters': upVoters,
      'downVoters': downVoters
    };
  }

  factory Post.fromMap(Map<String, dynamic> map){
    return Post(
        id: map['id'],
        userID: map['userID'],
        postDate: map['postDate'],
        title: map['title'],
        content: map['content'],
        communityID: map['communityID'],
        comments: map['comments'],
        isConfession: map['isConfession'],
        upVoters: map['upVoters'],
        downVoters: map['downVoters']
    );
  }

}