import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'form_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Firstscreen(),
    );
  }
}

// SCREEN 1: USER REGISTRATION

class Firstscreen extends StatefulWidget {
  @override
  State<Firstscreen> createState() => _FirstscreenState();
}

class _FirstscreenState extends State<Firstscreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    sectionController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Registration')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: sectionController,
              decoration: InputDecoration(
                labelText: 'Section',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: courseController,
              decoration: InputDecoration(
                labelText: 'Course',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(
                      name: nameController.text,
                      section: sectionController.text,
                      course: courseController.text,
                    ),
                  ),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

// SCREEN 2: SUBJECT ENROLLMENT

class SecondScreen extends StatefulWidget {
  final String name;
  final String section;
  final String course;

  SecondScreen({
    required this.name,
    required this.section,
    required this.course,
  });

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final TextEditingController subject1Controller =
      TextEditingController(text: '');
  final TextEditingController time1Controller =
      TextEditingController(text: '');

  final TextEditingController subject2Controller =
      TextEditingController(text: '');
  final TextEditingController time2Controller =
      TextEditingController(text: '');

  @override
  void dispose() {
    subject1Controller.dispose();
    time1Controller.dispose();
    subject2Controller.dispose();
    time2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subject Enrollment')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: subject1Controller,
              decoration: InputDecoration(
                labelText: 'Subject 1',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: time1Controller,
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: subject2Controller,
              decoration: InputDecoration(
                labelText: 'Subject 2',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: time2Controller,
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThirdScreen(
                      name: widget.name,
                      section: widget.section,
                      course: widget.course,
                      subject1: subject1Controller.text,
                      time1: time1Controller.text,
                      subject2: subject2Controller.text,
                      time2: time2Controller.text,
                    ),
                  ),
                );
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

// SCREEN 3: SUBJECT VERIFICATION

class ThirdScreen extends StatelessWidget {
  final String name;
  final String section;
  final String course;
  final String subject1;
  final String time1;
  final String subject2;
  final String time2;

  ThirdScreen({
    required this.name,
    required this.section,
    required this.course,
    required this.subject1,
    required this.time1,
    required this.subject2,
    required this.time2,
  });

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> saveData(BuildContext context) async {
    if (name.trim().isEmpty ||
        section.trim().isEmpty ||
        course.trim().isEmpty ||
        subject1.trim().isEmpty ||
        time1.trim().isEmpty ||
        subject2.trim().isEmpty ||
        time2.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    await firestore.collection('students').add({
      'name': name.trim(),
      'section': section.trim(),
      'course': course.trim(),
      'subjects': [
        {
          'subject': subject1.trim(),
          'time': time1.trim(),
        },
        {
          'subject': subject2.trim(),
          'time': time2.trim(),
        },
      ],
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data saved successfully')),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subject Verification')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Name: $name', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Section: $section', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Course: $course', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('1. $subject1', style: TextStyle(fontSize: 18)),
            Text('Time: $time1', style: TextStyle(fontSize: 16)),
            SizedBox(height: 15),
            Text('2. $subject2', style: TextStyle(fontSize: 18)),
            Text('Time: $time2', style: TextStyle(fontSize: 16)),
            SizedBox(height: 25),
            Center(
              child: ElevatedButton(
                onPressed: () => saveData(context),
                child: Text('Save to Firebase'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

