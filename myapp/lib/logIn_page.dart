import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:myapp/conests.dart';
import 'package:myapp/home.dart';
import 'package:myapp/register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pColor,
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  width: 100,
                  child: Image.asset('assits/IMG_9063.PNG')),
              Text(
                'WELCOME BACK !',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
              CostomTiextField(
                hint: 'gmail',
                textInputType: TextInputType.emailAddress,
                icon: Icons.email,
                controler: email,
              ),
              CostomTiextField(
                hint: 'password',
                textInputType: TextInputType.text,
                icon: Icons.password,
                controler: password,
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(2)),
                width: 160,
                height: 40,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.white)),
                    onPressed: () async {
                      try {
                        // ignore: unused_local_variable
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email.text, password: password.text);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return Home();
                        }));
                      } on FirebaseAuthException catch (e) {


                        AwesomeDialog(
                          context: context,
                          animType: AnimType.scale,
                          dialogType: DialogType.error,
                          body: Center(
                            child: Text(
                              '$e',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                          title: 'Wrong Input',
                          btnOkColor: pColor,
                          btnOkOnPress: () {},
                        ).show();

                      }
                    },
                    child: Text(
                      'LOG IN',
                      style: TextStyle(color: pColor),
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'don\'t have an accaunt ?',
                    style: TextStyle(color: Colors.white54),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RegisterPage();
                      }));
                    },
                    child: Text(
                      'register now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assits/facebook_icon.jpg',
                      fit: BoxFit.fill,
                      height: 44.0,
                      width: 40.0,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assits/google_icon.jpg',
                      fit: BoxFit.fill,
                      height: 44.0,
                      width: 40.0,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Home();
                  }));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Skip Now ',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

// ignore: must_be_immutable
class CostomTiextField extends StatelessWidget {
  CostomTiextField(
      {required this.hint,
      required this.textInputType,
      required this.icon,
      required this.controler});
  final formKey = GlobalKey<FormState>();

  TextEditingController controler = TextEditingController();
  IconData icon;
  String hint;
  TextInputType textInputType;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        width: 388,
        child: TextFormField(
          controller: controler,
          style: TextStyle(color: Colors.white),
          keyboardType: textInputType,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.grey),
            labelText: hint,
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white24)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(icon, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.grey),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
  }
}
