import 'package:flutter/material.dart';
import 'invite_new_members.dart';

void main() {
  runApp(const Base());
}
class Base extends StatelessWidget {
  const Base({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
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
        title: const Text('Members'),

        actions: [
          IconButton(
          
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const InvitationPage()));

        },
         icon:const Icon(Icons.group_add)
        )
          
        ],
      ),
    );
  }
}

