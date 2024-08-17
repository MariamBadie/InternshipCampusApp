import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _results = [];
  List<String> _searchHistory = [];
  List<bool> rowVisiblity = [true, true, true];

  void _performSearch(String query) {
    if (query.isNotEmpty && !_searchHistory.contains(query)) {
      setState(() {
        _searchHistory.add(query);
      });
    }
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
            ),
          ),
          Container(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 110,
            child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(8),
                children: [
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
                            height: 45,
                            width: 45,
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
                          child: Image.asset(
                            'assets/images/events.png',
                            height: 45,
                            width: 45,
                          ),
                          padding: EdgeInsets.all(10)),
                      Text("Events"),
                    ]),
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                if (rowVisiblity[0])
                  Row(
                    children: [
                      const Icon(
                        Icons.access_alarm,
                        size: 30,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Dr mervat",
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            rowVisiblity[0] = false;
                          });
                        },
                      ),
                    ],
                  ),
                if (rowVisiblity[1])
                  Row(
                    children: [
                      const Icon(
                        Icons.access_alarm,
                        size: 30,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "cs3",
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.cancel_rounded,
                            color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            rowVisiblity[1] = false;
                          });
                        },
                      ),
                    ],
                  ),
                if (rowVisiblity[2])
                  Row(
                    children: [
                      const Icon(
                        Icons.access_alarm,
                        size: 30,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "AISEC",
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            rowVisiblity[2] = false;
                          });
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                rowVisiblity[0] = false;
                rowVisiblity[1] = false;
                rowVisiblity[2] = false;
              });
            },
            child: Text(
              "Clear all",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
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
