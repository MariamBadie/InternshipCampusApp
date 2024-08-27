import 'package:flutter/cupertino.dart';
import '../models/Community.dart';
import '../widgets/community/search_bar.dart' as searchComp;
import '../widgets/community/community_list.dart';
class CommunityListPage extends StatefulWidget {
  List <Community>communities;
 CommunityListPage({super.key,required this.communities});

  @override
  State<CommunityListPage> createState() => _CommunityListPageState();
}

class _CommunityListPageState extends State<CommunityListPage> {
   List<Community>searchResult=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchResult=widget.communities;
  }
  void getResult(String searchValue){
    List<Community>result= [];
    if(searchValue.isEmpty){
      result=widget.communities;
    }
    else{
      result= widget.communities.where((community)=>community.name.toLowerCase().
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
                searchComp.SearchBar(list:widget.communities,label :'Search Community',getResult:getResult),
                CommunityList(communities:searchResult)
              ],
            );
  }
}