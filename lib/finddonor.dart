import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Finddonor extends StatefulWidget {
  const Finddonor({Key? key}) : super(key: key);

  @override
  State<Finddonor> createState() => _FinddonorState();
}

class _FinddonorState extends State<Finddonor> {
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final String placeholderValue = 'Select';
  String? selectedBloodGroup;
  List<Map<String, dynamic>> donors = [];

  @override
  void initState() {
    super.initState();
    selectedBloodGroup = placeholderValue;
  }

  Future<void> fetchDonors() async {
    try {
      // Replace 'users' with your Firestore collection name
      var querySnapshot = await FirebaseFirestore.instance.collection('users')
          .where('BloodGroup', isEqualTo: selectedBloodGroup)
          .get();

      List<Map<String, dynamic>> tempDonors = [];
      querySnapshot.docs.forEach((doc) {
        String name = doc['name'];
        String phone = doc['phone'];
        // Create a map to hold donor details
        tempDonors.add({'name': name, 'phone': phone});
      });

      setState(() {
        donors = tempDonors; // Update state with fetched donors
      });
    } catch (e) {
      print('Error fetching donors: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 22.0, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Find Donor",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 27,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Blood donors around you",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 22.0, top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Blood Group",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 22.0, top: 7),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedBloodGroup,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBloodGroup = newValue ?? placeholderValue;
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: placeholderValue,
                              child: Text(
                                placeholderValue,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            ...bloodGroups.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 22.0, top: 20, bottom: 15),
                    child: ElevatedButton(
                      onPressed: fetchDonors,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Colors.redAccent.withOpacity(0.4),
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: donors.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        title: Text(
                          donors[index]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16, // Adjust font size if needed
                            color: Colors.black, // Text color
                          ),
                        ),
                        subtitle: Text(
                          donors[index]['phone'],
                          style: TextStyle(
                            fontSize: 14, // Adjust font size if needed
                            color: Colors.grey[600], // Subtitle text color
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[600], // Trailing icon color
                        ),
                        onTap: () {
                          // Handle onTap if needed
                        },
                      ),
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


