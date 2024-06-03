import 'package:flutter/material.dart';

class Checkeligibility extends StatefulWidget {
  const Checkeligibility({super.key});
  @override
  State<Checkeligibility> createState() => _CheckeligibilityState();
}

class _CheckeligibilityState extends State<Checkeligibility> {
  int _currentIndex = 0;
  late List<Widget> _containers;

  @override
  void initState() {
    super.initState();
    _containers = [
      const ContainerOne(),
      const ContainerTwo(),
      const ContainerThree(),
      const ContainerFour(),
      const ContainerFive(),
    ];
  }

  void _navigateForward() {
    setState(() {
      if (_currentIndex < _containers.length - 1) {
        _currentIndex++;
      }
    });
  }

  void _navigateBackward() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(280.0),
                  bottomRight: Radius.circular(280.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.5),
                    spreadRadius: 7,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              alignment: Alignment.center,
              width: 170,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(90),
                  bottomLeft: Radius.circular(90),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 25,
            left: 90,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,),
              onPressed: _navigateBackward,
            ),
          ),
          Positioned(
            top: 25,
            right: 90,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded,color: Colors.white,),
              onPressed: _navigateForward,
            ),
          ),
          const Positioned(
            top: 27,
            child: Text(
              "1/4",
              style: TextStyle(
                  color: Color(0xFFCB0909),
                  fontSize: 19,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          Positioned(
            top: 140,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                  child: child,
                );
              },
              child: _containers[_currentIndex],
            ),
          ),


          /* Positioned(
 top: 130,
 child: AnimatedSwitcher(
 duration: const Duration(milliseconds: 500),
 transitionBuilder: (Widget child, Animation<double> animation) {
 return ScaleTransition(
 scale: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
 child: child,
 );
 },
 child: _containers[_currentIndex],
 ),
 ),*/

          /* Positioned(
 top: 130,
 child: AnimatedSwitcher(
 duration: const Duration(milliseconds: 500),
 transitionBuilder: (Widget child, Animation<double> animation) {
 return SlideTransition(
 position: Tween<Offset>(
 begin: Offset(1.0, 0.0),
 end: Offset.zero,
 ).animate(animation),
 child: child,
 );
 },
 child: _containers[_currentIndex],
 ),
 ),*/
          /*Positioned(
 top: 130,
 child: AnimatedSwitcher(
 duration: const Duration(milliseconds: 500),
 transitionBuilder: (Widget child, Animation<double> animation) {
 return ScaleTransition(
 scale: animation,
 child: FadeTransition(
 opacity: animation,
 child: child,
 ),
 );
 },
 child: _containers[_currentIndex],
 ),
 ),*/

        ],
      ),
    );
  }
}


class ContainerOne extends StatelessWidget {
  const ContainerOne({super.key});

  @override
  Widget build(BuildContext context){
    return Positioned(
      top: 130,
      child: Container(
        width: 320,
        height: 500,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          // border: Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 25.0,bottom: 20.0,left: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Is your weight less than\n",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "50kg?",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0,right: 50,top: 30,bottom: 25),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red,width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red,width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4.0,bottom: 10),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Color(0xFFCB0909),
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0,bottom: 9),
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.arrow_forward_rounded),
                    color: const Color(0xFFCB0909),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class ContainerTwo extends StatelessWidget {
  const ContainerTwo({super.key});

  @override
  Widget build(BuildContext context){
    return Positioned(
      top: 130,
      child: Container(
        width: 320,
        height: 500,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          // border: Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 25.0,bottom: 20.0,left: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Are you suffering from any\n",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "of the below?",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 25.0,top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " * Transmittable disease",
                        style: TextStyle(
                            color: Color(0xFF810404),
                            fontSize: 13
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " * Asthma",
                        style: TextStyle(
                            color: Color(0xFF810404),
                            fontSize: 13
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " * Cardiac arrest",
                        style: TextStyle(
                            color: Color(0xFF810404),
                            fontSize: 13
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " * Hypertension",
                        style: TextStyle(
                            color: Color(0xFF810404),
                            fontSize: 13
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " * Blood Preasure",
                        style: TextStyle(
                            color: Color(0xFF810404),
                            fontSize: 13
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " * Diabetes",
                        style: TextStyle(
                            color: Color(0xFF810404),
                            fontSize: 13
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " * Cancer",
                        style: TextStyle(
                            color: Color(0xFF810404),
                            fontSize: 13
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0,right: 50,top: 30,bottom: 25),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red,width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red,width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4.0,bottom: 10),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Color(0xFFCB0909),
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0,bottom: 9),
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.arrow_forward_rounded),
                    color: const Color(0xFFCB0909),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class ContainerThree extends StatelessWidget {
  const ContainerThree({super.key});

  @override
  Widget build(BuildContext context){
    return Positioned(
      top: 130,
      child: Container(
        width: 320,
        height: 500,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          // border: Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 25.0,bottom: 20.0,left: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Have you undergone tatoo\n",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "in last 6 months?",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0,right: 50,top: 30,bottom: 25),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red,width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red,width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4.0,bottom: 10),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Color(0xFFCB0909),
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0,bottom: 9),
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.arrow_forward_rounded),
                    color: const Color(0xFFCB0909),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class ContainerFour extends StatelessWidget {
  const ContainerFour({super.key});

  @override
  Widget build(BuildContext context){
    return Positioned(
      top: 130,
      child: Container(
        width: 320,
        height: 500,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          // border: Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 25.0,bottom: 20.0,left: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Have you undergo \n",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "immunization in the past\n",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "one month?",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0,right: 50,top: 30,bottom: 25),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red,width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red,width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4.0,bottom: 10),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Color(0xFFCB0909),
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0,bottom: 9),
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.arrow_forward_rounded),
                    color: const Color(0xFFCB0909),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class ContainerFive extends StatelessWidget {
  const ContainerFive({super.key});

  @override
  Widget build(BuildContext context){
    return Positioned(
      top: 130,
      child: Container(
        width: 320,
        height: 500,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          // border: Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 25.0,bottom: 20.0,left: 20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Thank YOU\n",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: "For submitting the form",
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0,right: 50,top: 30,bottom: 25),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red,width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: ElevatedButton(
                      onPressed: () {
                        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 60),
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.red,width: 2.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 4.0,bottom: 10),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                        color: Color(0xFFCB0909),
                        fontWeight: FontWeight.bold,
                        fontSize: 17
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0,bottom: 9),
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.arrow_forward_rounded),
                    color: const Color(0xFFCB0909),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}