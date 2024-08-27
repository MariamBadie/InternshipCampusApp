import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/User.dart';

class InvitationCard extends StatelessWidget {
  User user;
  bool isInvited=false;
  
  InvitationCard({super.key,required  this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
                elevation:2.0,
                child: ListTile(
                  contentPadding: EdgeInsets.all(15.0),
                  trailing: InvitationCardButton(isInvited:isInvited),
                  title:Text(
                    user.name,
                    style: TextStyle(
                     fontWeight: FontWeight.w600,
                     letterSpacing: 0.5,
                    ),
                  ),
                  subtitle: Text('ay haga'),
                   leading:CircleAvatar(
                      backgroundImage:AssetImage(user.profilPictureUrl) ,
                    ),
                ),
             
            );
  }
}


class InvitationCardButton extends StatefulWidget {
  bool isInvited;
 InvitationCardButton({required this.isInvited});

  @override
  State<InvitationCardButton> createState() => InvitationCardButtonState();
}

class InvitationCardButtonState extends State<InvitationCardButton> {
  late String buttonText;
  late Color buttonColor;
  late Icon buttonIcon;
  
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     if(widget.isInvited){
                          widget.isInvited=true;
                          buttonText='Undo';
                          buttonColor=Color.fromARGB(255, 208, 202, 202);
                          buttonIcon=Icon(Icons.done); 
                        }
                        else{
                          widget.isInvited=false;
                          buttonText='Invite';
                          buttonColor=Color.fromARGB(255, 190, 174, 219);
                          buttonIcon=Icon(Icons.add);
                         
                         
                        }
                      

  }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
                    icon:buttonIcon,
                    style:ElevatedButton.styleFrom(
                      backgroundColor:buttonColor, 
                    ),
                    onPressed:(){
                      setState(() {
                        if(widget.isInvited){
                          widget.isInvited=false;
                          buttonText='Invite';
                          buttonColor=Color.fromARGB(255, 190, 174, 219);
                          buttonIcon=Icon(Icons.add);
                          ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Invitation has been canceled')));
                          
                        }
                        else{
                          widget.isInvited=true;
                          buttonText='Undo';
                          buttonColor=Color.fromARGB(255, 208, 202, 202);
                          buttonIcon=Icon(Icons.done);
                          ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text(' The invitation has been sent')));
                        }
                      });
                    },
                    label: Text(buttonText));
    
    
  }
}