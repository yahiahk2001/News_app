import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:myapp/home.dart';
import 'package:myapp/logIn_page.dart';

void main() async {
 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyCvoprF7LFW2RoJtswJvVOKrpseRj0ArLg',
    appId: '1:329105192244:android:07514b05159850dee16161',
    messagingSenderId: '329105192244',
    projectId: 'newsapp-fb1f8',
  ));
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {

    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      home: FirebaseAuth.instance.currentUser == null ? LoginPage() : Home(),
    );
  }
}
