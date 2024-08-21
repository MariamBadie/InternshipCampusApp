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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Categories',
              style: TextStyle(
                fontSize: 15,
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
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                            'assets/images/friends.png',
                            height: 45,
                            width: 45,
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        Text("Friends"),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                            'assets/images/posts.png',
                            height: 45,
                            width: 45,
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        Text("Posts"),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                            'assets/images/outlets.png',
                            height: 45,
                            width: 45,
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        Text("Outlets"),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                            'assets/images/officess.png',
                            height: 45,
                            width: 45,
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        Text("Offices"),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Column(children: [
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(100)),
                          child: Image.asset(
                            'assets/images/events.jpg',
                            height: 45,
                            width: 45,
                          ),
                          padding: EdgeInsets.all(10)),
                      Text("Events"),
                    ]),
                  ),
                ]),
          ),
          // Previous Searches
          Container(
            color: Colors.white,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: previousSearchs.length,
                itemBuilder: (context, index) => previousSearchsItem(index)),
          ),

          Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  previousSearchs.clear();
                });
              },
              child: Text(
                "Clear all",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  previousSearchsItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                size: 25,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                previousSearchs[index],
                style: TextStyle(fontSize: 20),
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
