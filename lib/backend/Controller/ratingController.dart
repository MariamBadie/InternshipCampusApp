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

  Future<List<Map<String, dynamic>>> getAllRatingsWithUserNames() async {
    await firebaseService.initialize();

    // Retrieve all documents from the 'Ratings' collection
    QuerySnapshot ratingSnapshot = await firebaseService.firestore.collection('Ratings').get();

    // Create a list to hold ratings with user names
    List<Map<String, dynamic>> ratingsWithUserNames = [];

    // Loop through each rating document
    for (var ratingDoc in ratingSnapshot.docs) {
      // Convert the rating document to a Rating object
      Rating rating = Rating.fromMap(ratingDoc.id, ratingDoc.data() as Map<String, dynamic>);

      // Retrieve the user document based on the authorID
      DocumentSnapshot userDoc = await firebaseService.firestore.doc('User/${rating.authorID}').get();

      // Extract the user's name from the user document
      String userName = userDoc['name'] as String;

      String name = '';
      if(rating.entityType=='professor') {
        name = 'Prof. ${rating.entityID}';
      } else{
        name = rating.entityID;
      }

      // Create a map to hold both the rating and user name
      Map<String, dynamic> ratingWithUserName = {
        'content': rating.content,
        'userName': userName,
        'createdAt': rating.createdAt,
        'rating': rating.rating,
        'isAnonymous': rating.isAnonymous,
        'upCount': rating.upCount,
        'downCount': rating.downCount,
        'entityID': name,
        'id': ratingDoc.id
      };

      // Add the map to the list
      ratingsWithUserNames.add(ratingWithUserName);
    }

    return ratingsWithUserNames;
  }

  Future<void> incrementUpCount(String ratingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Ratings')
          .doc(ratingId)
          .update({'upCount': FieldValue.increment(1)});
    } catch (e) {
      throw Exception('Failed to increment upCount: $e');
    }
  }

  Future<void> incrementDownCount(String ratingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Ratings')
          .doc(ratingId)
          .update({'downCount': FieldValue.increment(1)});
    } catch (e) {
      throw Exception('Failed to increment downCount: $e');
    }
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
