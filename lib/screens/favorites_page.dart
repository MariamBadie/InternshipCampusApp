import 'package:campus_app/backend/Controller/userController.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}
 String userID='upeubEqcmzSU9aThExaO';

class _FavoritesPageState extends State<FavoritesPage> {
  String selectedTag = 'All categories';
  String type = 'All Types';
  List<Map<String, dynamic>> posts = [];
  List<String> hashtags = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchFavoritePosts();
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
          'hashtags': _extractHashtags(postList[2]),
        };
      }).toList();

      // Collect all unique hashtags
      hashtags = posts
          .expand((post) => post['hashtags'] as List<String>)
          .toSet()
          .toList();  // Update instance variable
          
      print(hashtags); // Log to verify tags are collected correctly
      isLoading = false;
    });
  } catch (e) {
    print("Error fetching favorite posts: $e");
    setState(() {
      isLoading = false;
    });
  }
}

List<String> _extractHashtags(String content) {
  print("Content: $content");  // Log the content

  final hashtagRegExp = RegExp(r'#(\w+)', caseSensitive: false);

  // Log the number of matches found
  final matches = hashtagRegExp.allMatches(content);
  print("Found ${matches.length} hashtag(s)");

  for (var match in matches) {
    print("Match: ${match.group(0)}");
  }

  // Return the actual hashtags (without the '#')
  return matches.map((match) => match.group(1)!).toList();
}

  List<Map<String, dynamic>> getFilteredPosts() {
    return posts.where((post) {
      final matchesType = type == 'All Types' || post['type'] == type;
      final matchesTag = selectedTag == 'All categories' || post['hashtags'].contains(selectedTag);
      return matchesType && matchesTag;
    }).toList();
  }

Map<String, double> calculateCategoryPercentages() {
  final filteredPosts = getFilteredPosts(); // Get the posts filtered by type and selected tag
  final Map<String, int> categoryCount = {};

  // Count the occurrences of each hashtag (category)
  for (var post in filteredPosts) {
    final List<String> postHashtags = post['hashtags'] as List<String>;
    for (var hashtag in postHashtags) {
      if (categoryCount.containsKey(hashtag)) {
        categoryCount[hashtag] = categoryCount[hashtag]! + 1;
      } else {
        categoryCount[hashtag] = 1;
      }
    }
  }

  final totalCategories = filteredPosts.fold<int>(0, (sum, post) => sum + (post['hashtags'] as List<String>).length);
  final Map<String, double> categoryPercentages = {};

  // Calculate percentages for each category
  categoryCount.forEach((key, count) {
    categoryPercentages[key] = (count / totalCategories) * 100;
  });

  return categoryPercentages;
}

  @override
  Widget build(BuildContext context) {
    final filteredPosts = getFilteredPosts();
    final descriptionPercentages = calculateCategoryPercentages();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _fetchFavoritePosts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: selectedTag,
                      items: [
                        const DropdownMenuItem(
                          value: 'All categories',
                          child: Text('All categories'),
                        ),
                        ...hashtags.map((tag) {
                          return DropdownMenuItem(
                            value: tag,
                            child: Text('#$tag'),
                          );
                        }),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTag = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 50),
                    DropdownButton<String>(
                      value: type,
                      items: const [
                        DropdownMenuItem(
                          value: 'All Types',
                          child: Text('All Types'),
                        ),
                        DropdownMenuItem(
                          value: 'Confession',
                          child: Text('Confession'),
                        ),
                        DropdownMenuItem(
                          value: 'Post',
                          child: Text('Post'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          type = newValue!;
                        });
                      },
                    ),
                    const SizedBox(width: 50),
                    TextButton(
                        onPressed: () => _deleteDialog(context),
                        child: const Row(
                          children: [
                            Icon(Icons.delete),
                            Text("Clear All My Favorites")
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 190,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    padding: const EdgeInsets.all(10),
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];
                      return Card(
                        child: Container(
                          width: 190,
                          height: 190,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    post['title']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Text(post['content']!),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      removeFromFavorites(userID,post["postID"].toString());
                                    },
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 250,
                  padding: const EdgeInsets.all(10),
                  child: PieChart(
                    PieChartData(
                      sections: descriptionPercentages.entries.map((entry) {
                        return PieChartSectionData(
                          color: Colors.primaries[descriptionPercentages.keys
                                  .toList()
                                  .indexOf(entry.key) %
                              Colors.primaries.length],
                          value: entry.value,
                          title:
                              '${entry.key}\n${entry.value.toStringAsFixed(1)}%',
                          radius: 100,
                          titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        );
                      }).toList(),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

void _deleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text('Are you sure you want to clear your Favorites?')],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('DELETE'),
            onPressed: () {
            clearMyFavorites(userID); 
            Navigator.of(context).pop();
           },
          ),
        ],
      );
    },
  );
}
