import 'dart:typed_data';

import 'package:campus_app/backend/Model/LostAndFound.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String> uploadImageToStorage(String childName, Uint8List file) async {
  Reference ref = _storage.ref().child(childName);
  UploadTask uploadTask = ref.putData(file);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<void> saveLostAndFoundPost(LostAndFound post) async {
  try {
    await FirebaseFirestore.instance
        .collection('LostAndFound')
        .doc()
        .set(post.toMap());
    print("done");
  } catch (e) {
    print('Failed to save post: $e');
  }
}

Future<List<LostAndFound>> getAllLostAndFoundPosts(String userID) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('LostAndFound')
        .where("authorID", isEqualTo: userID)
        .get();
    List<LostAndFound> lostandfound = querySnapshot.docs.map((doc) {
      return LostAndFound.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    return lostandfound;
  } catch (e) {
    print('Failed to get post: $e');
    return [];
  }
}
