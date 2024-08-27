import 'dart:ui';

import 'package:campus_app/screens/about_us_page.dart';
import 'package:device_preview/device_preview.dart';
import '../screens/community_members.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../models/Community.dart';
import'../models/User.dart';
import 'main_screen.dart' as utils;
import 'invite_new_members.dart';
import '../screens/add_post_page.dart';


class CommunityPage extends StatefulWidget {
  bool isMember; 
  Community communityData;
  CommunityPage({super.key,required this.isMember ,required this.communityData});

  @override
  State<CommunityPage> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  final TextEditingController _Report = TextEditingController();
  String? _selectedNotificationOption; 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:
            Row(
              children: [
                CircleAvatar(
                backgroundImage:AssetImage(widget.communityData.pictureUrl)
            ),
            SizedBox(
              width: 13.0,
            ),
            
                Text(widget.communityData.name,
                style:TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                          
                      )),
              ],
            ),
          
        
        actions: widget.isMember?[
            PopupMenuButton(
              icon: Icon(Icons.more_vert), 
              onSelected: (String result) {
                if(result=='InviteFriends'){
                  _navigateToInvitePage(context);
                }
                else if(result=='Report'){
                  _showReportAlertDialog(context);
                }
                else if(result=='ManageNotification'){
                 _showmanageNotificationsOptions(context);
                     
                }else if(result =='Leave'){
                  showLeaveCommunityDialog(context);
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                 
                  value: 'InviteFriends',
                  child: Text('Invite friends'),
                ),
                PopupMenuItem(
                  value: 'Report',
                  child: Text('Report'),
                ),
                PopupMenuItem(
                  value: 'ManageNotification',
                  child: Text('Manage notification'),
                ),
                 PopupMenuItem(
                  value: 'Leave',
                  child: Text('Leave group'),

                ),
              ]
            ),
          ]:null,
    
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
            child:Column(
              children: [ Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.communityData.pictureUrl),
                      fit: BoxFit.cover, 
                    ),
                  ),
                )
              ,SizedBox(
                height: 20.0,
              ),
        
                    Text(
                    widget.communityData.name,
                    style:TextStyle(
                         letterSpacing: 1.0,
                         fontSize: 30.0,
                         fontWeight: FontWeight.bold,
                    ),           
                    ),
                    SizedBox(
                      height:7.0
                    ),

                    JoinWidget(
                      isMember: widget.isMember,
                       onChanged: (value) { 
                        setState((){
                          widget.isMember=value;
                        });
                        }, 
                       communityData: widget.communityData,
                       onDisjoin: showLeaveCommunityDialog,
                       ),
                    SizedBox(
                       height: 25.0,
                    ),
          ]
          ),
          ),
        Card(
          child:
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                         SizedBox(
                         width: 5.0,
                        ),
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/images/profile-pic.png'),
                        ),
                        SizedBox(
                         width: 10.0,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: (){
                              _showPostOptions();
                            },
                            child:Text(
                              'Write something.. ',
                              style: TextStyle(
                              fontWeight: FontWeight.w100,
                             
                             )
                            ),
                          ),
                        )
                      ],
                    ),
                
                  Divider(
                      height: 13.0,
                      indent: 10.0,
                      endIndent: 10.0,
                  )],
                ),
              ),
      
        
        ),    
          ],
            
        ),
      ),
    );
  }
void _leaveCommunity(){
  setState((){
    widget.isMember=false;
  });
  ScaffoldMessenger.of(context).showSnackBar(
 const SnackBar(content: Text('You are no longer member of this community')));
}
void showLeaveCommunityDialog(BuildContext context){
  showDialog(
    context: context,
    builder:(context){
      return AlertDialog(
        title:Center(child: Text('Leave Community')),
        titleTextStyle: TextStyle(
          fontSize:20.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
        insetPadding: EdgeInsets.all(20.0),
        titlePadding: EdgeInsets.all(15.0),
        content: 
            Text('Are you sure that you want leave this community ?'),
        contentPadding: EdgeInsets.all(30.0),
        contentTextStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          ElevatedButton(
            onPressed:(){
              Navigator.pop(context);
            },
             child:Text('Cancel',
             style:TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,

        ),
             )
              ),
          ElevatedButton(
            onPressed:(){
              Navigator.pop(context);
              _leaveCommunity();
            },
             child:Text('Confirm',
             style:TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,

        ),
              )
              )
        ],

    );
    }
  );
}

