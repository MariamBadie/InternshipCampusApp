import 'package:campus_app/backend/Controller/commentController.dart';
import 'package:campus_app/backend/Controller/userController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyActivityPage extends StatefulWidget {
  const MyActivityPage({super.key});

  @override
  State<MyActivityPage> createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> comments = [];
  bool isLoading = true;
  var userID = 'upeubEqcmzSU9aThExaO';

  @override
  void initState() {
    super.initState();
    _fetchFavoritePosts();
    _fetchComments();
  }

  Future<void> _fetchFavoritePosts() async {
    try {
      var favoritesPostData = await getFavoritesPostData(userID);
      setState(() {
        posts = favoritesPostData.map((postList) {
          return {
            'postID': postList[0],
            'title': postList[1],
            'content': postList[2],
            'type': postList[3] == true ? 'Confession' : 'Post',
            'timestamp': _convertToDateTime(postList[4]), // Convert to DateTime
          };
        }).toList();

        // Sort posts in descending order by timestamp
        posts.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        isLoading = false;
      });
    } catch (e) {
      print("Error fetching favorite posts: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchComments() async {
    try {
      var commentsData = await getListComments(userID);
      setState(() {
        comments = commentsData.map((comment) {
          return {
            'content': comment[1],
            'timestamp': _convertToDateTime(comment[0]), // Convert to DateTime
          };
        }).toList();

        // Sort comments in descending order by timestamp
        comments.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        isLoading = false;
      });
    } catch (e) {
      print("Error fetching comments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  DateTime _convertToDateTime(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    } else if (value is DateTime) {
      return value;
    } else if (value is String) {
      return DateTime.parse(value);
    } else {
      throw Exception('Unsupported timestamp format');
    }
  }

  Map<String, List<Map<String, dynamic>>> _groupByDate(List<Map<String, dynamic>> data) {
    final Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var item in data) {
      final timestamp = item['timestamp'] as DateTime;
      final dateKey = _formatDateKey(timestamp);

      if (!groupedData.containsKey(dateKey)) {
        groupedData[dateKey] = [];
      }
      groupedData[dateKey]!.add(item);
    }
    return groupedData;
  }

  String _formatDateKey(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return "Today";
    } else if (date.year == now.year && date.month == now.month && date.day == now.subtract(Duration(days: 1)).day) {
      return "Yesterday";
    } else {
      return '${_getDayOfWeek(date.weekday)}, ${date.day}/${date.month}/${date.year}';
    }
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  List<Widget> _buildPosts(List<Map<String, dynamic>> posts, {bool showHeart = false}) {
    return posts.map((post) {
      return Container(
        width: 300, // Fixed width for each post
        margin: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 4,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(post['title'] ?? 'No Title'),
                    subtitle: Text(post['content'] ?? 'No Content'),
                    trailing: Text(post['type'] ?? 'No Type'),
                  ),
                ],
              ),
              if (showHeart)
                const Positioned(
                  bottom: 8,
                  right: 8,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> _buildComments(List<Map<String, dynamic>> comments) {
    return comments.map((comment) {
      return Container(
        width: 300, // Fixed width for each comment
        margin: const EdgeInsets.all(4.0),
        child: Card(
          elevation: 4,
          child: ListTile(
            title: Text('You Have Commented'),
            subtitle: Text(comment['content'] ?? 'No Comment'),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final groupedPosts = _groupByDate(posts);
    final groupedComments = _groupByDate(comments);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Activities",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            // Refresh the page
            _fetchFavoritePosts();
            _fetchComments();
          }, icon: const Icon(Icons.refresh))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groupedPosts.keys.map((dateKey) {
              final postsForDate = groupedPosts[dateKey] ?? [];
              final commentsForDate = groupedComments[dateKey] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateKey,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Liked",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 200, // Height for displaying posts
                    child: Scrollbar(
                      child: PageView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (postsForDate.length / 4).ceil(), // Number of pages
                        itemBuilder: (context, pageIndex) {
                          final startIndex = pageIndex * 4;
                          final endIndex = (startIndex + 4).clamp(0, postsForDate.length);
                          final pagePosts = postsForDate.sublist(startIndex, endIndex);
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: _buildPosts(pagePosts, showHeart: true),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Commented",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  commentsForDate.isEmpty
                      ? const Text("No comments available", style: TextStyle(fontStyle: FontStyle.italic, fontWeight:FontWeight.bold, fontSize: 30,color: Colors.grey))
                      : SizedBox(
                          height: 200, // Height for displaying comments
                          child: Scrollbar(
                            child: PageView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: (commentsForDate.length / 4).ceil(), // Number of pages
                              itemBuilder: (context, pageIndex) {
                                final startIndex = pageIndex * 4;
                                final endIndex = (startIndex + 4).clamp(0, commentsForDate.length);
                                final pageComments = commentsForDate.sublist(startIndex, endIndex);
                                return ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: _buildComments(pageComments),
                                );
                              },
                            ),
                          ),
                        ),
                                          const SizedBox(height: 20),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
