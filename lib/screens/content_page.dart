import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semester Content',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ContentPage(),
    );
  }
}

class Lecture {
  final String title;
  final String fileName;

  Lecture(this.title, this.fileName);
}

class ContentPage extends StatefulWidget {
  const ContentPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String? selectedSemester;
  String? selectedSubject;
  final List<String> semesters =
      List.generate(10, (index) => 'Semester ${index + 1}');

  final Map<String, List<String>> semesterSubjects = {
    'Semester 1': ['Math 1', 'Introduction to CS', 'Physics 1'],
    'Semester 2': ['Math 2', 'CS 2', 'Physics 2'],
    'Semester 3': ['Math 3', 'CS 3', 'Physics 3'],
    'Semester 4': ['Math 4', 'CS 4', 'Circuits 2'],
    'Semester 5': ['Database Theory', 'Networks', 'Theory of Computation'],
    'Semester 6': [
      'Database 2',
      'Computer Architecture',
      'Software Engineering'
    ],
    'Semester 7': ['Advanced Computer Languages', 'Embedded Systems'],
    'Semester 8': ['Bachelor Project'],
    'Semester 9': ['Elective 1', 'Elective 2'],
    'Semester 10': ['Elective 3', 'Elective 4'],
  };

  final Map<String, List<Lecture>> subjectLectures = {
    'Math 1': [
      Lecture('Introduction to Calculus', 'math1_lecture1.pdf'),
      Lecture('Linear Algebra Basics', 'math1_lecture2.pdf'),
    ],
    'Introduction to CS': [
      Lecture('Introduction to Programming', 'cs1_lecture1.pdf'),
      Lecture('Data Structures Basics', 'cs1_lecture2.pdf'),
    ],
    'Physics 1': [
      Lecture('Mechanics Basics', 'physics1_lecture1.pdf'),
      Lecture('Introduction to Thermodynamics', 'physics1_lecture2.pdf'),
    ],
    'Math 2': [
      Lecture('Advanced Calculus', 'math2_lecture1.pdf'),
      Lecture('Linear Algebra II', 'math2_lecture2.pdf'),
    ],
    'CS 2': [
      Lecture('Object-Oriented Programming', 'cs2_lecture1.pdf'),
      Lecture('Algorithms Basics', 'cs2_lecture2.pdf'),
    ],
    'Physics 2': [
      Lecture('Electricity and Magnetism', 'physics2_lecture1.pdf'),
      Lecture('Optics', 'physics2_lecture2.pdf'),
    ],
    'Math 3': [
      Lecture('Differential Equations', 'math3_lecture1.pdf'),
      Lecture('Vector Calculus', 'math3_lecture2.pdf'),
    ],
    'CS 3': [
      Lecture('Data Structures Advanced', 'cs3_lecture1.pdf'),
      Lecture('Algorithms Advanced', 'cs3_lecture2.pdf'),
    ],
    'Physics 3': [
      Lecture('Quantum Mechanics Basics', 'physics3_lecture1.pdf'),
      Lecture('Relativity Theory', 'physics3_lecture2.pdf'),
    ],
    'Math 4': [
      Lecture('Probability Theory', 'math4_lecture1.pdf'),
      Lecture('Numerical Methods', 'math4_lecture2.pdf'),
    ],
    'CS 4': [
      Lecture('Operating Systems', 'cs4_lecture1.pdf'),
      Lecture('Software Design Patterns', 'cs4_lecture2.pdf'),
    ],
    'Circuits 2': [
      Lecture('AC Circuits', 'circuits2_lecture1.pdf'),
      Lecture('Digital Electronics', 'circuits2_lecture2.pdf'),
    ],
    'Database Theory': [
      Lecture('Relational Databases', 'db1_lecture1.pdf'),
      Lecture('SQL Basics', 'db1_lecture2.pdf'),
    ],
    'Networks': [
      Lecture('Network Topologies', 'networks_lecture1.pdf'),
      Lecture('TCP/IP Protocols', 'networks_lecture2.pdf'),
    ],
    'Theory of Computation': [
      Lecture('Automata Theory', 'toc_lecture1.pdf'),
      Lecture('Turing Machines', 'toc_lecture2.pdf'),
    ],
    'Database 2': [
      Lecture('Advanced SQL', 'db2_lecture1.pdf'),
      Lecture('Database Optimization', 'db2_lecture2.pdf'),
    ],
    'Computer Architecture': [
      Lecture('Microprocessors', 'ca_lecture1.pdf'),
      Lecture('Memory Hierarchy', 'ca_lecture2.pdf'),
    ],
    'Software Engineering': [
      Lecture('Software Development Life Cycle', 'se_lecture1.pdf'),
      Lecture('Agile Methodologies', 'se_lecture2.pdf'),
    ],
    'Advanced Computer Languages': [
      Lecture('Functional Programming', 'acl_lecture1.pdf'),
      Lecture('Concurrency', 'acl_lecture2.pdf'),
    ],
    'Embedded Systems': [
      Lecture('Microcontroller Programming', 'es_lecture1.pdf'),
      Lecture('Real-Time Systems', 'es_lecture2.pdf'),
    ],
    'Bachelor Project': [
      Lecture('Project Planning', 'bachelor_lecture1.pdf'),
      Lecture('Research Methodologies', 'bachelor_lecture2.pdf'),
    ],
    'Elective 1': [
      Lecture('Elective Topic 1', 'elective1_lecture1.pdf'),
      Lecture('Elective Topic 2', 'elective1_lecture2.pdf'),
    ],
    'Elective 2': [
      Lecture('Elective Topic 3', 'elective2_lecture1.pdf'),
      Lecture('Elective Topic 4', 'elective2_lecture2.pdf'),
    ],
    'Elective 3': [
      Lecture('Elective Topic 5', 'elective3_lecture1.pdf'),
      Lecture('Elective Topic 6', 'elective3_lecture2.pdf'),
    ],
    'Elective 4': [
      Lecture('Elective Topic 7', 'elective4_lecture1.pdf'),
      Lecture('Elective Topic 8', 'elective4_lecture2.pdf'),
    ],
  };
  String searchQuery = '';
  List<MapEntry<String, List<Lecture>>> searchResults = [];

