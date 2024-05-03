import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:myapp/conests.dart';

import 'package:myapp/logIn_page.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController userName = TextEditingController();
  TextEditingController reporterKey = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  bool isReporter = false;
  Future<void> adduser() {
    return users.add({
      'imail': email.text,
      'name': userName.text,
      'isReporter': isReporter,
      'id': FirebaseAuth.instance.currentUser!.uid
    });
  }

  List keys = [];
  getAllKeys() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('reporters_keys').get();
    var respons = querySnapshot.docs;
    for (var i = 0; i < respons.length; i++) {
      keys.add(respons[i]['key']);
    }
    for (var element in keys) {
      print(element);
    }
  }

  @override
  void initState() {
    getAllKeys();
    super.initState();
  }

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
              CostomTiextField(
                hint: 'name',
                textInputType: TextInputType.text,
                icon: Icons.account_circle,
                controler: userName,
              ),
              CostomTiextField(
                hint: 'Reporter key (optional)',
                textInputType: TextInputType.number,
                icon: Icons.account_circle,
                controler: reporterKey,
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
                        if (keys.contains(reporterKey.text)) {
                          // ignore: unused_local_variable
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );
                          isReporter = true;
                          adduser();
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.success,
                            body: const Center(
                              child: Text(
                                'Success ! Now You Can Log In ',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            title: 'Success',
                            btnOkColor: pColor,
                            btnOkOnPress: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }));
                            },
                          ).show();
                        } else if (reporterKey.text.isEmpty ||
                            reporterKey.text == '' ||
                            reporterKey.text == ' ') {
                          // ignore: unused_local_variable
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: email.text,
                            password: password.text,
                          );

                          adduser();
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.success,
                            body: const Center(
                              child: Text(
                                'Success ! Now You Can Log In ',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            title: 'Success',
                            btnOkColor: pColor,
                            btnOkOnPress: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }));
                            },
                          ).show();
                        } else {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.error,
                            body: const Center(
                              child: Text(
                                'wrong reporter key .. dont write any reporter key if you dont have ',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            title: 'Wrong Key',
                            btnOkColor: pColor,
                            btnOkOnPress: () {},
                          ).show();
                        }
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
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Text(
                      'REGISTER',
                      style: TextStyle(color: pColor),
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'back to',
                    style: TextStyle(color: Colors.white54),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }));
                    },
                    child: Text(
                      'log in page',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
