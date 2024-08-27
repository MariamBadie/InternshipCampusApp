import 'dart:io';

import 'package:campus_app/models/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../models/Community.dart';
import '../screens/community_page.dart';


class NewCommunity extends StatefulWidget {
  const NewCommunity({super.key});

  @override
  State<NewCommunity> createState() => NewCommunityState();
}

class NewCommunityState extends State<NewCommunity> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _goal = TextEditingController();
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  Future<void> chooseCoverPhoto()async{
   final XFile? choosenImage =await _picker.pickImage(source: ImageSource.gallery);
   if(choosenImage!=null){
    setState((){
      _profileImage=File(choosenImage.path);
      });
   }

}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        leading :IconButton(
          onPressed: (){
            _discardChanges(context);
          
          },
          icon:Icon(Icons.cancel_rounded),
        ),
        title:Text('Create new community'),
        ),
        body:Column(
              children: [ 
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: _profileImage != null 
                      ? DecorationImage(
                      image: FileImage(_profileImage!), 
                      fit: BoxFit.cover,
                      )
                        : null,

                  ),
                  child:Center(
                    child: TextButton.icon(
                      onPressed: (){
                        chooseCoverPhoto();
                      },
                       label:Text('Tap here to choose a cover photo',
                       style:TextStyle(
                        color: Colors.black,
                       )),
                       icon:Icon(
                        Icons.add_a_photo,
                        color: Colors.black,
                       )
                      ),
                  )
                )
                    ,
                  Padding(
                    padding: EdgeInsets.all(50.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                              
                      TextFormField(
                        controller: _name,
                        
                         decoration: InputDecoration(
                          label:Text('Community Name',
                           style:TextStyle(
                            fontWeight: FontWeight.bold
                          )),
                          hintText: 'Community Name',
                          border:OutlineInputBorder(
                            borderSide: BorderSide(
                              color:Colors.black,
                              width:2.0
                            )
                          ), 
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:Colors.blue,
                              width:2.0
                            ),
                            
                          )
                        ),
                      style:TextStyle(
                           letterSpacing: 1.0,
                           fontSize: 17.0,
                           fontWeight: FontWeight.w400,
                      ),           
                      ),
                      SizedBox(
                        height:40.0
                      ),
                      
                       TextFormField(
                        maxLines: 2,
                        controller: _goal,
                        decoration: InputDecoration(
                          hintText: 'Community goal',
                          label:Text('Community goal',
                          style:TextStyle(
                            fontWeight: FontWeight.bold
                          )
                          ),
                          helperText: 'Enter the reason of creating this community',
                          border:OutlineInputBorder(
                            borderSide: BorderSide(
                              color:Colors.black,
                              width:2.0
                            )
                          ), 
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color:Colors.blue,
                              width:2.0
                            ),
                            
                          )
                        ),
                      style:TextStyle(
                           letterSpacing: 1.0,
                           fontSize: 17.0,
                           fontWeight: FontWeight.w500,
                      ),           
                      ),
                      SizedBox(
                        height:40.0
                      ),
                      Center(
                        child: ElevatedButton(
                         style:ButtonStyle(
                           
                         ),
                          onPressed: (){
                            _submit(context);
                          },
                          child :Text(
                            'Create',
                           style: TextStyle(
                            fontWeight:FontWeight.w600 
                           ),
                          )
                        ),
                      )
                        ] 
                      ,),
                    ),
                  
                  ]
                    
                  )
    );
  }
  void _discardChanges(BuildContext context){
    if(_name.text.isNotEmpty|| _goal.text.isNotEmpty||_profileImage != null){
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
              _name.clear();
               _goal.clear();
               _profileImage = null;

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
  else{
  Navigator.pop(context);
  }
  }
  void _submit(BuildContext context){
    final getName = _name.text;
    final getGoal = _goal.text;
    if(getName.isEmpty){
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the Community Name field')),
        
      );
      return;
    }
    if(getGoal.isEmpty){
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the Community goal Field')),
      
      );
      return;
    }
    // if(_profileImage == null){
    //    ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please choose a profile image')),
    //   );
    //   return;
    // }
     _name.clear();
     _goal.clear();
    _profileImage = null;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> CommunityPage(isMember:true, 
    communityData: Community(goal: getGoal, name: getName, pictureUrl:'assets/images/community2Picture.webp', members: [
   User(name:'User1', profilPictureUrl: 'assets/images/profile-pic.png')
    ], posts: [], memberCounter: 1),)));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Community created successfully!')),
    );

  }
}
