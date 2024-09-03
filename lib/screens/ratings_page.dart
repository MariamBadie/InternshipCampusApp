import 'package:campus_app/backend/Controller/ratingController.dart';
import 'package:campus_app/backend/Model/Rating.dart';
import 'package:flutter/material.dart';

class RatingsPage extends StatefulWidget {
  const RatingsPage({super.key});

  @override
  State<RatingsPage> createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  late Future<List<Map<String, dynamic>>> ratings;

  // Initialize RatingController with FirebaseService
  final RatingController ratingController = RatingController(FirebaseService());

  @override
  void initState() {
    super.initState();
    loadRatings();
  }

  void loadRatings() {
    setState(() {
      ratings = ratingController.getAllRatingsWithUserNames();
    });
  }

  // Function to handle like click
  Future<void> handleLike(String ratingId) async {
    await ratingController.incrementUpCount(ratingId);
    loadRatings(); // Refresh the page after liking
  }

  // Function to handle dislike click
  Future<void> handleDislike(String ratingId) async {
    await ratingController.incrementDownCount(ratingId);
    loadRatings(); // Refresh the page after disliking
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: const Text("Ratings"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadRatings(); // Refresh the page
            },
          ),
        ],
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: ratings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading ratings'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No ratings found'));
          }

          var ratingList = snapshot.data!;

          return ListView.builder(
            itemCount: ratingList.length,
            itemBuilder: (context, index) {
              var rating = ratingList[index];
              var dateTime = (rating['createdAt'] as DateTime?)?.toLocal();

              return ListTile(
                title: Text(rating['content'] ?? 'No Content'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateTime != null
                          ? '${dateTime.toString().split(' ')[0]} ${dateTime.toString().split(' ')[1].substring(0, 5)}'
                          : 'No DateTime',
                    ),
                    Text('Review about: ${rating['entityID'] ?? 'Unknown Entity'}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Rating: ${rating['rating']}/5'),
                    Text(
                      rating['isAnonymous'] == true ? 'Anonymous' : 'By: ${rating['userName']}',
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            handleLike(rating['id']); // Increment upCount
                          },
                          child: Icon(Icons.keyboard_arrow_up, color: Colors.green, size: 20),
                        ),
                        const SizedBox(width: 4),
                        Text('${rating['upCount'] ?? 0}'), // Display upCount
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            handleDislike(rating['id']); // Increment downCount
                          },
                          child: Icon(Icons.keyboard_arrow_down, color: Colors.red, size: 20),
                        ),
                        const SizedBox(width: 4),
                        Text('${rating['downCount'] ?? 0}'), // Display downCount
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}