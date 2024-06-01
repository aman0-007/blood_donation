
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final EmailAuth emailAuth = EmailAuth();

  Future<void> sendEmailOTP(String receiverEmail) async {
    emailAuth.sessionName = "Verify Email Using OTP";
    var res = await EmailAuth.sendOtp(receivereMail: receiverEmail);
    if (res) {
      print("OTP sent successfully");
    }else{
      print("Failed to send OTP");
    }
  }



}