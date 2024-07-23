import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Displayrecords extends StatefulWidget {
  final String sessionName;
  const Displayrecords({super.key, required this.sessionName});

  @override
  State<Displayrecords> createState() => _DisplayrecordsState();
}

class _DisplayrecordsState extends State<Displayrecords> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<List<Map<String, dynamic>>> _sessionFuture;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _sessionFuture = _fetchSessionData();
  }

  Future<List<Map<String, dynamic>>> _fetchSessionData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Fetch the session document
      final sessionDoc = await _firestore
          .collection('hospital')
          .doc(currentUser.uid) // Using the current user's ID as hosId
          .collection('sessions')
          .doc(widget.sessionName) // Using the session name passed from the previous page
          .get();

      if (!sessionDoc.exists) {
        throw Exception('Session not found');
      }

      // Extract session data
      final sessionData = sessionDoc.data();
      if (sessionData == null || !sessionData.containsKey('donors')) {
        throw Exception('No donor data found');
      }

      final donors = sessionData['donors'] as Map<String, dynamic>;

      // Filter donors based on 'status' == 'accepted'
      final filteredDonors = donors.values.where((donor) {
        return donor['status'] == 'accepted'; // Adjust status condition here
      }).toList();

      return filteredDonors.cast<Map<String, dynamic>>(); // Ensure proper casting
    } catch (e) {
      print('Error fetching session data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donor Records'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.white, // Set background color to white
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 20),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _sessionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Text('Total Donors: 0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                  } else {
                    final filteredDonors = snapshot.data!;

                    return Text(
                      'Total Donors: ${filteredDonors.length}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 16.0, right: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query.toLowerCase();
                    });
                  },
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
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _sessionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(child: Text('No donor records found.'));
                  } else {
                    final filteredDonors = snapshot.data!;

                    final displayedDonors = filteredDonors.where((donor) {
                      final name = (donor['name'] as String?)?.toLowerCase() ?? '';
                      final email = (donor['email'] as String?)?.toLowerCase() ?? '';
                      return name.contains(searchQuery) || email.contains(searchQuery);
                    }).toList();

                    return ListView.builder(
                      itemCount: displayedDonors.length,
                      itemBuilder: (context, index) {
                        final donor = displayedDonors[index];

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          color: Colors.white, // Set ListTile card color to white
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.0),
                            title: Text(
                              donor['name'] ?? 'Unknown',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${donor['email'] ?? 'Not provided'}'),
                                Text('Phone: ${donor['phone'] ?? 'Not provided'}'),
                                Text('Blood Group: ${donor['bloodGroup'] ?? 'Not provided'}'),
                                Text('DOB: ${donor['dob'] ?? 'Not provided'}'),
                                Text('Gender: ${donor['gender'] ?? 'Not provided'}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
