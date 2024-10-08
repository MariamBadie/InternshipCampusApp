import 'package:campus_app/backend/Controller/feedbackController.dart';
import 'package:campus_app/backend/Model/FeedbackAndSuggestions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final String _userID = 'yq2Z9NaQdPz0djpnLynN';

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Warning!'),
            content: const Text(
                'Feedback cannot be empty. Please enter your feedback.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Thank you!'),
            content: const Text('Your feedback has been recorded.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      FeedbackAndSuggestions feedback = FeedbackAndSuggestions(content: _feedbackController.text);
      await addFeedback(feedback, _userID);
      _feedbackController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context)
            .unfocus(); // Close the keyboard when tapping outside
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Feedback and Suggestions",
            style: GoogleFonts.roboto(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "We value your input! Share your thoughts to help us make the application even better",
                  style: GoogleFonts.montserrat(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _feedbackController,
                    decoration: InputDecoration(
                      labelText: 'Tell us your feedback and suggestions',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 215, 215, 216)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    maxLines: 10,
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 33,
                      ),
                      backgroundColor: const Color.fromARGB(255, 30, 53, 235),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
