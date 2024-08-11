import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyActivityPage extends StatefulWidget {
  const MyActivityPage({super.key});

  @override
  State<MyActivityPage> createState() => _MyActivityPageState();
}

class _MyActivityPageState extends State<MyActivityPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title:const Text("My Activities",style: TextStyle(fontWeight:FontWeight.bold ),),
      centerTitle: true,
      actions:[IconButton(onPressed: () {}, icon: const Icon(Icons.refresh))] ,
      ),
    );
  }
}