import 'package:campus_app/models/blocked_account_object.dart';
import 'package:campus_app/widgets/blocked_accounts/blocked_accounts_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../backend/Controller/userController.dart';


class BlockedAccounts extends StatefulWidget {
  const BlockedAccounts({super.key});

  @override
  State<BlockedAccounts> createState() {
    return _BlockedAccountsState();
  }
}

class _BlockedAccountsState extends State<BlockedAccounts> {
  List<BlockedAccountObject> _availableBlockedAccounts = [];

  @override
  void initState() {
    super.initState();
    _fetchBlockedAccounts();
  }

  Future<void> _fetchBlockedAccounts() async {
    String userID = 'yq2Z9NaQdPz0djpnLynN'; // Replace with actual user ID
    List<Map<String, dynamic>> blockedAccountsData = await viewBlockedAccounts(userID);

    setState(() {
      _availableBlockedAccounts = blockedAccountsData.map((data) {
        return BlockedAccountObject(
          blockedAccountID: data['id'],
          blockedAccountName: data['data']['name'],
          blockedAccountProfilePic: Image.asset('assets/images/profile-pic.png', width: 200),
        );
      }).toList();
    });
  }

void _unblockBlockedAccount(int index) async {
  String userID = 'yq2Z9NaQdPz0djpnLynN'; // Replace with actual user ID
  String blockedUserID = _availableBlockedAccounts[index].blockedAccountID; // Use the ID

  await removeFromBlockedAccounts(userID, blockedUserID);

  setState(() {
    _availableBlockedAccounts.removeAt(index);
  });
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blocked Accounts",
          style: GoogleFonts.roboto(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _availableBlockedAccounts.isEmpty
          ? Center(child: Text('No blocked accounts found'))
          : BlockedAccountsList(
              accounts: _availableBlockedAccounts,
              onUnblock: _unblockBlockedAccount,
            ),
    );
  }
}