import 'dart:io';
import 'dart:typed_data';
import 'package:campus_app/backend/Controller/lostAndFoundController.dart';
import 'package:campus_app/backend/Controller/postController.dart';
import 'package:campus_app/backend/Model/LostAndFound.dart';
import 'package:campus_app/backend/Model/Post.dart';
import 'package:campus_app/screens/favorites_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../backend/Model/Rating.dart';
import '../backend/Controller/ratingController.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddPostPage extends StatefulWidget {
  final String postType;

  const AddPostPage({super.key, required this.postType});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _textController = TextEditingController();
  final PostController _postController = PostController();
  Uint8List? _image;
  bool _isAnonymous = false;
  final ImagePicker _picker = ImagePicker();
  String? _lostOrFound;
  String? _category;
  String? _entityType;
  String? _specificEntity;
  int? _rating;
  final String _userID = 'yq2Z9NaQdPz0djpnLynN';

  // List to store the specific entities retrieved from Firestore
  List<String> _specificEntitiesList = [];

  void _fetchEntities(String collectionName) async {
    List<String> entityNames =
        await ratingController.getAllEntityNamesFromCollection(collectionName);
    //print(entityNames);
    setState(() {
      _specificEntitiesList = entityNames; // Directly use the list of names
    });
  }

  final RatingController ratingController = RatingController(FirebaseService());

  Future<void> _pickImage() async {
    final Uint8List? image =
        await _picker.pickImage(source: ImageSource.gallery) as Uint8List;
    setState(() {
      _image = image;
    });
  }

  void _submitPost() async {
    final postContent = _textController.text;

    if (postContent.isEmpty &&
        _image == null &&
        widget.postType != 'Rating/Review') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text or select an image.')),
      );
      return;
    }

    if (widget.postType == 'Rating/Review') {
      if (_rating == null ||
          _specificEntity == null ||
          _textController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all fields.')),
        );
        return;
      }

      Rating rating = Rating(
        entityType: _entityType!,
        authorID: _userID,
        content: _textController.text,
        upCount: 0,
        downCount: 0,
        isAnonymous: _isAnonymous,
        entityID: _specificEntity!,
        rating: _rating!,
        createdAt: DateTime.now(),
      );

      await ratingController.addRating(
          rating); // Call the addRating method from the RatingController
    } else {
      if (postContent.isEmpty && _image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter text or select an image.')),
        );
        return;
      }

      print('Type: ${widget.postType}');
      print('Content: $postContent');
      print('Anonymous: $_isAnonymous');
      // print('Image path: ${_image?.path}');
      print('Lost or Found: ${_lostOrFound}');
      print('Category: ${_category}');

          if (widget.postType == "Confession") {
            Post post = Post(
                     id: _postController.testUserId,
                    username: 'Anas Tamer', // Replace with actual username
                    type: widget.postType,
                    content: postContent,
                    profilePictureUrl: _isAnonymous 
                        ? 'assets/images/anas.jpg' 
                        : 'assets/images/current_user.jpg',
                    isAnonymous: _isAnonymous,
                    timestamp: DateTime.now(),
                    upvotes: 2,
                    downvotes: 0,
                    isConfession:true,
                    privacy: 'Public', // Set privacy based on your requirement
                  );
                  _postController.addPost(post);
                  print("gugugu");
          }


      if (widget.postType == "Lost & Found") {
      String imageUrl =
          await uploadImageToStorage("lostAndFoundImage", _image as Uint8List);
        LostAndFound post = LostAndFound(
            authorID: _userID,
            isFound: false,
            content: _textController.text,
            category: _category.toString(),
            createdAt: DateTime.now(),
            comments: [],
            imageUrl: imageUrl,
            lostOrFound: _lostOrFound!);
            

        await saveLostAndFoundPost(post);
        // Navigator.pop(context);
        // return;
      }
    }

    _textController.clear();
    setState(() {
      _image = null;
      _isAnonymous = false;
      _rating = null;
      _entityType = null;
      _specificEntity = null;
      _category = null;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add ${widget.postType}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText:
                      'Enter your ${widget.postType.toLowerCase()} here...',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              if (widget.postType == 'Lost & Found')
                Row(
                  children: [
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      hint: const Text('Select Post type'),
                      value: _lostOrFound,
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          value: 'lost',
                          child: Text('Lost item'),
                        ),
                        DropdownMenuItem(
                          value: 'found',
                          child: Text('Found item'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _lostOrFound = newValue;
                        });
                      },
                    ),
                    const SizedBox(width: 80),
                    DropdownButton<String>(
                      hint: const Text('Select item category'),
                      value: _category,
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          value: 'electronics',
                          child: Text('Electronics'),
                        ),
                        DropdownMenuItem(
                          value: 'book',
                          child: Text('Books'),
                        ),
                        DropdownMenuItem(
                          value: 'clothing',
                          child: Text('Clothing'),
                        ),
                        DropdownMenuItem(
                          value: 'accessories',
                          child: Text('Accessories'),
                        ),
                        DropdownMenuItem(
                          value: 'keys',
                          child: Text('Keys'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _category = newValue;
                        });
                      },
                    ),
                  ],
                ),
              if (widget.postType == 'Rating/Review')
                Column(
                  children: [
                    DropdownButton<String>(
                      hint: const Text('Select Entity Type'),
                      value: _entityType,
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          value: 'professor',
                          child: Text('Professor'),
                        ),
                        DropdownMenuItem(
                          value: 'course',
                          child: Text('Course'),
                        ),
                        DropdownMenuItem(
                          value: 'outlet',
                          child: Text('Outlet'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _entityType = newValue;
                          // Fetch specific entities from the selected entity type
                          if (_entityType != null) {
                            _fetchEntities(_entityType!);
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<String>(
                      hint: const Text('Select Specific Entity'),
                      value: _specificEntity,
                      items: _specificEntitiesList.isEmpty
                          ? [] // If the list is empty, no items are shown
                          : _specificEntitiesList.map((entity) {
                              return DropdownMenuItem<String>(
                                value: entity,
                                child: Text(entity),
                              );
                            }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _specificEntity = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            _rating != null && _rating! > index
                                ? Icons.star
                                : Icons.star_border,
                          ),
                          color: Colors.amber,
                          onPressed: () {
                            setState(() {
                              _rating = index + 1;
                            });
                          },
                        );
                      }),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              if (widget.postType != 'Lost & Found')
                Row(
                  children: [
                    Checkbox(
                      value: _isAnonymous,
                      onChanged: (bool? value) {
                        setState(() {
                          _isAnonymous = value ?? false;
                        });
                      },
                    ),
                    const Text('Post Anonymously'),
                  ],
                ),
              const SizedBox(height: 16),
              if (widget.postType != 'Rating/Review')
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                    ),
                    const SizedBox(width: 16),
                    // if (_image != null)
                    // Image.file(
                    //   // File(_image!.path),
                    //   height: 100,
                    //   width: 100,
                    //   fit: BoxFit.cover,
                    // ),
                  ],
                ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _submitPost,
                  child: Text('Submit ${widget.postType}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
