import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../models/Community.dart';
import '../../screens/community_page.dart';

class CommunityCard extends StatelessWidget {
   final Community communityInfo;
   CommunityCard({required this.communityInfo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
                  radius: 10.0,
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: (){
                     Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommunityPage(isMember:true,communityData:communityInfo),
                          ),
                        );
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
                          boxShadow: CupertinoContextMenu.kEndBoxShadow,
                          image: DecorationImage(
                            image:AssetImage(communityInfo.pictureUrl),
                            fit: BoxFit.cover,
                          ),
                        )
                                   ),
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
                        '${communityInfo.name}',
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
                 )
    
    
    
    ;
  }
}