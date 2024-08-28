import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/Community.dart';
import '../widgets/community/search_bar.dart' as searchComp;
import  '../widgets/community/suggested_community_list.dart';

class SuggestedCommunityPage extends StatefulWidget {
  List<Community>SuggestedCommunities;
  SuggestedCommunityPage({super.key,required this.SuggestedCommunities});

  @override
  State<SuggestedCommunityPage> createState() => _SuggestedCommunityPageState();
}

class _SuggestedCommunityPageState extends State<SuggestedCommunityPage> {
  List<Community>searchResult=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchResult=widget.SuggestedCommunities;
  }
  void getResult(String searchValue){
    List<Community>result= [];
    if(searchValue.isEmpty){
      result=widget.SuggestedCommunities;
    }
    else{
      result= widget.SuggestedCommunities.where((community)=>community.name.toLowerCase().
              contains(searchValue.toLowerCase())).toList();
    }
    setState(() {
      searchResult=result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
              children:[
                searchComp.SearchBar(list:widget.SuggestedCommunities,label:'Search Community',getResult:getResult),
                SuggestedCommunities(SuggestedCommunity:searchResult)
              ],
              
            );
  }
}