import 'package:campus_app/widgets/notes/note.dart';

class NoteService {
  final List<Note> _notes = [
    Note(
      title: "CSEN 401 - Introduction to Software Engineering",
      number: "T5",
      content:
          "Tutorial on creating UML diagrams for a simple e-commerce system.",
      attachmentPaths: [
        "assets/tutorials/csen401_uml_diagrams.pdf",
      ],
      comments: [
        Comment(
          text: "The class diagram example really helped clarify things!",
          authorName: "Ahmed Salah",
          isOwnComment: false,
        ),
        Comment(
          text: "Could we get more practice on sequence diagrams next time?",
          authorName: "Mona Ali",
          isOwnComment: false,
        ),
      ],
    ),
    Note(
      title: "CSEN 402 - Data Structures and Algorithms",
      number: "T3",
      content: "Hands-on session implementing a Red-Black Tree in Python.",
      attachmentPaths: [
        "assets/tutorials/csen402_red_black_tree_implementation.py",
        "assets/diagrams/red_black_tree_rotations.png",
      ],
      comments: [
        Comment(
          text:
              "The visualization of rotations really helped me understand the balancing process!",
          authorName: "Yasser Hassan",
          isOwnComment: false,
        ),
        Comment(
          text:
              "I'm still struggling with the delete operation. Can we review it next time?",
          authorName: "Laila Mahmoud",
          isOwnComment: true,
        ),
      ],
    ),
    Note(
      title: "CSEN 403 - Database Systems",
      number: "T8",
      content:
          "Practical session on setting up and querying a MongoDB database.",
      attachmentPaths: [
        "assets/tutorials/csen403_mongodb_basics.pdf",
        "assets/code_samples/mongodb_queries.js",
      ],
      comments: [
        Comment(
          text:
              "The aggregation pipeline examples were really helpful. Thanks!",
          authorName: "Omar Sherif",
          isOwnComment: false,
        ),
      ],
    ),
    Note(
      title: "CSEN 404 - Computer Networks",
      number: "T2",
      content: "Wireshark lab: Analyzing TCP and UDP packets in real-time.",
      attachmentPaths: [
        "assets/tutorials/csen404_wireshark_lab.pdf",
        "assets/sample_data/network_capture.pcap",
      ],
      comments: [
        Comment(
          text: "Seeing the actual packets made the concepts so much clearer!",
          authorName: "Nour Hamed",
          isOwnComment: true,
        ),
        Comment(
          text: "Could we have a session on network security protocols next?",
          authorName: "Karim Fouad",
          isOwnComment: false,
        ),
      ],
    ),
    Note(
      title: "CSEN 405 - Artificial Intelligence",
      number: "T6",
      content:
          "Tutorial on implementing a simple neural network using TensorFlow.",
      attachmentPaths: [
        "assets/tutorials/csen405_tensorflow_basics.ipynb",
        "assets/datasets/mnist_sample.csv",
      ],
      comments: [
        Comment(
          text: "The step-by-step TensorFlow implementation was super helpful!",
          authorName: "Amira Samy",
          isOwnComment: false,
        ),
        Comment(
          text: "I'm excited to try this on my own dataset. Great tutorial!",
          authorName: "Tamer Hosny",
          isOwnComment: true,
        ),
        Comment(
          text: "Could we cover CNN architectures in the next tutorial?",
          authorName: "Dina Alaa",
          isOwnComment: false,
        ),
      ],
    ),
  ];

  List<Note> get notes => _notes;

  List<Note> filterNotes(String query) {
    return _notes.where((note) {
      final lowerCaseNumber = note.number.toLowerCase();
      final lowerCaseTitle = note.title.toLowerCase();
      final lowerCaseQuery = query.toLowerCase();
      return lowerCaseNumber.contains(lowerCaseQuery) ||
          lowerCaseTitle.contains(lowerCaseQuery);
    }).toList();
  }

  void addNote(Note note) {
    _notes.add(note);
  }

  void updateNote(Note updatedNote) {
    final index =
        _notes.indexWhere((note) => note.number == updatedNote.number);
    if (index != -1) {
      _notes[index] = updatedNote;
    }
  }

  void addComment(Note note, Comment comment) {
    note.comments.add(comment);
  }

  void downloadNote(Note note) {
    // Implement the logic to download the note
    print('Downloading note: ${note.title}');
  }
}
