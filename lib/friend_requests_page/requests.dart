import 'package:campus_app/models/friend_request.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/friend_requests_page/friend_requests_list.dart';
import 'package:google_fonts/google_fonts.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() {
    return _RequestsState();
  }
}

class _RequestsState extends State<Requests> {
  final List<FriendRequest> _avaliableRequests = [
    FriendRequest(
      name: 'Aya Mahmoud',
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    FriendRequest(
      name: 'Mayar Ahmed',
      requestDate: DateTime.now().subtract(const Duration(days: 5)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    FriendRequest(
      name: 'Yaseen Mostafa',
      requestDate: DateTime.now().subtract(const Duration(days: 10)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    FriendRequest(
      name: 'Jomana Ayman',
      requestDate: DateTime.now().subtract(const Duration(days: 20)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
  ];

  void _deleteRequest(int index) {
    setState(() {
      _avaliableRequests.removeAt(index);
    });
  }

  void _clearAllRequests() {
    setState(() {
      _avaliableRequests.clear();
    });
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 35, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                "Friend Requests",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${_avaliableRequests.length}',
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 213, 12, 12),
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _clearAllRequests,
              child: Text(
                'Clear All',
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 30, 53, 235),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: FriendRequestsList(
                requests: _avaliableRequests,
                onDelete: _deleteRequest,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
