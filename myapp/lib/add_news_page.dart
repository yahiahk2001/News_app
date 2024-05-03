import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/conests.dart';
import 'package:myapp/home.dart';
import 'package:path/path.dart';

class AddNewsPage extends StatefulWidget {
  const AddNewsPage({super.key});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  late TextEditingController news_text; 

  @override
  void initState() {
    super.initState();
    news_text = TextEditingController(); 
  }

  CollectionReference news = FirebaseFirestore.instance.collection('news');

  Future<void> addNews() {
    return news.add({
      'news_text': news_text.text,
      'image': url,
    });
  }

  File? image;
  String? url;
  final picker = ImagePicker();
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
         if (pickedFile != null) {
        image = File(pickedFile.path);
        var imageName=basename(pickedFile.path);
        var refStorge=FirebaseStorage.instance.ref('images').child(imageName);
       await refStorge.putFile(image!);
        url=await refStorge.getDownloadURL();   
      }
      setState(() {
      });
  }

  Future showOptions(BuildContext context) async {
    showCupertinoModalPopup(
      context: context,//error her
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              
              Navigator.of(context).pop();
              
              getImageFromGallery();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Image.asset(
                    'assits/IMG_9063.PNG',
                    height: 42,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: IconButton(
                    icon: Icon(
                      Icons.done,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      addNews();
                      try {
                           AwesomeDialog(
                        
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.success,
                        body: const Center(
                          child: Text(
                            'News added',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        title: 'Are You Sure',
                        btnOkColor: pColor,
                        
                        btnOkOnPress: () async {
                        
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return Home();
                          }));
                        },
                      ).show();
                      } catch (e) {
                        
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
            ),
            child: Column(
              children: [
                TextField(
                  style: TextStyle(color: Colors.white),
                  controller: news_text,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'News Text',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                ),
                Center(
                  child: image == null
                      ? Text('')
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Image.file(
                            image!,
                            fit: BoxFit.fill,
                            height: 300,
                          ),
                        ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
            showOptions(context); // تمرير context هنا
          },
            child: image == null
                ? Text(
                    'Choose Picture',
                    style: TextStyle(color: pColor),
                  )
                : Text(
                    'Choose Another Picture',
                    style: TextStyle(color: pColor),
                  ),
          ),
        ],
      ),
    );
  }
}
