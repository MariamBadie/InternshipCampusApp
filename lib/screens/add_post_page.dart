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
        SnackBar(content: Text('Please enter text or select an image.')),
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
                  hintText: 'Enter your ${widget.postType.toLowerCase()} here...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image'),
                  ),
                  SizedBox(width: 16),
                  if (_image != null)
                    Image.file(
                      File(_image!.path),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
              SizedBox(height: 16),
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
                  Text('Post Anonymously'),
                ],
              ),
              SizedBox(height: 16),
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
