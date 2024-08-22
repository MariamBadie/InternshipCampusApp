import 'package:campus_app/screens/main_screen.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _results = [];
  static List previousSearchs = [];

  String _selectedCategory = "All";

  void _performSearch(String query) {
    setState(() {
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
              onEditingComplete: () {
                previousSearchs.add(_searchController.text);
                _performSearch(_searchController.text);
              },
            ),
          ),
          Container(height: 5),
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categoryItem("All"),
                categoryItem("Users"),
                categoryItem("Posts"),
                categoryItem("Events"),
              ],
            ),
          ),
          Container(height: 5),

          // Previous Searches
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: previousSearchs.length,
                itemBuilder: (context, index) => previousSearchsItem(index)),
          ),
        ],
      ),
    );
  }

  Widget categoryItem(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = category;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  previousSearchsItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: InkWell(
        onTap: () {},
        child: Dismissible(
          key: GlobalKey(),
          onDismissed: (DismissDirection dir) {
            setState(() {});
            previousSearchs.removeAt(index);
          },
          child: Row(
            children: [
              const Icon(
                Icons.access_alarm,
                size: 20,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                previousSearchs[index],
                style: TextStyle(fontSize: 16),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.cancel, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    previousSearchs.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
