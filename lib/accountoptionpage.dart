import 'package:blood_donor/hospitallogin.dart';
import 'package:blood_donor/loginscreen.dart';
import 'package:blood_donor/main.dart';
import 'package:blood_donor/register.dart';
import 'package:flutter/material.dart';

class AccountOptionPage extends StatefulWidget {
  const AccountOptionPage({super.key,});

  @override
  State<AccountOptionPage> createState() => _AccountOptionPageState();
}

class _AccountOptionPageState extends State<AccountOptionPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const MyHomePage(title: "Homepage"),
                      ));
                    },
                    child: const Text(
                      "Skip Now",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const Hospitallogin(),
                      ));
                    },
                    icon: const Icon(Icons.arrow_forward),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90,),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Image.asset('assets/blood_drop.png'),
            ),
            const SizedBox(height: 5),
            const Text(
              'Blood Help',
              style: TextStyle(
                fontFamily: 'YesevaOne',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              'Together WE SAVE People',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 40,),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.red,width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisteScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.asset("assets/bottomimageaccountpage.png",fit: BoxFit.fitHeight,),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
