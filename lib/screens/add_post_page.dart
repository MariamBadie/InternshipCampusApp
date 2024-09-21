import 'dart:io';
import 'dart:typed_data';
import 'package:campus_app/backend/Controller/lostAndFoundController.dart';
import 'package:campus_app/backend/Controller/notescontroller.dart';
import 'package:campus_app/backend/Controller/postController.dart';
import 'package:campus_app/backend/Model/LostAndFound.dart';
import 'package:campus_app/backend/Model/Post.dart';
import 'package:campus_app/screens/favorites_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../backend/Model/Rating.dart';
import '../backend/Controller/ratingController.dart';

class AddPostPage extends StatefulWidget {
  final String postType;

  const AddPostPage({super.key, required this.postType});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final NotesController _notesController = NotesController();
  final TextEditingController _textController = TextEditingController();
  final PostController _postController = PostController();
  XFile? _imageFile; // Use XFile to store the selected image
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

  final RatingController ratingController = RatingController(FirebaseService());

  void _fetchEntities(String collectionName) async {
    List<String> entityNames =
        await ratingController.getAllEntityNamesFromCollection(collectionName);
    setState(() {
      _specificEntitiesList = entityNames; // Directly use the list of names
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile; // Store XFile instead of File
      });
    }
  }

  Future<String?> _uploadImage(XFile imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('Lost and Found posts/${DateTime.now().toString()}.jpg');

      if (kIsWeb) {
        // For web, convert XFile to Uint8List and use putData
        Uint8List imageBytes = await imageFile.readAsBytes();
        final uploadTask = storageRef.putData(imageBytes);
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        print('Image uploaded successfully! Download URL: $downloadUrl');
        return downloadUrl;
      } else {
        // For mobile/desktop platforms
        File file = File(imageFile.path); // Convert XFile to File
        final uploadTask = storageRef.putFile(file);
        final snapshot = await uploadTask.whenComplete(() {});
        final downloadUrl = await snapshot.ref.getDownloadURL();
        print('Image uploaded successfully! Download URL: $downloadUrl');
        return downloadUrl;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _submitPost() async {
    final postContent = _textController.text;

    if (postContent.isEmpty &&
        _imageFile == null &&
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
      if (postContent.isEmpty && _imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please enter text or select an image.')),
        );
        return;
      }
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      }

      print('Type: ${widget.postType}');
      print('Content: $postContent');
      print('Anonymous: $_isAnonymous');
      print('Lost or Found: $_lostOrFound');
      print('Category: $_category');

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
          isConfession: true,
          privacy: 'Public', // Set privacy based on your requirement
        );
        _postController.addPost(post);
        print("Post added");
      }

      if (widget.postType == "Lost & Found") {
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
      }
    }

    _textController.clear();
    setState(() {
      _imageFile = null;
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
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _category = newValue;
                        });
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              if (widget.postType == 'Rating/Review')
                Column(
                  children: [
                    DropdownButton<String>(
                      hint: const Text('Select Entity Type'),
                      value: _entityType,
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          value: 'professors',
                          child: Text('Professor'),
                        ),
                        DropdownMenuItem(
                          value: 'cafeterias',
                          child: Text('Cafeteria'),
                        ),
                        DropdownMenuItem(
                          value: 'courses',
                          child: Text('Course'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _entityType = newValue;
                          _fetchEntities(_entityType!);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<String>(
                      hint: const Text('Select Specific Entity'),
                      value: _specificEntity,
                      items: _specificEntitiesList
                          .map((entity) => DropdownMenuItem<String>(
                                value: entity,
                                child: Text(entity),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _specificEntity = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Rating'),
                    Slider(
                      value: _rating?.toDouble() ?? 0.0,
                      min: 0,
                      max: 5,
                      divisions: 5,
                      label: _rating?.toString(),
                      onChanged: (newRating) {
                        setState(() {
                          _rating = newRating.toInt();
                        });
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (_imageFile != null)
                    if (kIsWeb)
                      Image.network(
                        _imageFile!.path,
                        width: 100,
                        height: 100,
                      )
                    else
                      Image.file(
                        File(_imageFile!.path),
                        width: 100,
                        height: 100,
                      ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: _pickImage,
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isAnonymous,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isAnonymous = newValue!;
                      });
                    },
                  ),
                  const Text('Post anonymously'),
                ],
              ),
              ElevatedButton(
                onPressed: _submitPost,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
