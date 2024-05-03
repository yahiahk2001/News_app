import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/API_news_page.dart';
import 'package:myapp/classes.dart';
import 'package:myapp/home.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List news_firebase = [];
  static List<News> news = [];
  bool isLoading = false;

  getNews() async {
    setState(() {
      isLoading = true; // Set isLoading to true when fetching data
    });
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('news').get();
    news_firebase = querySnapshot.docs;
    setState(() {
      news.clear();
      for (var i = 0; i < news_firebase.length; i++) {
        News n = News(
          news_text: news_firebase[i]['news_text'],
          image: news_firebase[i]['image']??('https://salonlfc.com/wp-content/uploads/2018/01/image-not-found-1-scaled-1150x647.png'),
          category: null,
          sorce: null,
        );
        news.add(n);
      }
      isLoading = false; // Set isLoading to false when data is fetched
    });
  }

  @override
  void initState() {
    super.initState();
    getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Image.asset(
                  'assits/IMG_9063.PNG',
                  height: 42,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white70,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return Home();
                    }));
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child:
                        CircularProgressIndicator(color: Colors.white,)) // Show CircularProgressIndicator while loading
                : ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (BuildContext context, int index) {
                      return NewsCard(
                        title: news[index].news_text,
                        image: news[index].image,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
