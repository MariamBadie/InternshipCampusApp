import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  String description = 'All categories';
  String type = 'All Types';

  final List<Map<String, String>> posts = [
    {
      'title': 'Post 1',
      'content': 'This is the content of post 1.',
      'type': 'normal Post',
      'description': 'Travel'
    },
    {
      'title': 'Post 2',
      'content': 'This is the content of post 2.',
      'type': 'Academic Post',
      'description': 'Travel'
    },
    {
      'title': 'Post 3',
      'content': 'This is the content of post 3.',
      'type': 'normal Post',
      'description': 'Shopping'
    },
    {
      'title': 'Post 4',
      'content': 'This is the content of post 4.',
      'type': 'Academic Post',
      'description': 'Travel'
    },
    {
      'title': 'Post 5',
      'content': 'This is the content of post 5.',
      'type': 'normal Post',
      'description': 'Shopping'
    },
    {
      'title': 'Post 6',
      'content': 'This is the content of post 6.',
      'type': 'Academic Post',
      'description': 'Travel'
    },
  ];

  List<Map<String, String>> getFilteredPosts() {
    return posts.where((post) {
      final matchesDescription =
          description == 'All categories' || post['description'] == description;
      final matchesType = type == 'All Types' || post['type'] == type;
      return matchesDescription && matchesType;
    }).toList();
  }

  Map<String, double> calculateDescriptionPercentages() {
    final filteredPosts = getFilteredPosts();
    final Map<String, int> descriptionCount = {};

    for (var post in filteredPosts) {
      final desc = post['description']!;
      if (descriptionCount.containsKey(desc)) {
        descriptionCount[desc] = descriptionCount[desc]! + 1;
      } else {
        descriptionCount[desc] = 1;
      }
    }

    final totalPosts = filteredPosts.length;
    final Map<String, double> descriptionPercentages = {};

    descriptionCount.forEach((key, count) {
      descriptionPercentages[key] = (count / totalPosts) * 100;
    });

    return descriptionPercentages;
  }

  @override
  Widget build(BuildContext context) {
    final filteredPosts = getFilteredPosts();
    final descriptionPercentages = calculateDescriptionPercentages();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Favorites ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20), // Add some space from the top
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: description,
                items: const [
                  DropdownMenuItem(
                    value: 'All categories',
                    child: Text('All categories'),
                  ),
                  DropdownMenuItem(
                    value: 'Travel',
                    child: Text('Travel'),
                  ),
                  DropdownMenuItem(
                    value: 'Shopping',
                    child: Text('Shopping'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    description = newValue!;
                  });
                },
              ),
              const SizedBox(width: 50), // Space between dropdowns
              DropdownButton<String>(
                value: type,
                items: const [
                  DropdownMenuItem(
                    value: 'All Types',
                    child: Text('All Types'),
                  ),
                  DropdownMenuItem(
                    value: 'Academic Post',
                    child: Text('Academic Post'),
                  ),
                  DropdownMenuItem(
                    value: 'normal Post',
                    child: Text('normal Post'),
                  ),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    type = newValue!;
                  });
                },
              ),
              const SizedBox(width: 50), // Space between dropdowns
              TextButton(
                  onPressed: () => _deleteDialog(context),
                  child: const Row(
                    children: [
                      Icon(Icons.delete),
                      Text("Clear All My Favorite")
                    ],
                  ))
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 190, // Maximum width for each item
                childAspectRatio: 1, // Aspect ratio of each card (width/height)
                mainAxisSpacing: 10, // Space between rows
                crossAxisSpacing: 10, // Space between columns
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
                            ]),
                        Text(post['content']!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {},
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
                    title: '${entry.key}\n${entry.value.toStringAsFixed(1)}%',
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
          children: [Text('Are You sure you want to clear Your Favorites?')],
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
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
