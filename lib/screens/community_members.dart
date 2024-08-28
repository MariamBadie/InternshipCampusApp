import 'package:flutter/material.dart';
import '../models/User.dart';
import '../widgets/community/search_bar.dart' as searchBar;

class CommunityMembersPage extends StatefulWidget {
 final List<User> members;
//[
//       User(name: 'Hussien Haitham',profilPictureUrl:'assets/images/hussien.jpg'),
//        User( name: 'Anas',profilPictureUrl:'assets/images/anas.jpg'),
//        User(name: 'Mohanad', profilPictureUrl:'assets/images/mohanad.jpg'),
//        User(name: 'Ahmed Hany', profilPictureUrl:'assets/images/ahmed.jpg'),
//        ];
 const CommunityMembersPage({super.key,required this.members});

  @override
  State<CommunityMembersPage> createState() => _CommunityMembersPageState();
}

class _CommunityMembersPageState extends State<CommunityMembersPage> {
  List<User>searchResult=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchResult=widget.members;
  }

  void getResult(String searchValue){
    List<User>result= [];
    if(searchValue.isEmpty){
      result=widget.members;
    }
    else{
      result= widget.members.where((member)=>member.name.toLowerCase().
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
        
        title:
            const Row(
              children: [
                Icon(Icons.people),
                SizedBox(width:8.0),
                Text(
                  'Members',
                  style:TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  )
                  ),
              ],
            )
           ,
        actions:[
          IconButton(onPressed:(){},
           icon:const Icon(Icons.group_add_sharp))
        ]
       ),
       body:
          Column(
            children: [
             searchBar.SearchBar(list: widget.members, label: 'Search Members', getResult:getResult),
             CommunityMembers(members: searchResult),
            ],
          )

       
       
    );
  }}
  class CommunityMembers extends StatelessWidget {
    List<User>members;
  CommunityMembers({super.key,required this.members});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
                child: ListView.builder(
                  itemCount: members.length,
                  itemBuilder:(context,index){
                  return Card(
                      elevation:2.0,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15.0),
                        onTap: (){
                        },
                
                        title:Text(
                          members[index].name,
                          style: const TextStyle(
                           fontWeight: FontWeight.w600,
                           letterSpacing: 0.5,
                          ),
                        ),
                        //subtitle: Text('ay haga'),
                         leading:CircleAvatar(
                            backgroundImage:AssetImage(members[index].profilPictureUrl) ,
                          ),
                      ),
                   
                  );
                  }
                   ),
              );
  }
}

// class CommunityMembers extends StatefulWidget {
//   List<User> members;
//   CommunityMembers({super.key,required this.members});

//   @override
//   State<CommunityMembers> createState() => _CommunityMembersState();
// }

// class _CommunityMembersState extends State<CommunityMembers> {
//   List<User>searchResult=[];

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     searchResult=widget.members;
//   }

//   void getResult(String searchValue){
//     List<User>result= [];
//     if(searchValue.isEmpty){
//       result=widget.members;
//     }
//     else{
//       result= widget.members.where((member)=>member.name.toLowerCase().
//               contains(searchValue.toLowerCase())).toList();
//     }
//     setState(() {
//       searchResult=result;
//     });
//   }

//   @override

//   Widget build(BuildContext context) {
//     return  Expanded(
//                 child: ListView.builder(
//                   itemCount: widget.members.length,
//                   itemBuilder:(context,index){
//                   return Card(
//                       elevation:2.0,
//                       child: ListTile(
//                         contentPadding: EdgeInsets.all(15.0),
//                         onTap: (){
//                         },
                
//                         title:Text(
//                           widget.members[index].name,
//                           style: TextStyle(
//                            fontWeight: FontWeight.w600,
//                            letterSpacing: 0.5,
//                           ),
//                         ),
//                         //subtitle: Text('ay haga'),
//                          leading:CircleAvatar(
//                             backgroundImage:AssetImage(widget.members[index].profilPictureUrl) ,
//                           ),
//                       ),
                   
//                   );
//                   }
//                    ),
//               );
//   }
// }