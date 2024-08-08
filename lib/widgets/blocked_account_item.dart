import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_app/models/blocked_account_object.dart';

class BlockedAccountItem extends StatelessWidget {
  const BlockedAccountItem(this.blockedAccount, this.onUnblock, {super.key});

  final BlockedAccountObject blockedAccount;
  final VoidCallback onUnblock;

  @override
  Widget build(context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: blockedAccount.blockedAccountProfilePic.image,
              radius: 37,
            ),
            const SizedBox(width: 13), // Space between the profile picture and the name
            Expanded(
              child: Text(
                blockedAccount.blockedAccountName,
                style: GoogleFonts.montserrat(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onUnblock,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
                backgroundColor: const Color.fromARGB(255, 161, 161, 161),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              child: Text(
                'UNBLOCK',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
