import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../screens/suggested_community_page.dart';
import '../../models/Community.dart';
class SearchBar extends StatefulWidget {
  List<dynamic> list;
  String label;
  Function (String searchValue) getResult;

  SearchBar({super.key,required this.list,required this.label,required this.getResult});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
                    padding:EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (searchValue) => widget.getResult(searchValue),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        prefixIconColor: Colors.deepPurple,
                        label:Text(
                          widget.label
                        ) ,
                        labelStyle: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold
                        ),
                        border:OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width:1.0,
                            style: BorderStyle.solid,
                            strokeAlign: -1.0,
                          )
                        ),
                        enabledBorder:OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width:1.0,
                            style: BorderStyle.solid,
                            strokeAlign: -1.0,
                          )
                        ),
                        hintText:widget.label,
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            _searchController.clear();
                            widget.getResult('');
                          },
                          icon:Icon(Icons.clear),
                          color: Colors.deepPurple,
                          ),
                      ),
                                    ),
                    );
  }
}

