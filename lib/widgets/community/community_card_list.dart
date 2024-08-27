import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/Community.dart';
import 'community_card.dart';

class CommunityCardList extends StatefulWidget {
  List<Community>communities;
  CommunityCardList({super.key,required this.communities});

  @override
  State<CommunityCardList> createState() => _CommunityCardListState();
}

class _CommunityCardListState extends State<CommunityCardList> {
  final int initialItemCount = 5;
  late bool showAll;
  initState(){
   showAll =widget.communities.length <= initialItemCount?true: false;
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
                elevation: 3.0,
                color:Colors.white,
                  child: SizedBox(
                    height: 140.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: showAll?widget.communities.length:initialItemCount+1,
                      itemBuilder:(context, index) {
                      if (!showAll && index == initialItemCount ) {
                          return InkWell(
                          radius: 10.0,
                          borderRadius: BorderRadius.circular(12.0),
                          onTap: (){
                            setState(()
                            {
                              showAll = true;
                            });
                          },
                            child: Card(
                              margin: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 5,
                              child: Stack(
                                children: [
                            Container(
                                width: 180,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.4), 
                                      Colors.transparent, 
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 32.0,
                                bottom:15.0 ,
                                child:Text(
                                  'View more ',
                                style:TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                                ), 
                              )
                              ],
                              ),
                            ),
                          );
                                  }
                                  return CommunityCard(communityInfo: widget.communities[index],); 
                                  } 
                            ),
                  )

 );
  }
}