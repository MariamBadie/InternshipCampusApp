import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 24, // Adjusted font size
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(25, 16, 25, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to GUC Pulse!",
              style: GoogleFonts.poppins(
                //color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 18, // Adjusted font size
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 18), // Adjusted spacing
            Text(
              "At GUC Pulse, we enhance campus life at GUC by offering a central hub for various services and information. Connect with peers, get academic support, and find important resources easily.",
              style: GoogleFonts.poppins(
                //color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 14, // Adjusted font size
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18), // Adjusted spacing
            Text(
              "GUC Pulse enhances your campus life with features like anonymous Confessions, academic support through Post Questions, and a Lost and Found section. You can also interact with comments, tag friends, and access resources with ease.",
              style: GoogleFonts.poppins(
                fontSize: 14, // Smaller font size for a compact look
                fontWeight: FontWeight.w500, // Lighter weight
              ),
            ),

            const SizedBox(height: 18), // Adjusted spacing
            Text(
              "Find campus resources easily with the Offices and Outlets feature. Get locations, directions, and distances to faculty, staff, and services. Access important phone numbers like the clinic or ambulance with a single click. Stay updated on campus News, Events, and Clubs with content curated by approved users.",
              style: GoogleFonts.poppins(
                fontSize: 14, // Smaller font size for simplicity
                fontWeight: FontWeight.w500, // Lighter weight
              ),
            )
          ],
        ),
      ),
    );
  }
}
