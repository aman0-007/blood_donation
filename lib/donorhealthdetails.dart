import 'package:blood_donor/bottomnavigationpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Donorhealthdetails extends StatefulWidget {
  final String userId;
  final String sessionName;
  const Donorhealthdetails({Key? key, required this.userId, required this.sessionName}) : super(key: key);

  @override
  State<Donorhealthdetails> createState() => _DonorhealthdetailsState();
}

class _DonorhealthdetailsState extends State<Donorhealthdetails> {
  bool? _hasDiabetes;
  bool? _heartOrLungProblems;
  bool? _hadCovid19;
  bool? _hivAidsPositive;
  bool? _hadCancer;
  bool? _hadVaccination;
  bool _isVerified = false;
  String? _vesascAutonomous;
  String? _bdcSource;
  String? _reference;

  bool _areAllQuestionsAnswered() {
    return _hasDiabetes != null &&
        _heartOrLungProblems != null &&
        _hadCovid19 != null &&
        _hivAidsPositive != null &&
        _hadCancer != null &&
        _hadVaccination != null;
  }
  Future<void> _showAdditionalDetailsDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          backgroundColor: Colors.white, // Set background color to white
          title: Text(
            'Additional Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  label: 'Vesasc Autonomous',
                  onChanged: (value) {
                    setState(() {
                      _vesascAutonomous = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'BDC Source',
                  onChanged: (value) {
                    setState(() {
                      _bdcSource = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                _buildTextField(
                  label: 'Reference',
                  onChanged: (value) {
                    setState(() {
                      _reference = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            ElevatedButton(
              onPressed: () {


                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Background color for button
                foregroundColor: Colors.white, // Text color for button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      onChanged: onChanged,
    );
  }




  @override
  Widget build(BuildContext context) {
    void _toggleVerification() {
      setState(() {
        _isVerified = !_isVerified;
      });
    }

    bool _isVerificationComplete() {
      return _areAllQuestionsAnswered() && _isVerified;
    }

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(deviceWidth * 0.07),
          padding: EdgeInsets.all(deviceWidth * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 7.0),
                Text(
                  "Questionnaires",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                ),
                SizedBox(height: deviceHeight * 0.01),
                Text(
                  "Fill up the following questionnaires and become a donor",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                ),
                const Divider(
                  color: Colors.blueGrey,
                  thickness: 1,
                ),
                SizedBox(height: deviceHeight * 0.017),
                _buildQuestion(
                  question: "Do you have diabetes?",
                  groupValue: _hasDiabetes,
                  onChanged: (value) => setState(() { _hasDiabetes = value; }),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                _buildQuestion(
                  question: "Have you ever had problems with your heart or lungs?",
                  groupValue: _heartOrLungProblems,
                  onChanged: (value) => setState(() { _heartOrLungProblems = value; }),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                _buildQuestion(
                  question: "In the last 28 days have you had COVID-19?",
                  groupValue: _hadCovid19,
                  onChanged: (value) => setState(() { _hadCovid19 = value; }),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                _buildQuestion(
                  question: "Have you ever had a positive test for HIV/AIDS virus?",
                  groupValue: _hivAidsPositive,
                  onChanged: (value) => setState(() { _hivAidsPositive = value; }),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                _buildQuestion(
                  question: "Have you ever had cancer?",
                  groupValue: _hadCancer,
                  onChanged: (value) => setState(() { _hadCancer = value; }),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                _buildQuestion(
                  question: "In the last 3 months have you had a vaccination?",
                  groupValue: _hadVaccination,
                  onChanged: (value) => setState(() { _hadVaccination = value; }),
                ),
                const Divider(color: Colors.grey, thickness: 1),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: _toggleVerification,
                          child: Image.asset(_isVerified ? "assets/verified.png" : "assets/verify.png")
                      ),
                      SizedBox(width: deviceWidth * 0.007),
                      Flexible(child: Text("By clicking you agree to our terms and conditions", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.01),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          elevation: 5,
                          minimumSize: Size(deviceWidth * 0.7, deviceHeight * 0.057),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isVerificationComplete()
                            ? () async {
                          await _showAdditionalDetailsDialog();

                          var currentUser = FirebaseAuth.instance.currentUser;
                          if (currentUser == null) return;

                          // Reference to Firestore
                          var firestore = FirebaseFirestore.instance;

                          // Construct the session ID in the format `${hospitalId}_${sessionName}`
                          var sessionId = '${currentUser.uid}_${widget.sessionName}';

                          // Save selected options to sessions collection
                          await firestore
                              .collection('hospital')
                              .doc(currentUser.uid)
                              .collection('sessions')
                              .doc(widget.sessionName) // Use sessionName to identify the session
                              .update({
                            'donors.${widget.userId}.status': 'accepted',
                            'donors.${widget.userId}.questions': {
                              'hasDiabetes': _hasDiabetes,
                              'heartOrLungProblems': _heartOrLungProblems,
                              'hadCovid19': _hadCovid19,
                              'hivAidsPositive': _hivAidsPositive,
                              'hadCancer': _hadCancer,
                              'hadVaccination': _hadVaccination,
                            },
                            'donors.${widget.userId}.additionalDetails': {
                              'vesascAutonomous': _vesascAutonomous,
                              'bdcSource': _bdcSource,
                              'reference': _reference,
                            },
                          });

                          var userDoc = await firestore.collection('users').doc(widget.userId).get();
                          var userData = userDoc.data();

                          if (userData == null) return;

                          await firestore
                              .collection('Donation at VES')
                              .doc(widget.userId)
                              .set({
                            'userId': widget.userId,
                            'name': userData['name'],
                            'phone': userData['phone'],
                            'bloodGroup': userData['BloodGroup'],
                            'vesascAutonomous': _vesascAutonomous,
                            'bdcSource': _bdcSource,
                            'reference': _reference,
                          });
                          // Update donation status for user
                          await firestore
                              .collection('users')
                              .doc(widget.userId)
                              .update({
                            'donations.$sessionId.donationStatus': 'donated',
                            'lastDonationDate': FieldValue.serverTimestamp(), // Set the current datetime
                            'lifeSaved': FieldValue.increment(1) // Increment lifeSaved by 1
                          });

                          Navigator.of(context).pop();
                        }
                            : null,


                        child: Text(
                          'Become a donor',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion({
    required String question,
    required bool? groupValue,
    required ValueChanged<bool?> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02, right: MediaQuery.of(context).size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: groupValue,
                    onChanged: onChanged,
                    activeColor: Colors.redAccent,
                  ),
                  Text("Yes", style: TextStyle(fontWeight: FontWeight.bold, color: groupValue == true ? Colors.redAccent : Colors.grey)),
                ],
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.009),
              Row(
                children: [
                  Radio(
                    value: false,
                    groupValue: groupValue,
                    onChanged: onChanged,
                    activeColor: Colors.redAccent,
                  ),
                  Text("No", style: TextStyle(fontWeight: FontWeight.bold, color: groupValue == false ? Colors.redAccent : Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
