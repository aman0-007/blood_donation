import 'package:flutter/material.dart';

class Finddonor extends StatefulWidget {
   Finddonor({super.key});

  @override
  State<Finddonor> createState() => _FinddonorState();
}

class _FinddonorState extends State<Finddonor> {

  String selectedBloodGroup = 'A+';

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
                  Padding(
                    padding: const EdgeInsets.only(left: 17.0,top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
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
                  Padding(
                    padding: const EdgeInsets.only(left: 17.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Blood donors around you",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17.0,top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Choose Blood Group",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17.0, right: 100, top: 7),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey), // Add border to container
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedBloodGroup == '' ? null : selectedBloodGroup,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedBloodGroup = newValue ?? '';
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                child: Text('Select', style: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            ...bloodGroups.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                                  child: Text(value),
                                ),
                              );
                            }),
                          ],
                          icon: Icon(Icons.arrow_drop_down, color: Colors.grey), // Custom dropdown icon
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17.0,top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Location",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 17.0,right: 100,top: 7),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 12.0),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 180.0,top: 40,bottom: 40,right: 180),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 17,horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: Colors.redAccent.withOpacity(0.4),
                            width: 3.0,
                          ),
                        ),
                      ),
                      child: Row(
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
