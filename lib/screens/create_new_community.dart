import 'dart:io';
import 'package:campus_app/models/User.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/Community.dart';
import '../screens/community_page.dart';
import 'package:uuid/uuid.dart';  // Add this import for generating unique IDs

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
  
  Future<void> chooseCoverPhoto() async {
    final XFile? choosenImage = await _picker.pickImage(source: ImageSource.gallery);
    if (choosenImage != null) {
      setState(() {
        _profileImage = File(choosenImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _discardChanges(context);
          },
          icon: const Icon(Icons.cancel_rounded),
        ),
        title: const Text('Create new community'),
      ),
      body: Column(
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
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  chooseCoverPhoto();
                },
                label: const Text(
                  'Tap here to choose a cover photo',
                  style: TextStyle(color: Colors.black),
                ),
                icon: const Icon(
                  Icons.add_a_photo,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    label: Text('Community Name',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    hintText: 'Community Name',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  style: const TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40.0),
                TextFormField(
                  maxLines: 2,
                  controller: _goal,
                  decoration: const InputDecoration(
                    hintText: 'Community goal',
                    label: Text('Community goal',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    helperText: 'Enter the reason of creating this community',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                  style: const TextStyle(
                    letterSpacing: 1.0,
                    fontSize: 17.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 40.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _submit(context);
                    },
                    child: const Text(
                      'Create',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _discardChanges(BuildContext context) {
    if (_name.text.isNotEmpty || _goal.text.isNotEmpty || _profileImage != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Discard changes')),
            titleTextStyle: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
            insetPadding: const EdgeInsets.all(20.0),
            titlePadding: const EdgeInsets.all(15.0),
            content: const Text('Do you want to discard these changes?'),
            contentPadding: const EdgeInsets.all(30.0),
            contentTextStyle: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _name.clear();
                  _goal.clear();
                  _profileImage = null;
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _submit(BuildContext context) {
    final getName = _name.text;
    final getGoal = _goal.text;
    final uuid = Uuid().v4(); // Generate a unique ID
    final DateTime createdAt = DateTime.now(); // Capture the current time

    if (getName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill the Community Name field')),
      );
      return;
    }

    if (getGoal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the Community goal Field')),
      );
      return;
    }

    _name.clear();
    _goal.clear();
    _profileImage = null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityPage(
          isMember: true,
          communityData: Community(
            id: uuid,
            name: getName,
            goal: getGoal,
            pictureUrl: 'assets/images/community2Picture.webp',
            members: [
              User(name: 'User1', profilPictureUrl: 'assets/images/profile-pic.png'),
            ],
            posts: [],
            memberCounter: 1,
            createdAt: createdAt,
          ),
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Community created successfully!')),
    );
  }
}
