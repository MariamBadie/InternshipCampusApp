import 'package:flutter/material.dart';
import '../../models/Community.dart';
import '../../widgets/community/join_button.dart';
import '../../screens/community_page.dart';
class SuggestedCommunities extends StatelessWidget {
  final List<Community>SuggestedCommunity;
  const SuggestedCommunities({super.key,required this.SuggestedCommunity});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
               child: ListView.builder(
                itemCount:SuggestedCommunity.length,
                  itemBuilder:(context,index){
                  return Card(
                      elevation:2.0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15.0),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(
                            builder: (context) => CommunityPage(isMember:false,communityData:SuggestedCommunity[index]),
                          ),);
                        },
                        title:Text(
                          SuggestedCommunity[index].name,
                          style: const TextStyle(
                           fontWeight: FontWeight.w600,
                           letterSpacing: 0.5,
                          ),
                        ),
                        subtitle: Text(SuggestedCommunity[index].goal),
                         leading:CircleAvatar(
                            backgroundImage:AssetImage(SuggestedCommunity[index].pictureUrl) ,
                          ),
                          trailing: JoinButton(isJoined:false),
                      ),
                  );
                  }
                   ),
             );
  }
}