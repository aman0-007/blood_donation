import 'package:blood_donor/accountoptionpage.dart';
import 'package:blood_donor/bottomnavigationpage.dart';
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

  Future<void> registerWithEmailAndPassword(BuildContext context,String name, String email, String password,String dob, String gender, String phone) async {
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
      });
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
      await FirebaseFirestore.instance.collection('hospital').doc('bloodbanks').collection('Hospital').doc(userCredential.user?.uid).set({
        'email': email,
        'name' : name,
        'currentPosition':GeoPoint(currentPosition.latitude, currentPosition.longitude),
        'full address' : fulladdress,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register')),
      );
    }
  }

  Future<User?> signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Bottomnavigationpage()),
      );
      return userCredential.user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign-in failed')),
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

  Future<void> startDonationSession(BuildContext context, )
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
