import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  final String postType;

  AddPostPage({Key? key, required this.postType}) : super(key: key);

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController _textController = TextEditingController();
  XFile? _image;
  bool _isAnonymous = false;
  final ImagePicker _picker = ImagePicker();
  String? _lostOrFound;
  String? _category;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void _submitPost() {
    final postContent = _textController.text;
    // Handle submission logic here, e.g., save to database
    if (postContent.isEmpty && _image == null) {
      // Display error if both fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter text or select an image.')),
      );
      return;
    }

    // Example of how to handle the submission
    print('Type: ${widget.postType}');
    print('Content: $postContent');
    print('Anonymous: $_isAnonymous');
    print('Image path: ${_image?.path}');

    // Clear the fields after submission
    _textController.clear();
    setState(() {
      _image = null;
      _isAnonymous = false;
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
                    const SizedBox(
                      width: 16,
                    ),
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

                        if (newValue == 'lost') {
                          // Handle restore action
                        } else if (newValue == 'found') {
                          // Handle edit action
                        }
                      },
                    ),
                    const SizedBox(
                      width: 80,
                    ),
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

                        if (newValue == 'lost') {
                          // Handle restore action
                        } else if (newValue == 'found') {
                          // Handle edit action
                        }
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('Pick Image'),
                  ),
                  const SizedBox(width: 16),
                  if (_image != null)
                    Image.file(
                      File(_image!.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (widget.postType != "Lost & Found")
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
