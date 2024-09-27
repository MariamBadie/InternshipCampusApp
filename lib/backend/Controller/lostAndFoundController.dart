import 'dart:typed_data';

import 'package:campus_app/backend/Model/LostAndFound.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String> uploadImageToStorage(String childName, Uint8List file) async {
  Reference ref = _storage.ref().child(childName);
  UploadTask uploadTask = ref.putData(file);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<String> uploadImageToStorage1(String childName, XFile file) async {
  Reference ref = FirebaseStorage.instance.ref().child(childName);

  // Read the file as bytes
  Uint8List fileData = await file.readAsBytes();

  UploadTask uploadTask = ref.putData(fileData);
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
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('LostAndFound').get();
    List<LostAndFound> lostandfound = querySnapshot.docs.map((doc) {
      return LostAndFound.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();

    return lostandfound;
  } catch (e) {
    print('Failed to get post: $e');
    return [];
  }
}

Future<String> getUserById(String userId) async {
  try {
    // DocumentReference<Map<String, dynamic>> user = await FirebaseFirestore.instance
    //     .collection('User').doc('yq2Z9NaQdPz0djpnLynN');

    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance.collection('User').doc(userId).get();
    if (userSnapshot.exists) return userSnapshot.data()?['name'];
  } catch (e) {
    print('Failed to save post: $e');
  }
  return 'Unknown User';
}
