import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:campus_app/backend/Controller/highlightsController.dart';
import 'package:campus_app/backend/Controller/lostAndFoundController.dart';
import 'package:campus_app/backend/Model/Highlights.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'friends_list_page.dart';
import '../models/post.dart';
import 'post_details_page.dart';
import './points_guide.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String username = 'Anas Tamer';
  final String bio = 'MET Major | Student at GUC';
  int numberOfPosts = 4;
  final int numberOfFriends = 120;
  final int karma = 350;

  List<Post> userPosts = [
    Post(
      id: '1',
      username: 'Anas Tamer',
      type: 'Text',
      content: 'Had a great day exploring Flutter!',
      reactions: {'like': 10, 'love': 5, 'haha': 2},
      comments: [],
      isAnonymous: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      profilePictureUrl: 'assets/images/anas.jpg',
      privacy: 'Public',
    ),
    Post(
      id: '2',
      username: 'Anas Tamer',
      type: 'Image',
      content: 'Check out this cool picture I took!',
      reactions: {'like': 15, 'love': 8, 'haha': 1},
      comments: [],
      isAnonymous: false,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      profilePictureUrl: 'assets/images/anas.jpg',
      privacy: 'Friends',
    ),
    // Add more posts here...
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildProfileStats(context),
              const SizedBox(height: 24),
              _buildEditProfileButton(context),
              const SizedBox(height: 24),
              IconButton.outlined(
                onPressed: ()=> _createHighlights(context)
                ,
                icon: Icon(Icons.add,
                    size: 40), // Adjust the size of the icon here
                iconSize: 50, // Adjust the size of the IconButton here
              ),
              const SizedBox(height: 24),
              _buildUserPosts(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: const AssetImage("assets/images/anas.jpg"),
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                bio,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatColumn(context, 'Posts', numberOfPosts),
        _buildStatColumn(context, 'Friends', numberOfFriends),
        _buildStatColumn(context, 'Karma', karma),
      ],
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, int count) {
    return InkWell(
      onTap: () {
        if (label == 'Friends') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendsListPage(profileName: username),
            ),
          );
        }
        if (label == 'Karma') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return KarmaDialog();
            },
          );
        }
      },
      child: Column(
        children: [
          Text(
            count.toString(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/editProfile'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: const Text('Edit Profile'),
      ),
    );
  }

  Widget _buildUserPosts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Posts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userPosts.length,
          itemBuilder: (context, index) {
            final post = userPosts[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(post.profilePictureUrl),
                ),
                title: Text(post.isAnonymous ? 'Anonymous' : post.username),
                subtitle: Text(
                  post.content.length > 50
                      ? '${post.content.substring(0, 50)}...'
                      : post.content,
                ),
                trailing: _buildMiniSettingsTab(context, index),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailsPage(
                      post: post,
                      onReact: (postId, reactionType) {
                        // Handle reaction
                      },
                      onComment: (postId, username, comment) {
                        // Handle comment
                      },
                      onReactToComment: (postId, commentIndex, reactionType) {
                        // Handle reaction to comment
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMiniSettingsTab(BuildContext context, int index) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        switch (value) {
          case 'Edit':
            _showEditDialog(context, index);
            break;
          case 'Delete':
            _showDeleteConfirmation(context, index);
            break;
          case 'Share':
            // Implement your share logic here
            break;
          case 'Copy Link':
            // Implement your copy link logic here
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return {'Edit', 'Delete', 'Share', 'Copy Link'}.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    final post = userPosts[index];
    TextEditingController textController =
        TextEditingController(text: post.content);
    String selectedPrivacy = post.privacy;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Edit Post',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: textController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Edit your post',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Privacy:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildPrivacyOption(setDialogState, selectedPrivacy,
                        'Public', Icons.public, 'Everyone can see', (option) {
                      setDialogState(() => selectedPrivacy = option);
                    }),
                    _buildPrivacyOption(
                        setDialogState,
                        selectedPrivacy,
                        'Friends',
                        Icons.people,
                        'Only friends can see', (option) {
                      setDialogState(() => selectedPrivacy = option);
                    }),
                    _buildPrivacyOption(setDialogState, selectedPrivacy,
                        'Only Me', Icons.lock, 'Only you can see', (option) {
                      setDialogState(() => selectedPrivacy = option);
                    }),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      post.content = textController.text;
                      post.privacy = selectedPrivacy;
                    });
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPrivacyOption(
      StateSetter setState,
      String selectedPrivacy,
      String option,
      IconData icon,
      String description,
      Function(String) onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => onTap(option),
        child: Row(
          children: [
            Icon(icon,
                color: selectedPrivacy == option
                    ? Theme.of(context).primaryColor
                    : Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            if (selectedPrivacy == option)
              Icon(Icons.check, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deletePost(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
 String userID='upeubEqcmzSU9aThExaO';
void _createHighlights(BuildContext context) async {
  // Use a TextEditingController to capture user input for the highlight name
  TextEditingController highlightNameController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  // Pick an image using ImagePicker (accepting all image formats)
  final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

  if (pickedImage == null) {
    // Handle the case where no image is selected
    return;
  }

  File file = File(pickedImage.path);

  // Show the dialog to create a highlight
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Title of the Highlights'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(
                File(pickedImage.path), // Use FileImage to show the picked image
              ),
            ),
            const SizedBox(height: 20),
            const Text('How do you want to name this new Highlight?'),
            const SizedBox(height: 14),
            TextField(
              controller: highlightNameController,
              decoration: const InputDecoration(
                labelText: 'Enter highlight name',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: const Text('Create'),
              onPressed: () async {
                String highlightName = highlightNameController.text;

                if (highlightName.isNotEmpty) {
                  // Create a reference to the Firebase Storage with the highlight name and userID
                  FirebaseStorage storage = FirebaseStorage.instance;
                  Reference storageRef = storage.ref().child(
                    'highlights/${highlightName}_${userID}.jpg'
                  );

                  String downloadUrl;

                  try {
                    // Upload the file to Firebase Storage
                    UploadTask uploadTask = storageRef.putFile(file);
                    TaskSnapshot snapshot = await uploadTask;

                    // Get the download URL
                    downloadUrl = await snapshot.ref.getDownloadURL();
                  } catch (e) {
                    // Show an error message and exit if upload fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to upload image: $e')),
                    );
                    return;
                  }

                  // Create a Highlights object and call createHighlights function
                  Highlights highlights = Highlights(
                    imageUrl: downloadUrl,
                    highlightsname: highlightName,
                    userID: userID,
                  );
                  await createHighlights(highlights); // Ensure createHighlights is async
                  Navigator.of(context).pop(); // Close the dialog after creation
                } else {
                  // Handle error (e.g., show a message to fill in the highlight name)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a highlight name.'),
                    ),
                  );
                }
              },
            ),
          )
        ],
      );
    },
  );
}

// Define your Highlights class and createHighlights function according to your app's needs.

  void _deletePost(int index) {
    setState(() {
      userPosts.removeAt(index);
      numberOfPosts--;
    });
  }
}
