import 'package:campus_app/backend/Model/Post.dart';

class Highlights {
  String? id; // Add the id field
  List<Post>? posts; // Nullable posts list
  String? userID; // Nullable userID
  String? highlightsname; // Nullable highlightsname
  String? imageUrl; // Nullable field to store the image URL

  Highlights({
    this.id, // Optional id
    this.posts, // Optional posts
    this.userID, // Optional userID
    this.highlightsname, // Optional highlightsname
    this.imageUrl, // Optional imageUrl
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'posts': posts?.map((post) => post.toFirestore()).toList(), // Convert posts to Map if not null
      'userID': userID,
      'highlightsname': highlightsname,
      'imageUrl': imageUrl, // Include the imageUrl in the map
    };
  }

  factory Highlights.fromMap(Map<String, dynamic> map) {
    return Highlights(
      id: map['id'] as String?,
      posts: (map['posts'] as List<dynamic>?)
          ?.map((item) => Post.fromFirestore(item as Map<String, dynamic>))
          .toList(), // Convert map to List<Post> if not null
      userID: map['userID'] as String?,
      highlightsname: map['highlightsname'] as String?,
      imageUrl: map['imageUrl'] as String?, // Retrieve the imageUrl if present
    );
  }
    @override
  String toString() {
    return 'Highlights(imageUrl: $imageUrl, highlightsname: $highlightsname, userID: $userID ,posts: $posts,id: $id)';
  }
}
