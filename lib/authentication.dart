
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmailAuth emailAuth = EmailAuth(sessionName: "Verify email using OTP");

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