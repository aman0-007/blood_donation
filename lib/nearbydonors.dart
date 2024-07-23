import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Nearbydonors extends StatefulWidget {
  const Nearbydonors({super.key});

  @override
  State<Nearbydonors> createState() => _NearbydonorsState();
}

class _NearbydonorsState extends State<Nearbydonors> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          'NearBy Donors',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                hintText: 'Search donors...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var filteredDocs = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  var name = data['name']?.toLowerCase() ?? '';
                  var bloodGroup = data['BloodGroup']?.toLowerCase() ?? '';
                  return name.contains(searchQuery) || bloodGroup.contains(searchQuery);
                }).toList();

                if (filteredDocs.isEmpty) {
                  return Center(child: Text('No donors found.'));
                }

                return ListView.separated(
                  itemCount: filteredDocs.length,
                  separatorBuilder: (context, index) => Divider(height: 1.0),
                  itemBuilder: (context, index) {
                    var data = filteredDocs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name'] ?? 'N/A'),
                      subtitle: Text(
                        'DOB: ${data['dob'] ?? 'N/A'}\n'
                            'Blood Group: ${data['BloodGroup'] ?? 'N/A'}\n'
                            'Phone: ${data['phone'] ?? 'N/A'}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
