import 'package:campus_app/backend/Controller/userController.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  late Future<List<List<dynamic>>> usersFuture; // Future to hold the user data

  @override
  void initState() {
    super.initState();
    // Initialize the Future when the page loads
    usersFuture = getUserKarmas();
  }
  void _refreshData() {
    setState(() {
      usersFuture = getUserKarmas(); // Refresh the data
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData, // Refresh the data
          ),
        ],
      ),
      body: FutureBuilder<List<List<dynamic>>>(
        future: usersFuture, // Connect the Future here
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading spinner while waiting for the Future to complete
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle errors
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle empty data
            return const Center(child: Text('No users available'));
          }

          // If the Future resolves successfully, use the data
          List<List<dynamic>> users = snapshot.data!;

          return Column(
            children: [
              // Top 3 users section displayed in long rectangles
              SizedBox(
                height: 200,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Second place (on the left)
                      if (users.length > 1)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.star_border, size: 30, color: Colors.grey),
                              Container(
                                width: 90,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      users[1][0], // Second place
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Karma: ${users[1][1]}', // Karma points
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text("2nd Place", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                      // First place (in the middle with crown)
                      if (users.isNotEmpty)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.emoji_events, size: 50, color: Colors.amber), // Crown icon
                              Container(
                                width: 90,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      users[0][0], // First place
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Karma: ${users[0][1]}', // Karma points
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text("1st Place", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      // Third place (on the right)
                      if (users.length > 2)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(Icons.star_border, size: 30, color: Colors.grey),
                              Container(
                                width: 90,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      users[2][0], // Third place
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Karma: ${users[2][1]}', // Karma points
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text("3rd Place", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // List of remaining users dynamically populated
              Expanded(
                child: ListView.builder(
                  itemCount: users.length - 3,
                  itemBuilder: (context, index) {
                    final user = users[index + 3]; // Start from 4th place
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text((index + 4).toString()), // Dynamic rank after 3rd place
                      ),
                      title: Text(user[0]),
                      subtitle: Text("Karma: ${user[1]}"),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
