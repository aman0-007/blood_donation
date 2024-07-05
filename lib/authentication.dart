import 'package:email_auth/email_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      clientId: "934563171285-vk8h2pft0j81idildiikjtm2ht7ef11p.apps.googleusercontent.com"
  );
  final EmailAuth emailAuth = EmailAuth(sessionName: "Verify email using OTP");


  Future<void> signInWithGoogle() async {
    try{
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      final User? user = _auth.currentUser;
      if (user != null){
        print('Successfully signed in with Google : ${user.displayName}');
      }
    }catch(error){
      print('Failed to sign in with Google: $error');
    }
  }

  Future<void> sendEmailOTP(String receiverEmail) async {
    emailAuth.sessionName = "Verify Email Using OTP";
    var res = await emailAuth.sendOtp(recipientMail: receiverEmail);
    if (res) {
      print("OTP sent successfully");
    }else{
      print("Failed to send OTP");
    }
  }
  
  Future<bool> verifyEmailOTP(String receiverEmail, String userOTP) async {
    return emailAuth.validateOtp(recipientMail: receiverEmail, userOtp: userOTP);
  }

  Future<User?> registerWithEmailAndPassword(
      String email, String password,String otp) async {
    if (await verifyEmailOTP(email, otp)) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential.user;
    }catch (e) {
        print("Failed to register : $e");
        return null;
      }
    }else{
      print("Invalid OTP");
      return null;
    }
  }
}