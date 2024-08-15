import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'event_details_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _results = [];
  List<String> _searchHistory = [];

  void _performSearch(String query) {
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.add(query); // Add to search history
      });
    }
    setState(() {
      // For demonstration, using static data
      _results = List.generate(10, (index) => 'Result $index for "$query"');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => _performSearch(_searchController.text),
                ),
              ),
              onSubmitted: (query) => _performSearch(query),
            ),
          ),
          Container(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(height: 10),
          Container(
            height: 300,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(100)),
                      child: Image.asset(
                        'assets/images/friends.png',
                        height: 45,
                        width: 45,
                      ),
                      padding: EdgeInsets.all(10)),
                  Text("Friends"),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(100)),
                      child: Image.asset(
                        'assets/images/posts.png',
                        height: 45,
                        width: 45,
                      ),
                      padding: EdgeInsets.all(10)),
                  Text("Posts"),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(100)),
                      child: Image.asset(
                        'assets/images/Staff.png',
                        height: 45,
                        width: 45,
                      ),
                      padding: EdgeInsets.all(10)),
                  Text("Staff"),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(100)),
                      child: Image.asset(
                        'assets/images/officess.png',
                        height: 48,
                        width: 48,
                      ),
                      padding: EdgeInsets.all(10)),
                  Text("Offices"),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(right: 10),
                child: Column(children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(100)),
                      child: Icon(
                        Icons.event,
                        size: 48,
                      ),
                      padding: EdgeInsets.all(10)),
                  Text("Events"),
                ]),
              ),
            ]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_results[index]),
                  onTap: () {
                    // Handle item tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
