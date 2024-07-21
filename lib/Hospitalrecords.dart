import 'package:blood_donor/hospitaldisplayrecords.dart';
import 'package:blood_donor/takeblood.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Hospitalrecords extends StatefulWidget {
  const Hospitalrecords({super.key});

  @override
  State<Hospitalrecords> createState() => _HospitalrecordsState();
}

class _HospitalrecordsState extends State<Hospitalrecords> {
  String searchQuery = '';
  List<String> sessionNames = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final hospitalId = _auth.currentUser?.uid;
    final names = await _fetchSessionNames(hospitalId!);
    setState(() {
      sessionNames = names;
    });
  }

  Future<List<String>> _fetchSessionNames(String hospitalId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final sessionsSnapshot = await firestore
          .collection('hospital')
          .doc(hospitalId)
          .collection('sessions')
          .where('status', isEqualTo: 'on') // Filter sessions with status 'on'
          .get();
      return sessionsSnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching session names: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSessions = sessionNames
        .where((name) => name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sessions Made'),
        backgroundColor: Colors.red, // Customize the AppBar color as needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  onChanged: (query) {
                    setState(() {
                      searchQuery = query;
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
            // Session List
            Expanded(
              child: ListView.builder(
                itemCount: filteredSessions.length,
                itemBuilder: (context, index) {
                  final sessionName = filteredSessions[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        sessionName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      tileColor: Colors.white, // Set ListTile background color
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Displayrecords(sessionName: sessionName),
                          ),
                        );
                      },
                    ),
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
