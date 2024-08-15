import 'package:campus_app/models/blocked_account_object.dart';
import 'package:campus_app/widgets/blocked_accounts_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlockedAccounts extends StatefulWidget {
  const BlockedAccounts({super.key});

  @override
  State<BlockedAccounts> createState() {
    return _BlockedAccountsState();
  }
}

class _BlockedAccountsState extends State<BlockedAccounts> {
  final List<BlockedAccountObject> _avaliableBlockedAccounts = [
    BlockedAccountObject(
      blockedAccountName: 'Yara Sherif',
      blockedAccountProfilePic:
          Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    BlockedAccountObject(
      blockedAccountName: 'Sara Ayman',
      blockedAccountProfilePic:
          Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    BlockedAccountObject(
      blockedAccountName: 'Mahmoud Aly',
      blockedAccountProfilePic:
          Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    BlockedAccountObject(
      blockedAccountName: 'Shorouk Adel',
      blockedAccountProfilePic:
          Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    BlockedAccountObject(
      blockedAccountName: 'Wael Elserafy',
      blockedAccountProfilePic:
          Image.asset('assets/images/profile-pic.png', width: 200),
    ),
  ];

  void _unblockBlockedAccount(int index) {
    setState(() {
      _avaliableBlockedAccounts.removeAt(index);
    });
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                "Blocked Accounts",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${_avaliableBlockedAccounts.length}',
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 213, 12, 12),
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlockedAccountsList(
                accounts: _avaliableBlockedAccounts,
                onUnblock: _unblockBlockedAccount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
