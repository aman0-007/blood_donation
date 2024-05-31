import 'package:blood_donor/finddonor.dart';
import 'package:blood_donor/homepage.dart';
import 'package:blood_donor/profile.dart';
import 'package:blood_donor/requestspage.dart';
import 'package:flutter/material.dart';

class Bottomnavigationpage extends StatefulWidget {
  const Bottomnavigationpage({super.key});

  @override
  State<Bottomnavigationpage> createState() => _BottomnavigationpageState();
}

class _BottomnavigationpageState extends State<Bottomnavigationpage> {

  int myCurrentIndex = 0;

  List pages = const [
    HomePage(),
    Finddonor(),
    Requestspage(),
    ProfilePage(),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: myCurrentIndex,

        onTap: (index){
          setState(() {
            myCurrentIndex = index;
          });
        },

        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: const Color(0xFFCB0909),
        backgroundColor: Colors.white,


        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined,color: Colors.red,),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined,color: Colors.red,),
              label: "Search"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_task,color: Colors.red,),
              label: "Request"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined,color: Colors.red,),
              label: "Profile"
          ),
        ],
      ),

      body: pages[myCurrentIndex],
    );
  }
}