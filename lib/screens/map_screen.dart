import 'package:flutter/material.dart';

class CampusMapPage extends StatelessWidget {
  const CampusMapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Map'),
      ),
      body: Center(
        child: const Text('Campus Map will be displayed here.'),
      ),
    );
  }
}
