import 'package:flutter/material.dart';

class Finddonor extends StatefulWidget {
   const Finddonor({super.key});

  @override
  State<Finddonor> createState() => _FinddonorState();
}

class _FinddonorState extends State<Finddonor> {

  String? selectedBloodGroup;

  @override
  Widget build(BuildContext context) {
    final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
            decoration: const BoxDecoration(
              color: Colors.redAccent,
            ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 22.0,top: 20),
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
                    padding: EdgeInsets.only(left: 22.0,),
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
                    padding: EdgeInsets.only(left: 22.0,top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Blood Group",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, right: 100, top: 7),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Select',
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
                              selectedBloodGroup = newValue ?? '';
                            });
                          },
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text(
                                'Select',
                                style: TextStyle(color: Colors.grey), // Set grey color
                              ),
                            ),
                            ...bloodGroups.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(left: 22.0,top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Location",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0,right: 100,top: 7),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter your location',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 12.0),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 135.0,top: 40,bottom: 40,right: 130),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 17,horizontal: 20),
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
                          SizedBox(width: 8,),
                          Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
