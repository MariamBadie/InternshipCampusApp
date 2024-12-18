import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:campus_app/backend/Controller/highlightsController.dart';
import 'package:campus_app/backend/Controller/lostAndFoundController.dart';
import 'package:campus_app/backend/Controller/postController.dart';
import 'package:campus_app/backend/Controller/userController.dart';
import 'package:campus_app/backend/Model/Highlights.dart';
import 'package:campus_app/backend/Model/Post.dart';
import 'package:campus_app/backend/Model/User.dart';
import 'package:campus_app/screens/highlights_popups.dart';
import 'package:campus_app/utils/getCurrentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'friends_list_page.dart';
import 'post_details_page.dart';
import './points_guide.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String username = 'Anas Tamer';
  String bio = 'MET Major | Student at GUC';
  int numberOfPosts = 4;
  final int numberOfFriends = 120;
  final int karma = 350;
  List<Map<String, dynamic>> posts = [];

  List<Post> userPosts = [
    Post(
      id: '1',
      username: 'Anas Tamer',
      type: 'Text',
      content: 'Had a great day exploring Flutter!',
      upvotes: 10, // Replace the old reactions map with upvotes
      downvotes: 2, // Assume some downvotes for demonstration
      comments: [],
      isAnonymous: false,
      isConfession: false, // Specify if it's a confession or not
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      profilePictureUrl: 'assets/images/anas.jpg',
    ),
    Post(
      id: '2',
      username: 'Anas Tamer',
      type: 'Image',
      content: 'Check out this cool picture I took!',
      upvotes: 7, // Replace the old reactions map with upvotes
      downvotes: 1, // Assume some downvotes for demonstration
      comments: [],
      isAnonymous: false,
      isConfession: false, // Specify if it's a confession or not
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      profilePictureUrl: 'assets/images/anas.jpg',
    ),
    // Add more posts here...
  ];

  List<Highlights> userHighlights = [];
  late Future<String> name;
  User? user;

  @override
  void initState() {
    super.initState();
    _fetchUserHighlights();
    user = getCurrentUser(context);
    name = getUsernameByID(user!.id);
  }

  Future<void> _fetchUserHighlights() async {
    final highlights = await getHighlights(user!.id);
    setState(() {
      userHighlights = highlights;
    });
  }
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
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // Profile Header
            Padding(
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
                  Row(
                    children: [
                      IconButton.outlined(
                        onPressed: () => _createHighlights(context),
                        icon: const Icon(Icons.add, size: 50),
                      ),
                      Expanded(
                        child: _buildHighlightsRow(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // TabBar
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.grid_on)),
                Tab(icon: Icon(Icons.alternate_email_rounded )),
              ],
            ),
            // TabBarView
            Expanded(
              child: TabBarView(
                children: [
                  _buildUserPosts(context),
                  _buildPostsMentioningMe(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserPosts(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
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
    );
  }
Future<List<Map<String, dynamic>>> _fetchPostsMentioningMe() async {
    // Replace this with your method to find and fetch posts mentioning the user
    final postIds = await findPostsWithMention(await name);
    print(name);
    return await fetchPostsDetails(postIds);
  }

  Widget _buildPostsMentioningMe(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPostsMentioningMe(), // Implement this method to fetch posts
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final fetchedPosts = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: fetchedPosts.length,
            itemBuilder: (context, index) {
              final post = fetchedPosts[index];
              return Container(
                width: 50,
                height: 80,
                margin: const EdgeInsets.all(4.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(post['title'] ?? 'No Title'),
                        subtitle: Text(post['content'] ?? 'No Content'),
                        trailing: Text(post['type'] ?? 'No Type'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No posts mentioning you'));
        }
      },
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

  void _createHighlights(BuildContext context) async {
    // Use a TextEditingController to capture user input for the highlight name
    TextEditingController highlightNameController = TextEditingController();
    final ImagePicker picker = ImagePicker();

    // Pick an image using ImagePicker (accepting all image formats)
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

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
                  File(pickedImage
                      .path), // Use FileImage to show the picked image
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
                    Reference storageRef = storage
                        .ref()
                        .child('highlights/${highlightName}_${user!.id}.jpg');

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
                      userID: user!.id,
                    );
                    await createHighlights(
                        highlights); // Ensure createHighlights is async
                    Navigator.of(context)
                        .pop(); // Close the dialog after creation
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

  Widget _buildHighlightsRow() {
    return FutureBuilder<String>(
      future: getUsernameByID(user!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final username = snapshot.data!;
          return SizedBox(
            height: 81, // Adjust the height to fit your needs
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: userHighlights.length,
              itemBuilder: (context, index) {
                final highlight = userHighlights[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return HighlightspopupsDialog(
                          highlightID: highlight.id as String,
                          friendsOrProfile: 'profile',
                          username: username,
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: highlight.imageUrl != null
                              ? NetworkImage(highlight.imageUrl!)
                              : const AssetImage(
                                      'assets/images/default_highlight.jpg')
                                  as ImageProvider,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          highlight.highlightsname ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No highlights found'));
        }
      },
    );
  }

  void _deletePost(int index) {
    setState(() {
      userPosts.removeAt(index);
      numberOfPosts--;
    });
  }
}
