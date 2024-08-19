import 'package:campus_app/models/blocked_account_object.dart';
import 'package:campus_app/widgets/blocked_accounts/blocked_accounts_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBlockedAccounts();
  }

  Future<void> _fetchBlockedAccounts() async {
    String userID = 'yq2Z9NaQdPz0djpnLynN'; // Replace with actual user ID

    try {
      List<Map<String, dynamic>> blockedAccountsData =
          await viewBlockedAccounts(userID);

      setState(() {
        _availableBlockedAccounts = blockedAccountsData.map((data) {
          return BlockedAccountObject(
            blockedAccountID: data['id'],
            blockedAccountName: data['data']['name'],
            blockedAccountProfilePic:
                Image.asset('assets/images/profile-pic.png', width: 200),
          );
        }).toList();
        _isLoading = false; // Stop loading once data is fetched
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Stop loading even if there is an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load blocked accounts: $e')),
      );
    }
  }

  void _unblockBlockedAccount(int index) async {
    String userID = 'yq2Z9NaQdPz0djpnLynN'; // Replace with actual user ID
    String blockedUserID =
        _availableBlockedAccounts[index].blockedAccountID; // Use the ID

    await removeFromBlockedAccounts(userID, blockedUserID);

    setState(() {
      _availableBlockedAccounts.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Blocked Accounts",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '${_availableBlockedAccounts.length}',
              style: GoogleFonts.roboto(
                color: const Color.fromARGB(255, 213, 12, 12),
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _availableBlockedAccounts.isEmpty
              ? const Center(
                  child: Text(
                    'No Blocked Accounts Found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              : BlockedAccountsList(
                  accounts: _availableBlockedAccounts,
                  onUnblock: _unblockBlockedAccount,
                ),
    );
  }
}
