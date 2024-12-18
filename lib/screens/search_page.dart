import 'package:campus_app/utils/getCurrentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> userResults = [];
  List<DocumentSnapshot> filteredUserResults = [];
  List<DocumentSnapshot> postResults = [];
  List<DocumentSnapshot> filteredPostResults = [];
  List<DocumentSnapshot> outletResults = [];
  List<DocumentSnapshot> filteredOutletResults = [];
  static List<String> previousSearches = [];
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchPostData();
    fetchOutletData();
  }

  Future<void> fetchUserData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("User").get();
    setState(() {
      userResults = querySnapshot.docs;
      if (selectedCategory == "Users" || selectedCategory == "All") {
        filterUserResults(_searchController.text);
      }
    });
  }

  Future<void> fetchPostData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Posts").get();
    setState(() {
      postResults = querySnapshot.docs;
      if (selectedCategory == "Posts" || selectedCategory == "All") {
        filterPostResults(_searchController.text);
      }
    });
  }

  Future<void> fetchOutletData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Outlet").get();
    setState(() {
      outletResults = querySnapshot.docs;
      if (selectedCategory == "Outlets" || selectedCategory == "All") {
        filterOutletResults(_searchController.text);
      }
    });
  }

  void filterUserResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUserResults = userResults;
      } else {
        filteredUserResults = userResults.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          var name = data['name']?.toLowerCase() ?? '';
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void filterPostResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPostResults = postResults;
      } else {
        filteredPostResults = postResults.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          var title = data['title']?.toLowerCase() ?? '';
          var content = data['content']?.toLowerCase() ?? '';
          return title.contains(query.toLowerCase()) ||
              content.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void filterOutletResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOutletResults = outletResults;
      } else {
        filteredOutletResults = outletResults.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          var name = data['name']?.toLowerCase() ?? '';
          return name.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _performSearch(String query) {
    if (selectedCategory == "Users") {
      filterUserResults(query);
    } else if (selectedCategory == "Posts") {
      filterPostResults(query);
    } else if (selectedCategory == "Outlets") {
      filterOutletResults(query);
    } else if (selectedCategory == "All") {
      filterUserResults(query);
      filterPostResults(query);
      filterOutletResults(query);
    }
  }

  void _fetchDataBasedOnCategory() {
    if (selectedCategory == "Users") {
      fetchUserData();
    } else if (selectedCategory == "Posts") {
      fetchPostData();
    } else if (selectedCategory == "Outlets") {
      fetchOutletData();
    } else if (selectedCategory == "All") {
      fetchUserData();
      fetchPostData();
      fetchOutletData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = getCurrentUser(context);

    final query = _searchController.text;

    if (selectedCategory != "All") {
      _fetchDataBasedOnCategory();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
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
                  icon: const Icon(Icons.search),
                  onPressed: () => _performSearch(query),
                ),
              ),
              onChanged: (newQuery) => _performSearch(newQuery),
            ),
          ),
          Container(height: 5),
          SizedBox(
            height: 54,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categoryItem("All"),
                categoryItem("Users"),
                categoryItem("Posts"),
                categoryItem("Outlets"),
                categoryItem("Events"),
              ],
            ),
          ),
          Container(height: 5),
          if (query.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: (selectedCategory == "All"
                    ? filteredUserResults.length +
                        filteredPostResults.length +
                        filteredOutletResults.length
                    : (selectedCategory == "Users"
                        ? filteredUserResults.length
                        : (selectedCategory == "Posts"
                            ? filteredPostResults.length
                            : filteredOutletResults.length))),
                itemBuilder: (context, index) {
                  if (selectedCategory == "Users" ||
                      (selectedCategory == "All" &&
                          index < filteredUserResults.length)) {
                    var data = filteredUserResults[index].data()
                        as Map<String, dynamic>;
                    var name = data['name'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              previousSearches.add(name);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  size: 24.0,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (selectedCategory == "Posts" ||
                      (selectedCategory == "All" &&
                          index <
                              filteredUserResults.length +
                                  filteredPostResults.length)) {
                    var postIndex = selectedCategory == "All"
                        ? index - filteredUserResults.length
                        : index;
                    var data = filteredPostResults[postIndex].data()
                        as Map<String, dynamic>;
                    var title = data['title'];
                    var content = data['content'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              previousSearches.add(title);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.article,
                                      size: 20.0,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 7),
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  content,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    var outletIndex = selectedCategory == "All"
                        ? index -
                            filteredUserResults.length -
                            filteredPostResults.length
                        : index;
                    var data = filteredOutletResults[outletIndex].data()
                        as Map<String, dynamic>;
                    var name = data['name'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              previousSearches.add(name);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.store,
                                  size: 24.0,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          else
            Container(),
          if (query.isEmpty)
            Expanded(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: previousSearches.length,
                    itemBuilder: (context, index) =>
                        previousSearchesItem(index),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        previousSearches.clear();
                      });
                    },
                    child: const Text("Clear All"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget categoryItem(String category) {
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
          _fetchDataBasedOnCategory();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(2),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Colors.teal[800]!, Colors.teal[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.grey[300]!, Colors.grey[300]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white,
            width: 2,
          ),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget previousSearchesItem(int index) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          child: InkWell(
            onTap: () {},
            child: Dismissible(
              key: GlobalKey(),
              onDismissed: (DismissDirection dir) {
                setState(() {
                  previousSearches.removeAt(index);
                });
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.access_alarm,
                    size: 22,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    previousSearches[index],
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        size: 22, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _searchController.text = previousSearches[index];
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 0.5,
          color: Colors.grey,
          indent: 10,
          endIndent: 10,
        ),
      ],
    );
  }
}
