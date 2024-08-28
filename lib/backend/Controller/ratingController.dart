import 'package:cloud_firestore/cloud_firestore.dart';
import '../Model/Rating.dart';

class RatingController {
  final FirebaseService firebaseService;

  RatingController(this.firebaseService);

  Future<void> addRating(Rating rating) async {
    await firebaseService.initialize();

    // Convert the authorID to a Firestore reference
    Map<String, dynamic> ratingData = rating.toMap();
    ratingData['authorID'] = firebaseService.firestore.doc('User/${rating.authorID}');

    // Add the rating to Firestore with an auto-generated ID
    await firebaseService.firestore.collection('Ratings').add(ratingData);
  }

  Future<List<String>> getAllEntityNamesFromCollection(String collectionName) async {
    await firebaseService.initialize();

    // Retrieve all documents from the collection and extract the "name" field
    if(collectionName == 'course') {
      collectionName = 'Course';
    } else if (collectionName == 'outlet')
        collectionName = 'Outlet';
    else {
      collectionName = 'User';
      QuerySnapshot querySnapshot = await firebaseService.firestore
          .collection(collectionName).where('type', isNotEqualTo: 'student').get();
      List<String> entityNames = querySnapshot.docs.map((doc) => doc['name'] as String).toList();
      return entityNames;
    }

    QuerySnapshot querySnapshot = await firebaseService.firestore.collection(collectionName).get();
    List<String> entityNames = querySnapshot.docs.map((doc) => doc['name'] as String).toList();

    return entityNames;
  }


// Other rating-related functions can be added here
}

class FirebaseService {
  late FirebaseFirestore firestore;

  Future<void> initialize() async {
    firestore = FirebaseFirestore.instance;
    // Perform any additional initialization if needed
  }
}
