import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:myapp/home.dart';

class ApiNewsPage extends StatefulWidget {
  const ApiNewsPage({super.key});

  @override
  State<ApiNewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<ApiNewsPage> {
  Map news_API = Map();
  bool isLoading = false; // Add isLoading state

  getNewsApi({my_search}) async {
    setState(() {
      isLoading = true; // Set isLoading to true when fetching data
    });
    final dio = Dio();
    String apiKey = 'pub_415910e92c0a24e9c8483d147a6c0f8dd8ff8';
    if (my_search==null) {
      my_search='العراق';
    }
    final response = await dio.get(
        'https://newsdata.io/api/1/news?apikey=$apiKey&q=%D8%A7%D9%84%D8%B9%D8%B1%D8%A7%D9%82');

    if (response.data != null) {
      setState(() {
        news_API = response.data;
        isLoading = false; // Set isLoading to false when data is fetched
      });
    } else {
      setState(() {
        isLoading = false; // Set isLoading to false in case of error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getNewsApi();
  
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
                ? Center(child: CircularProgressIndicator(color: Colors.white,)) // Show CircularProgressIndicator while loading
                : ListView.builder(
              itemCount: news_API['results'] != null ? news_API['results'].length : 0,

              itemBuilder: (BuildContext context, int index) {

                return NewsCard(
                  title: news_API['results'][index]['title'],
                  image: news_API['results'][index]['image_url'] ?? 'https://i.pinimg.com/originals/ae/8a/c2/ae8ac2fa217d23aadcc913989fcc34a2.png',

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class NewsCard extends StatelessWidget {
  NewsCard({super.key, required this.title, required this.image});
  String title;
  dynamic image; 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black26, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                title,
                style: TextStyle(color: Colors.white70),
              ),
            ),
            Container(
              // استخدام ال conditional operator للتحقق من نوع الصورة
              child: image is String
                  ? Image.network(
                      image,
                      fit: BoxFit.fill,
                      width: double.infinity,
                    )
                  : image, // إذا كانت الصورة من نوع Image، استخدمها مباشرة
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: LikeButton(
                    size: 20,
                    circleColor: const CircleColor(
                        start: Color.fromARGB(255, 64, 67, 67),
                        end: Color(0xff0099cc)),
                    bubblesColor: const BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        Icons.share,
                        color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                        size: 20,
                      );
                    },
                    likeCount: 0,
                  ),
                ),
                Spacer(),
                const Padding(
                  padding: EdgeInsets.all(6),
                  child: LikeButton(
                    size: 20,
                    circleColor: CircleColor(
                        start: Color(0xff00ddff), end: Color(0xff0099cc)),
                    bubblesColor: BubblesColor(
                      dotPrimaryColor: Color(0xff33b5e5),
                      dotSecondaryColor: Color(0xff0099cc),
                    ),
                    likeCount: 0,
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
