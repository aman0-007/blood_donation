import 'package:blood_donor/donorhealthdetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class Takeblood extends StatefulWidget {
  const Takeblood({super.key});

  @override
  State<Takeblood> createState() => _TakebloodState();
}

class _TakebloodState extends State<Takeblood> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<Map<String, dynamic>>> _fetchDonorDetails() async {
    User? currentUser = _auth.currentUser; // Ensure you have the current user
    List<Map<String, dynamic>> donorDetails = [];

    // Fetch sessions under the current user's hospital collection
    var sessions = await _firestore
        .collection('hospital')
        .doc(currentUser?.uid) // Using the current user's ID
        .collection('sessions') // Sessions collection
        .get();

    for (var session in sessions.docs) {
      // Access the donors map within each session document
      var sessionData = session.data();
      var donors = sessionData['donors'] as Map<String, dynamic>?;

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
                      String userId = donorDetails[index]['userId'];
                      String status = donorDetails[index]['status']; // Get the user ID

                      if (status=="pending"){
                        return Card( // Use Card to make ListTile more attractive
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4,
                          child: ListTile(
                            title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('DOB: $dob\nEligibility: $eligibility'),
                            onTap: () {
                              // Navigate to DonorHealthDetails page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Donorhealthdetails(userId : userId),
                                ),
                              );
                            },
                          ),
                        );
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
          // Add your onPressed code here
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