void _discardChanges(BuildContext context){
    if(_Report.text.isNotEmpty){
      showDialog(
    context: context,
    builder:(context){
      return AlertDialog(
        title:Center(child: Text('Discard changes')),
        titleTextStyle: TextStyle(
          fontSize:20.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
        insetPadding: EdgeInsets.all(20.0),
        titlePadding: EdgeInsets.all(15.0),
        content: 
            Text('Do you want to discard this changes?'),
        contentPadding: EdgeInsets.all(30.0),
        contentTextStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          ElevatedButton(
            onPressed:(){
              Navigator.pop(context);
            },
             child:Text('Cancel',
             style:TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,

        ),
             )
              ),
          ElevatedButton(
            onPressed:(){
              Navigator.pop(context);
              Navigator.pop(context);
              _Report.clear();
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Changes have been discarded')),
      );
            },
             child:Text(
              'Confirm',
             style:TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,

        ),
              )
              )
        ],

    );
    }
  );
  }
  else{
  Navigator.pop(context);
  }
  }
void _showReportAlertDialog(BuildContext context){
            showDialog(
                      context:context,
                      builder:(context){
                        return AlertDialog(
                          //titlePadding: EdgeInsets.all(13.0),
                          title:Text(
                            'Report',
                            style:TextStyle(
                           fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                  ),
                       textAlign: TextAlign.center,
                          ),
                          content:Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: SingleChildScrollView(
                              child: Container(
                                //width:MediaQuery.of(context).size.width * 0.8,
                                height:200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                 
                                     Text(
                                    'What is your concerns about this community ?',
                                    style:TextStyle(
                                     fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    ),
                                    ),
                                  
                                  SizedBox(
                                    height:20.0,
                                  
                                  ),
                                  TextField(
                                    maxLines:5,
                                    controller: _Report,
                                    decoration: InputDecoration(
                                       border: OutlineInputBorder(),
                                      hintText: 'Enter your concerns ...',
                                    ),
                                  )
                                  ]
                                ),
                              ),
                            ),
                          ),
                        actions: [
            TextButton(
              onPressed: () {
                _discardChanges(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if(_Report.text.isEmpty){
                       ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please Enter your concerns')),);  
                }
                else{
                  Navigator.of(context).pop();
                  _Report.clear(); 
                  ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('We will review your concerns')),
        
      );

                }
                
              },
              child: Text('Submit'),
            ),
          ],
            );
          }
      );
}
void _showmanageNotificationsOptions(BuildContext context){
showModalBottomSheet(
                      context:context,
                      builder:(BuildContext context){
                        return  SizedBox(
                          height :350.0,
                          child:ManageNotification(
                            selectedNotificationOption: _selectedNotificationOption,
                             onSelectedOption: (String? value) {  
                             _selectedNotificationOption=value;
                             }
                          ),
                        );
        }
    );
}
void _navigateToInvitePage(BuildContext context){
  Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) =>InvitationPage(),
                          ),
                        );
}
  void _showPostOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Post Academic Help'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Help');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Post Event'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Event');
              },
            ),
            ListTile(
              leading: const Icon(Icons.forum),
              title: const Text('Post Confession'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Confession');
              },
            ),
            ListTile(
              leading: const Icon(Icons.watch),
              title: const Text('Post Lost & Found'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Lost & Found');
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review),
              title: const Text('Post Review/Rating'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Rating/Review');
              },
            ),
            ListTile(
              leading: const Icon(Icons.note),
              title: const Text('Post Notes'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAddPostPage('Notes');
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToAddPostPage(String postType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPostPage(postType: postType),
      ),
    );
  }
}
class ManageNotification extends StatefulWidget {
  String? selectedNotificationOption;
  ValueChanged<String?> onSelectedOption;
  ManageNotification({super.key,
                      required this.selectedNotificationOption,
                      required this.onSelectedOption});

