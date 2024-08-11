import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  String type = 'All Types';

  final List<Map<String, String>> posts = [
    {
      'title': 'Post 1',
      'content': 'This is the content of post 1.',
      'type': 'normal Post'
    },
    {
      'title': 'Post 2',
      'content': 'This is the content of post 2.',
      'type': 'Academic Post'
    },
    {
      'title': 'Post 3',
      'content': 'This is the content of post 3.',
      'type': 'normal Post'
    },
    {
      'title': 'Post 4',
      'content': 'This is the content of post 4.',
      'type': 'Academic Post'
    },
    {
      'title': 'Post 5',
      'content': 'This is the content of post 5.',
      'type': 'normal Post'
    },
    {
      'title': 'Post 6',
      'content': 'This is the content of post 6.',
      'type': 'Academic Post'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Archives ",
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
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150, // Maximum width for each item
                childAspectRatio: 1, // Aspect ratio of each card (width/height)
                mainAxisSpacing: 10, // Space between rows
                crossAxisSpacing: 10, // Space between columns
              ),
              padding: const EdgeInsets.all(10),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  child: Container(
                    width: 150,
                    height: 150,
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
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.more_vert_rounded)),
                            ]),
                        Text(post['content']!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
