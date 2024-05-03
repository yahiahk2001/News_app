import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/conests.dart';
import 'package:myapp/logIn_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool switchData = false;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  getUsers() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        userData = querySnapshot.docs.first.data();
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? CircularProgressIndicator(color: Colors.white,) 
        : Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 88,
                        color: Colors.white,
                      ),
                      Text(
                        userData?['name'] ?? ' ', // تحديث الاسم هنا
                        style: TextStyle(fontSize: 22, color: Colors.white70),
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(Colors.white)),
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.question,
                            body: const Center(
                              child: Text(
                                'Are You Sure ? ',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                           
                            btnOkColor: pColor,
                            btnOkOnPress: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginPage();
                              }));
                            },
                          ).show();
                        },
                        child: Text('Log Out'),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    CostomInfo(
                      text: ' dark mode',
                      icon: Icons.dark_mode,
                      button: Switch(
                        value: switchData,
                        onChanged: (t) {
                          setState(() {
                            switchData = t;
                          });
                        },
                      ),
                    ),
                    CostomInfo(
              text: '  share application',
              icon: Icons.share,
              button: IconButton(
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.share,
                  color: Colors.white70,
                ),
              ),
            ),
            CostomInfo(
              text: '  connect with us',
              icon: FontAwesomeIcons.connectdevelop,
              button: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.call,
                  color: Colors.white70,
                ),
              ),
            ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
                  width: 112,
                  child: Image.asset('assits/IMG_9063.PNG'),
                ),
              ],
            ),
          );
  }
}

// ignore: must_be_immutable
class CostomInfo extends StatelessWidget {
  CostomInfo({
    super.key,
    required this.text,
    required this.icon,
    required this.button,
  });

  String text;
  IconData icon;
  Widget button;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 54,
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Spacer(
              flex: 1,
            ),
            Icon(
              icon,
              color: Colors.white70,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            Spacer(
              flex: 8,
            ),
            button,
            Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
