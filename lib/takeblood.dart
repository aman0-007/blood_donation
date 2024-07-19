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
    User? currentUser = _auth.currentUser; // Replace with actual current user ID
    List<Map<String, dynamic>> donorDetails = [];

    // Fetch sessions under the current user's hospital collection
    var sessions = await _firestore
        .collection('hospital')
        .doc(currentUser?.uid)
        .collection('session')
        .get();

    for (var session in sessions.docs) {
      // Fetch donors under each session
      var donors = await session.reference.collection('donors').get();
      for (var donor in donors.docs) {
        donorDetails.add(donor.data());
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
      body: Padding(
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

                      return ListTile(
                        title: Text(name),
                        subtitle: Text('DOB: $dob\nEligibility: $eligibility'),
                      );
                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
