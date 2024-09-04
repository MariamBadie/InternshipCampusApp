import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore import

class Highlights {
  String? id; // Add the id field
  List<String>? posts; // List of post paths as strings
  String? userID; // Nullable userID
  String? highlightsname; // Nullable highlightsname
  String? imageUrl; // Nullable field to store the image URL

  Highlights({
    this.id, // Optional id
    this.posts, // Optional post paths
    this.userID, // Optional userID
    this.highlightsname, // Optional highlightsname
    this.imageUrl, // Optional imageUrl
  });

  Map<String, dynamic> toMap() {
    return {
      'posts': posts, // Directly store paths as strings
      'userID': userID,
      'highlightsname': highlightsname,
      'imageUrl': imageUrl, // Include the imageUrl in the map
    };
  }

  factory Highlights.fromMap(Map<String, dynamic> map) {
    return Highlights(
      id: map['id'] as String?,
      posts: List<String>.from(map['posts'] ?? []), // Convert paths from strings
      userID: map['userID'] as String?,
      highlightsname: map['highlightsname'] as String?,
      imageUrl: map['imageUrl'] as String?, // Retrieve the imageUrl if present
    );
  }

  @override
  String toString() {
    return 'Highlights(imageUrl: $imageUrl, highlightsname: $highlightsname, userID: $userID ,posts: $posts, id: $id)';
  }
}
