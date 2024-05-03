class News{
  String news_text;
  String? sorce;
  String ?category;
  String image;

  News({required this.news_text,required this.image, this.category, this.sorce});

}

class Users{
  String email;
  String name;
  bool isReporter;

  Users({required this.email,required this.name,required this.isReporter});
}