  void performSearch(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        searchResults = [];
      } else {
        searchResults = subjectLectures.entries.where((entry) {
          final subjectMatches =
              entry.key.toLowerCase().contains(query.toLowerCase());
          final lectureMatches = entry.value.any((lecture) =>
              lecture.title.toLowerCase().contains(query.toLowerCase()));
          return subjectMatches || lectureMatches;
        }).toList();
      }
    });
  }

  final String serverBaseUrl =
      'https://your-server.com/lectures/'; // Replace with your server URL

  Future<void> _downloadFile(String fileName) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission not granted');
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception('Could not access the downloads directory');
      }

      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);

      final response = await http.get(Uri.parse('$serverBaseUrl$fileName'));

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded to: $filePath')),
        );
      } else {
        throw Exception('Failed to download file');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading file: $e')),
      );
    }
  }

  Future<void> _openFile(String fileName) async {
    try {
      final Directory? downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception('Could not access the downloads directory');
      }

      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        await OpenFile.open(filePath);
      } else {
        // If the file doesn't exist locally, download it first
        await _downloadFile(fileName);
        await OpenFile.open(filePath);
      }
    } catch (e) {
      print('Error opening file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening file: $e')),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Content"),
        backgroundColor: Colors.blue[50],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blue[100]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search subjects or lectures',
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter keywords...',
                  hintStyle: TextStyle(color: Colors.blueGrey[300]),
                ),
                onChanged: performSearch,
              ),
            ),
            const SizedBox(height: 20),
            if (searchQuery.isEmpty) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Semester',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: Colors.white,
                  value: selectedSemester,
                  items: semesters.map((String semester) {
                    return DropdownMenuItem<String>(
                      value: semester,
                      child: Text(
                        semester,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[700],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSemester = newValue;
                      selectedSubject = null;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (selectedSemester != null)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Subject',
                      labelStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    dropdownColor: Colors.white,
                    value: selectedSubject,
                    items: semesterSubjects[selectedSemester]
                        ?.map((String subject) {
                      return DropdownMenuItem<String>(
                        value: subject,
                        child: Text(
                          subject,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue[700],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSubject = newValue;
                      });
                    },
                  ),
                ),
              const SizedBox(height: 20),
              if (selectedSubject != null)
                Expanded(
                  child: ListView.builder(
                    itemCount: subjectLectures[selectedSubject]?.length ?? 0,
                    itemBuilder: (context, index) {
                      final lecture = subjectLectures[selectedSubject]![index];
                      return _buildLectureCard(lecture);
                    },
                  ),
                ),
            ] else
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final subject = searchResults[index].key;
                    final lectures = searchResults[index].value;
                    return ExpansionTile(
                        title: Text(
                          subject,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                        backgroundColor: Colors.blue[50],
                        iconColor: Colors.blue[700],
                        collapsedIconColor: Colors.blue[700],
                        children: lectures
                            .map((lecture) => _buildLectureCard(lecture))
                            .toList());
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLectureCard(Lecture lecture) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          lecture.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blueAccent,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.open_in_browser),
              color: Colors.green,
              onPressed: () => _openFile(lecture.fileName),
            ),
            IconButton(
              icon: const Icon(Icons.download),
              color: Colors.blue,
              onPressed: () => _downloadFile(lecture.fileName),
            ),
          ],
        ),
      ),
    );
  }
}
