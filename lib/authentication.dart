import 'package:blood_donor/accountoptionpage.dart';
import 'package:blood_donor/bottomnavigationpage.dart';
import 'package:blood_donor/hospital%20dashboard.dart';
import 'package:blood_donor/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: '587619807474-9h66nbtjd1if00v5ac141h31hjuaaaoc.apps.googleusercontent.com',
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final UserCredential userCredential = await _auth.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bottomnavigationpage()),
        );
        return userCredential.user;
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
    return null;
  }

  Future<void> registerWithEmailAndPassword(BuildContext context,String name, String email, String password,String dob, String gender, String phone, String? bg, Position currentPosition, String fulladdress) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'name' : name,
        'dob': dob,
        'gender': gender,
        'phone': phone,
        'userId': userCredential.user?.uid,
        'lifeSaved': 0,
        'BloodGroup': bg,
        'currentPosition':GeoPoint(currentPosition.latitude, currentPosition.longitude),
        'full address' : fulladdress,
        'eligibilityToDonate': "pending",
      });
      await FirebaseFirestore.instance.collection('donors').doc(userCredential.user?.uid).set({});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register')),
      );
    }
  }

  Future<void> registerHospitalWithEmailAndPassword(BuildContext context,String name, String email, String password, Position currentPosition, String fulladdress) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      await FirebaseFirestore.instance.collection('hospital')..doc(userCredential.user?.uid).set({
        'email': email,
        'name' : name,
        'currentPosition':GeoPoint(currentPosition.latitude, currentPosition.longitude),
        'full address' : fulladdress,
        'hosId':userCredential.user?.uid,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register')),
      );
    }
  }

  Future<User?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      // Attempt to sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user is authenticated
      if (userCredential.user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User sign-in failed')),
        );
        return null;
      }

      final String userId = userCredential.user!.uid;

      // Reference to the document in the 'donors' collection
      final docRef = FirebaseFirestore.instance.collection('donors').doc(userId);
      final docSnapshot = await docRef.get();

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

      return userCredential.user;
    } catch (e) {
      // Handle errors and display appropriate messages
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed: $e')),
      );
      return null;
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await googleSignIn.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed out')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AccountOptionPage()),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign out')),
      );
    }
  }

  Future<void> startDonationSession(BuildContext context, String name, String email, String contact, Position? currentPosition, String selectedAddress, String? landmark, DateTime startTime, DateTime date,) async {
    // Validate form fields
    if (name.isNotEmpty &&
        email.isNotEmpty &&
        contact.isNotEmpty &&
        currentPosition != null &&
        selectedAddress.isNotEmpty) {
      try {
        // Get current user
        User? currentUser = _auth.currentUser;

        // Check if user is authenticated
        if (currentUser != null) {
          // Save session details in Firebase
          await saveSessionDetails(currentUser, name, email, contact,
              currentPosition, selectedAddress, landmark, startTime, date);

          // Show success message or navigate to next screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Session started successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          throw Exception('User not logged in.');
        }
      } catch (e) {
        print('Error starting session: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start session. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in all required fields.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> saveSessionDetails(User currentUser, String name, String email, String contact, Position currentPosition, String selectedAddress, String? landmark, DateTime startTime, DateTime date,) async {
    // Firestore path
    final firestore = FirebaseFirestore.instance;
    final userDocRef = firestore.collection('hospital').doc(currentUser.uid).collection('sessions').doc(name);

    // Data to be saved
    Map<String, dynamic> sessionData = {
      'name': name,
      'email': email,
      'contact': contact,
      'status': 'on',
      'hosId':currentUser.uid,
      'currentPosition': GeoPoint(currentPosition.latitude, currentPosition.longitude),
      'selectedAddress': selectedAddress,
      'landmark': landmark,
      'startTime': startTime,
      'date': date,
    };

    // Update or set user document
    await userDocRef.set(sessionData, SetOptions(merge: true));
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

}

class AuthWrapper extends StatelessWidget {
  final Widget home;
  final Widget login;

  const AuthWrapper({required this.home, required this.login, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return home;
        }
        return login;
      },
    );
  }
}
