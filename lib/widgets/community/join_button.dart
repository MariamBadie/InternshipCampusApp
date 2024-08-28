import 'package:flutter/material.dart';

class JoinButton extends StatefulWidget {
  bool isJoined;
  JoinButton({super.key,required this.isJoined});

  @override
  State<JoinButton> createState() => _JoinButtonState();
}

class _JoinButtonState extends State<JoinButton> {
  // late String buttonText;
  // late Color buttonColor;
  // late Icon buttonIcon;
 @override
  // void initState() {
  //   // TODO: implement initState
  //   if(widget.isJoined){
  //         buttonText='Joined';
  //         buttonColor=Color.fromARGB(255, 208, 202, 202);
  //         buttonIcon=Icon(Icons.done);
  //         //Add the request to the DB
            
  //     }
  //     else{
  //          buttonText='Join';
  //          buttonColor=Color.fromARGB(255, 190, 174, 219);
  //          buttonIcon=Icon(Icons.group_add);
  //         //remove the request from the DB  
         
  //     }
    
  // }
  void showLeaveCommunityDialog(BuildContext context){
  showDialog(
    context: context,
    builder:(context){
      return AlertDialog(
        title:const Center(child: Text('Leave Community')),
        titleTextStyle: const TextStyle(
          fontSize:20.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
        insetPadding: const EdgeInsets.all(20.0),
        titlePadding: const EdgeInsets.all(15.0),
        content: 
            const Text('Are you sure that you want leave this community ?'),
        contentPadding: const EdgeInsets.all(30.0),
        contentTextStyle: const TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          ElevatedButton(
            onPressed:(){
              Navigator.pop(context);
            },
             child:const Text('Cancel',
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
             child:const Text('Confirm',
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
void _leaveCommunity(){
  setState((){
    widget.isJoined=false;
  });
  ScaffoldMessenger.of(context).showSnackBar(
   const SnackBar(content: Text('You are no longer member of this community')));
}
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton.icon(
      onPressed: (){
        onPressedJoin();
      },
       label:Text(widget.isJoined?'Joined':'Join',) ,
       icon:widget.isJoined?const Icon(Icons.done):const Icon(Icons.group_add),
       style:ElevatedButton.styleFrom(
                      backgroundColor:widget.isJoined?const Color.fromARGB(255, 208, 202, 202):const Color.fromARGB(255, 190, 174, 219), 
                    ),
       );
  }

  void onPressedJoin() {
    setState((){
      if(widget.isJoined){
          showLeaveCommunityDialog(context);
          //remove the request from the DB    
      }
      else{
          setState((){
          widget.isJoined=true;
          }
          );
          ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You are now a member of this community')));
          //Add the request to the DB
      }
    });
    
  }
}