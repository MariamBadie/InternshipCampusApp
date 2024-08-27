import 'dart:ui';
import 'package:campus_app/screens/about_us_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../models/Community.dart';
import 'main_screen.dart' as utils;
import 'invite_new_members.dart';

void main() {
  runApp(Base());
}
class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:CommunityMemberPage()
    );
  }
}
class CommunityMemberPage extends StatefulWidget {
 // final Community communityData;
  const CommunityMemberPage({super.key});

  @override
  State<CommunityMemberPage> createState() => CommunityMemberPageState();
}

class CommunityMemberPageState extends State<CommunityMemberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),

        actions: [
          IconButton(
          
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>InvitationPage()));

        },
         icon:Icon(Icons.group_add)
        )
          
        ],
      ),
    );
  }
}

