import 'package:flutter/material.dart';
class SearchBar extends StatefulWidget {
  List<dynamic> list;
  String label;
  Function (String searchValue) getResult;

  SearchBar({super.key,required this.list,required this.label,required this.getResult});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
                    padding:const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (searchValue) => widget.getResult(searchValue),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        prefixIconColor: Colors.deepPurple,
                        label:Text(
                          widget.label
                        ) ,
                        labelStyle: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold
                        ),
                        border:const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width:1.0,
                            style: BorderStyle.solid,
                            strokeAlign: -1.0,
                          )
                        ),
                        enabledBorder:const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.deepPurple,
                            width:1.0,
                            style: BorderStyle.solid,
                            strokeAlign: -1.0,
                          )
                        ),
                        hintText:widget.label,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            _searchController.clear();
                            widget.getResult('');
                          },
                          icon:const Icon(Icons.clear),
                          color: Colors.deepPurple,
                          ),
                      ),
                                    ),
                    );
  }
}

