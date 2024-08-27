import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/User.dart';
import '../widgets/community/invitation_card.dart';
import '../widgets/community/search_bar.dart' as search_bar;

class InvitationPage extends StatefulWidget {

  InvitationPage({super.key});

  @override
  State<InvitationPage> createState() => _InvitationPageState();
}

class _InvitationPageState extends State<InvitationPage> {
  final List<User> users=[
    User(name: 'User1', profilPictureUrl: 'assets/images/profile-pic.png'),
    User(name: 'User2', profilPictureUrl: 'assets/images/profile-pic.png'),
    User(name: 'User3', profilPictureUrl: 'assets/images/profile-pic.png'),
    User(name: 'User4', profilPictureUrl: 'assets/images/profile-pic.png'),
  ];

  List<User>searchResult=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchResult=users;
  }

  void getResult(String searchValue){
    List<User>result= [];
    if(searchValue.isEmpty){
      result=users;
    }
    else{
      result= users.where((user)=>user.name.toLowerCase().
              contains(searchValue.toLowerCase())).toList();
    }
    setState(() {
      searchResult=result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title:Row(
          children: [
            Icon(Icons.group_add),
            SizedBox(
              width:8.0
            ),
            Text(
              'Invite',
              style:TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,

              )
              )
          ],) ,
        
       ),
       body:
          Column(
            children:[ 
              search_bar.SearchBar(list:users,label:'Search', getResult: getResult),
              InviteNewMemberslist(users:searchResult ,)
          ])  
    ) ;
  }
}
class InviteNewMemberslist extends StatelessWidget {
  List <User>users;
  InviteNewMemberslist({super.key,required this.users});

  @override
  Widget build(BuildContext context) {
    return Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder:(context,index){
                return InvitationCard(user:users[index]);
                }
                 ),
            );
  }
}