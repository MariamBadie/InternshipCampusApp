import 'package:flutter/material.dart';
import 'join_button.dart';
import '../../models/Community.dart';
import '../../screens/community_page.dart';
class CommunityList extends StatelessWidget {
  List<Community> communities;
  CommunityList({super.key,required this.communities});

  @override
  Widget build(BuildContext context) {
    return Expanded(
               child: ListView.builder(
                itemCount:communities.length,
                  itemBuilder:(context,index){
                  return Card(
                      elevation:2.0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15.0),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(
                            builder: (context) => CommunityPage(isMember:true,communityData:communities[index]),
                          ),);
                        },
                        title:Text(
                          communities[index].name,
                          style: const TextStyle(
                           fontWeight: FontWeight.w600,
                           letterSpacing: 0.5,
                          ),
                        ),
                        subtitle: Text(communities[index].goal),
                         leading:CircleAvatar(
                            backgroundImage:AssetImage(communities[index].pictureUrl) ,
                          ),
                          trailing: JoinButton(isJoined:true),
                      ),
                  );
                  }
                   ),
             );
  }
}