import 'package:blood_donor/bottomnavigationpage.dart';
import 'package:flutter/material.dart';

class Donorhealthdetails extends StatefulWidget {
  const Donorhealthdetails({Key? key}) : super(key: key);

  @override
  State<Donorhealthdetails> createState() => _DonorhealthdetailsState();
}

class _DonorhealthdetailsState extends State<Donorhealthdetails> {
  bool? _hasDiabetes;
  bool? _heartOrLungProblems;
  bool? _hadCovid19;
  bool? _hivAidsPositive;
  bool? _hadCancer;
  bool? _hadVaccination;
  bool _isVerified = false;

  @override
  Widget build(BuildContext context) {
    void _toggleVerification() {
      setState(() {
        _isVerified = !_isVerified;
      });
    }

    bool _isVerificationComplete() {
      return _isVerified;
    }

    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(deviceWidth * 0.07),
          padding: EdgeInsets.all(deviceWidth * 0.03),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 7.0),
                Text(
                  "Questionnaires",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                ),
                SizedBox(height: deviceHeight * 0.01),
                Text(
                  "Fill up the following questionnaires and become a donor",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                ),
                const Divider(
                  color: Colors.blueGrey,
                  thickness: 1,
                ),
                SizedBox(height: deviceHeight * 0.017),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Do you have diabetes?",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.003),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: _hasDiabetes,
                          onChanged: (value) {
                            setState(() {
                              _hasDiabetes = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("Yes", style: TextStyle(fontWeight: FontWeight.bold, color: _hasDiabetes == true ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                    SizedBox(width: deviceWidth * 0.009),
                    Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: _hasDiabetes,
                          onChanged: (value) {
                            setState(() {
                              _hasDiabetes = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("No", style: TextStyle(fontWeight: FontWeight.bold, color: _hasDiabetes == false ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                SizedBox(height: deviceHeight * 0.014),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "Have you ever had problems with your heart or lungs?",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.003),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: _heartOrLungProblems,
                          onChanged: (value) {
                            setState(() {
                              _heartOrLungProblems = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("Yes", style: TextStyle(fontWeight: FontWeight.bold, color: _heartOrLungProblems == true ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                    SizedBox(width: deviceWidth * 0.009),
                    Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: _heartOrLungProblems,
                          onChanged: (value) {
                            setState(() {
                              _heartOrLungProblems = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("No", style: TextStyle(fontWeight: FontWeight.bold, color: _heartOrLungProblems == false ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                SizedBox(height: deviceHeight * 0.014),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "In the last 28 days have you had COVID-19?",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.003),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: _hadCovid19,
                          onChanged: (value) {
                            setState(() {
                              _hadCovid19 = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("Yes", style: TextStyle(fontWeight: FontWeight.bold, color: _hadCovid19 == true ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                    SizedBox(width: deviceWidth * 0.009),
                    Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: _hadCovid19,
                          onChanged: (value) {
                            setState(() {
                              _hadCovid19 = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("No", style: TextStyle(fontWeight: FontWeight.bold, color: _hadCovid19 == false ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                SizedBox(height: deviceHeight * 0.014),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "Have you ever had a positive test for HIV/AIDS virus?",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.003),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: _hivAidsPositive,
                          onChanged: (value) {
                            setState(() {
                              _hivAidsPositive = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("Yes", style: TextStyle(fontWeight: FontWeight.bold, color: _hivAidsPositive == true ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                    SizedBox(width: deviceWidth * 0.009),
                    Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: _hivAidsPositive,
                          onChanged: (value) {
                            setState(() {
                              _hivAidsPositive = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("No", style: TextStyle(fontWeight: FontWeight.bold, color: _hivAidsPositive == false ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                SizedBox(height: deviceHeight * 0.014),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Have you ever had cancer?",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.003),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: _hadCancer,
                          onChanged: (value) {
                            setState(() {
                              _hadCancer = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("Yes", style: TextStyle(fontWeight: FontWeight.bold, color: _hadCancer == true ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                    SizedBox(width: deviceWidth * 0.009),
                    Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: _hadCancer,
                          onChanged: (value) {
                            setState(() {
                              _hadCancer = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("No", style: TextStyle(fontWeight: FontWeight.bold, color: _hadCancer == false ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                SizedBox(height: deviceHeight * 0.014),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "In the last 3 months have you had a vaccination?",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.003),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: _hadVaccination,
                          onChanged: (value) {
                            setState(() {
                              _hadVaccination = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("Yes", style: TextStyle(fontWeight: FontWeight.bold, color: _hadVaccination == true ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                    SizedBox(width: deviceWidth * 0.009),
                    Row(
                      children: [
                        Radio(
                          value: false,
                          groupValue: _hadVaccination,
                          onChanged: (value) {
                            setState(() {
                              _hadVaccination = value;
                            });
                          },
                          activeColor: Colors.redAccent,
                        ),
                        Text("No", style: TextStyle(fontWeight: FontWeight.bold, color: _hadVaccination == false ? Colors.redAccent : Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),

                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    children: [
                      GestureDetector(
                          onTap: _toggleVerification,
                          child: Image.asset(_isVerified ? "assets/verified.png" : "assets/verify.png",)
                      ),
                      SizedBox(width: deviceWidth*0.007,),
                      Flexible(child: Text("By clicking you agree to our terms and condition",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),)),

                    ],
                  ),
                ),

                SizedBox(height: deviceHeight * 0.01),
                Padding(
                  padding: EdgeInsets.only(left: deviceWidth * 0.02, right: deviceWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          elevation: 5,
                          minimumSize: Size(deviceWidth * 0.7, deviceHeight * 0.057),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isVerificationComplete()
                            ? () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const Bottomnavigationpage()), // Make sure BottomNavigationPage is defined
                          );
                        }
                            : null,
                        child: Text(
                          'Become a donor',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: deviceHeight * 0.015),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
