import 'package:blood_donor/checkeligibility.dart';
import 'package:blood_donor/finddonor.dart';
import 'package:blood_donor/requestspage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<String> imageAssets = [
    "assets/imgforsliderview.png",
    "assets/imageforslider2.png",
  ];

  final List<String> titles = [
    '"The measure of life is not its DURATION but its DONATION"',
    '"A bottle of blood saved my life. Was it yours?"',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Image.asset(
          "assets/blooddrop.png",
          width: 26,
          height: 26,
        ),
        title: const Text(
          "Blood Donor",
          style: TextStyle(
            color: Color(0xFF7E0202),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Image.asset(
                "assets/nonotification.png",
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45,vertical: 5),
                    child: Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.yellowAccent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            )
                          ]
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              const Text(
                                "Check your eligibility to Donate",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios_rounded),
                                color: Colors.black,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const Checkeligibility()), // Replace RequestPage with your actual request page
                                  );
                                },
                              ),
                            ],
                          ),

                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 45,bottom: 45,left: 20,right: 40),
                                child: Image.asset(
                                  "assets/blooddonationlocation.png",
                                  width: 70,
                                  height: 70,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Text(
                                "Nearby donors",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w900
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(top: 8,bottom: 8,left: 30,right: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5), // Border color
                              width: 1, // Border width
                            ),
                            borderRadius: BorderRadius.circular(10), // Border radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                spreadRadius: 1, // Spread radius
                                blurRadius: 2, // Blur radius
                                offset: const Offset(0, 2), // Offset
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/blood-bank.png"),
                                const SizedBox(height: 7),
                                const Text(
                                  "Blood banks",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5), // Border color
                              width: 1, // Border width
                            ),
                            borderRadius: BorderRadius.circular(10), // Border radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                spreadRadius: 1, // Spread radius
                                blurRadius: 2, // Blur radius
                                offset: const Offset(0, 2), // Offset
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/bloodhospital.png"),
                                const SizedBox(height: 7),
                                const Text(
                                  "Hospital",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5), // Border color
                              width: 1, // Border width
                            ),
                            borderRadius: BorderRadius.circular(10), // Border radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                spreadRadius: 1, // Spread radius
                                blurRadius: 2, // Blur radius
                                offset: const Offset(0, 2), // Offset
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/blood-type.png"),
                                const SizedBox(height: 7),
                                const Text(
                                  "Blood Groups",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.5), // Border color
                              width: 1, // Border width
                            ),
                            borderRadius: BorderRadius.circular(10), // Border radius
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                spreadRadius: 1, // Spread radius
                                blurRadius: 2, // Blur radius
                                offset: const Offset(0, 2), // Offset
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/bloodinfo.png"),
                                const SizedBox(height: 7),
                                const Text(
                                  "Get Info",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _currentIndex == 0 || _currentIndex == 1
          ? BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            switch (_currentIndex) {
              case 0 :
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()), // Replace RequestPage with your actual request page
                );
                break;
              case 1 :
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Finddonor()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Requestspage()),
                );
                break;
            }
          });
        },
        unselectedItemColor:const Color(0xFF7E0202),
        selectedItemColor: Colors.redAccent,
        selectedFontSize: 14.0,
        unselectedFontSize: 14.0,
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page_outlined),
              label: 'Find Donor'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_task_sharp,),
              label: 'Request'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile'
          ),
        ],
      ): null ,
    );
  }
}
