import 'package:blood_donor/hospital%20dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blood_donor/accountoptionpage.dart';
import 'package:blood_donor/bottomnavigationpage.dart';
import 'package:blood_donor/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkUserLoginStatus();
  }

  Future<void> checkUserLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulating a delay
    final Authentication _auth = Authentication();

    // Check Firebase authentication state
    User? user = _auth.getCurrentUser();
    if (user != null) {
      // User is authenticated, check Firestore for donor status

      final docRef = FirebaseFirestore.instance.collection('donors').doc(user.uid);
      final docSnapshot = await docRef.get();

      // Navigate based on donor status
      if (docSnapshot.exists) {
        // If the document exists, navigate to Bottomnavigationpage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bottomnavigationpage()),
        );
      } else {
        // If the document does not exist, navigate to Hospitaldashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Hospitaldashboard()), // Replace with your actual page
        );
      }
    } else {
      // User not authenticated, navigate to login page
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => AccountOptionPage()));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isLoading
            ? CircularProgressIndicator() // Show loading indicator while checking user state
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Image.asset('assets/blood_drop.png')),
            const SizedBox(height: 20),
            const Text(
              'Blood Help',
              style: TextStyle(
                fontFamily: 'YesevaOne',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Together WE SAVE People',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
