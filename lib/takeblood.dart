import 'package:blood_donor/donorhealthdetails.dart';
import 'package:blood_donor/newuser1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class Takeblood extends StatefulWidget {
  final String sessionName;
  const Takeblood({super.key, required this.sessionName});

  @override
  State<Takeblood> createState() => _TakebloodState();
}

class _TakebloodState extends State<Takeblood> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> _fetchDonorDetails() async {
    User? currentUser = _auth.currentUser; // Ensure you have the current user
    List<Map<String, dynamic>> donorDetails = [];

    // Fetch the session document
    var sessionDoc = await _firestore
        .collection('hospital')
        .doc(currentUser?.uid) // Using the current user's ID
        .collection('sessions')
        .doc(widget.sessionName) // Using the session name passed from previous page
        .get();

    // Access the donors map within the session document
    var sessionData = sessionDoc.data();
    var donors = sessionData?['donors'] as Map<String, dynamic>?;

    if (donors != null) {
      // Iterate over each donor subdocument
      donors.forEach((donorId, donorData) {
        if (donorData['status'] == 'pending') {
          donorDetails.add({
            'id': donorId, // Store the donor ID for navigation
            ...donorData as Map<String, dynamic>
          });
        }
      });
    }
    return donorDetails;
  }

  String _calculateEligibility(String dob) {
    DateTime birthDate = DateFormat('dd/MM/yyyy').parse(dob);
    int age = DateTime.now().year - birthDate.year;
    if (DateTime.now().month < birthDate.month ||
        (DateTime.now().month == birthDate.month && DateTime.now().day < birthDate.day)) {
      age--;
    }
    return age >= 18 ? 'Eligible' : 'Not Eligible';
  }

  Future<void> _closeSession() async {
    User? currentUser = _auth.currentUser;

    // Update the session status to 'closed'
    await _firestore
        .collection('hospital')
        .doc(currentUser?.uid) // Using the current user's ID
        .collection('sessions')
        .doc(widget.sessionName) // Using the session name passed from previous page
        .update({'status': 'closed'});

    // Navigate back to the previous page or show a success message
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'Donors',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'close') {
                _closeSession();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'close',
                child: Text('Close Session'),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.grey.withOpacity(0.7)),
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Donor List
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchDonorDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching donor details'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No donors found'));
                  }

                  List<Map<String, dynamic>> donorDetails = snapshot.data!;
                  return ListView.builder(
                    itemCount: donorDetails.length,
                    itemBuilder: (context, index) {
                      String name = donorDetails[index]['name'] ?? 'No Name';
                      String dob = donorDetails[index]['dob'] ?? 'No DOB';
                      String eligibility = _calculateEligibility(dob);
                      String userId = donorDetails[index]['id'];
                      String bloodGroup = donorDetails[index]['bloodGroup'] ?? 'No Blood Group'; // Add blood group
                      String status = donorDetails[index]['status'];

                      if (status == "pending") {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('DOB: $dob\nEligibility: $eligibility\nBlood Group: $bloodGroup'),
                            tileColor: Colors.white, // White background for ListTile
                            onTap: () {
                              // Navigate to DonorHealthDetails page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Donorhealthdetails(userId: userId,sessionName: widget.sessionName,),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return SizedBox.shrink(); // Return an empty widget if status is not 'pending'
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewRegisteScreen()), // Adjust the route if needed
          );
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