  @override
  State<ManageNotification> createState() => _ManageNotificationState();
}

class _ManageNotificationState extends State<ManageNotification> {
 String? _selectedNotificationOption;
 @override
  void initState() {
    // TODO: implement initState
    _selectedNotificationOption= widget.selectedNotificationOption;
  }
  @override
  Widget build(BuildContext context) {
    return  Wrap(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Text(
                                    'Manage Notification',
                                    style:TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:20.0
                                  
                                    )
                                  ),
                                ),
                              ),
                              RadioListTile<String>(
                            title: Text('All posts'),
                            subtitle :Text('You will receive notifications of all posts'),
                            value:'All',
                            controlAffinity: ListTileControlAffinity.trailing,
                            groupValue: _selectedNotificationOption,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedNotificationOption = value;
                                          });
                                  widget.onSelectedOption(value);
                                        },
                            ),
                                      RadioListTile<String>(
                            title: Text('Events Only'),
                            subtitle: Text('You will receive notifications of events only'),
                            value:'Events',
                            controlAffinity: ListTileControlAffinity.trailing,
                            groupValue: _selectedNotificationOption,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedNotificationOption = value;
                                          });
                                  widget.onSelectedOption(value);
                                        },
                                      ),
                                      RadioListTile<String>(
                            title: Text('Off'),
                            subtitle:Text('You will receive notifications of mentions only'),
                            value:'Off',
                            controlAffinity: ListTileControlAffinity.trailing,
                            groupValue: _selectedNotificationOption,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedNotificationOption = value;
                                          });
                                widget.onSelectedOption(value);
                                        },
                                      ),]
                          );
  }
}
class JoinWidget extends StatefulWidget {
  bool isMember;
  Community communityData;
  ValueChanged onChanged;
  Function(BuildContext) onDisjoin; 
 JoinWidget({super.key,required this.isMember,required this.communityData,required this.onChanged,required this.onDisjoin});

  @override
  State<JoinWidget> createState() => _JoinWidgetState();
}

class _JoinWidgetState extends State<JoinWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.isMember?[   
        TextButton(
                      onPressed:(){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) =>  CommunityMembersPage(members: widget.communityData.members),
                          ),
                        );
                      },
                      child: Text(widget.communityData.memberCounter.toString() + ' members '),
                    ),
                    SizedBox(
                       height: 25.0,
                    ),
                    
                   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          ElevatedButton.icon(
                          icon: Icon(Icons.check),
                          onPressed:(){
                            widget.onDisjoin(context);
                          }
                        , label:Text('Joined') ,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.group_add),
                          onPressed:(){
                            Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => InvitationPage(),
                          )
                          );
                          }
                        , label:Text('Invite') ,
                        ),
                       
                      ],
                    )
      ]:
      [
                 TextButton(
                      onPressed:(){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) =>  CommunityMembersPage(members: widget.communityData.members),
                          ),
                        );
                      },
                      child: Text(widget.communityData.memberCounter.toString() + ' members '),
                    ),
                    SizedBox(
                       height: 25.0,
                    ),
                    
                     ElevatedButton.icon(
                      onPressed: (){
                        setState((){
                        widget.isMember=true;
                        widget.onChanged(true);
                        ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('You are now a member of this community')));
                        }
                    );
                      },
                    label:Text('Join'),
                    icon: Icon(
                      Icons.group_add,
                    ),
                      
                       ),
                    
      ],
    );
  }
}
