import 'package:campus_app/screens/main_screen.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class CustomSearch extends SearchDelegate {
  @override
  String get searchFieldLabel => "Search Outlets";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close_sharp),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text("");
  }
}

class CustomSearch1 extends SearchDelegate {
  @override
  String get searchFieldLabel => "Search Posts";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close_sharp),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text("");
  }
}

class CustomSearch2 extends SearchDelegate {
  @override
  String get searchFieldLabel => "Search Offices";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close_sharp),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text("");
  }
}

class CustomSearch3 extends SearchDelegate {
  List Profiles = [
    "Ahmed Hany",
    "Mohie-Eldin Mohamed",
    "Anas Tamer",
    "Aly Hussein",
    "Noor Wael",
    "Noor Ahmed",
    "Youssef Alaa",
    "Yassin Aly",
    "Ahmed Adel",
    "Ahmed Mohamed",
    "Rana Khaled",
    "Mariam Mohamed",
  ];
  List? Filter;
  @override
  String get searchFieldLabel => "Search Friends";

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close_sharp),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == "") {
      return ListView.builder(
        itemCount: Profiles.length,
        itemBuilder: (context, i) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 24.0,
                  ),
                  Container(width: 7),
                  Text(
                    "${Profiles[i]}",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      Filter = Profiles.where((element) => element.contains(query)).toList();
      return ListView.builder(
        itemCount: Filter!.length,
        itemBuilder: (context, i) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 24.0,
                  ),
                  Container(width: 7),
                  Text(
                    "${Profiles[i]}",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
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
                  GestureDetector(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearch3(),
                      );
                    },
                    child: Container(
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
                  ),
                  GestureDetector(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearch1(),
                      );
                    },
                    child: Container(
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
                  ),
                  GestureDetector(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearch(),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Image.asset(
                              'assets/images/Outlets.png',
                              height: 45,
                              width: 45,
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                          Text("Outlets"),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showSearch(
                        context: context,
                        delegate: CustomSearch2(),
                      );
                    },
                    child: Container(
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
