import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/API_news_page.dart';
import 'package:myapp/add_news_page.dart';
import 'package:myapp/classes.dart';
import 'package:myapp/conests.dart';
import 'package:myapp/database_news_page.dart';
import 'package:myapp/setting_page.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {


  
  int selectedIndix = 1;
  List news_firebase = [];
    static List<News> news = [];
getNews() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('news').get();
  news_firebase = querySnapshot.docs;
  setState(() {
    for (var i = 0; i < news_firebase.length; i++) {
      News n = News(
          news_text: news_firebase[i]['news_text'],
          image: news_firebase[i]['image'],
          category: null,
          sorce: null);
      news.add(n);
    }
  });
}


  void onItemTapped(int index) {
    setState(() {
      selectedIndix = index;
    });
  }
  List<Widget> pages = <Widget>[ApiNewsPage(), NewsPage(), SettingsPage()];

bool isReporter=false; 
var reportersIDs=[];
checkUser()async{
          QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').where('isReporter',isEqualTo: true).get();
   var reporters = querySnapshot.docs;
for (var i = 0; i < reporters.length; i++) {
  reportersIDs.add(reporters[i]['id']);
}
isReporter= reportersIDs.contains(FirebaseAuth.instance.currentUser!.uid);
    }

    @override
  void initState() {
    checkUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:isReporter? FloatingActionButton(
        child: Icon(Icons.add),
        
        onPressed: (){
         Navigator.push(context,    MaterialPageRoute(builder: (context) {
                          return AddNewsPage();
                        }));
      }):null,
      backgroundColor: pColor,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        iconSize: 18,
        selectedFontSize: 12,
        selectedIconTheme: IconThemeData(color: Colors.white, size: 30),
        selectedItemColor: Colors.white,
        backgroundColor: Colors.black12,
        elevation: 20,
        onTap: onItemTapped,
        currentIndex: selectedIndix,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.newspaper),
            label: 'Public News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded),
            label: 'Reporter News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: pages.elementAt(selectedIndix),
      ),
    );
  }
}
