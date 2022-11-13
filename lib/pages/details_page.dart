import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/post_model.dart';
import '../services/prefs_service.dart';
import '../services/rtdb_service.dart';
import '../services/stor_service.dart';
class DetailsPage extends StatefulWidget {
  static const String id = "details_page";
  const DetailsPage({Key? key}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  var isLoading = false;

  File? _image;
  final picker = ImagePicker();

  var titleController = TextEditingController();
  var contentController = TextEditingController();
  var timeController = TextEditingController();

  _addPost() async{
    String title = titleController.text.toString();
    String content = contentController.text.toString();
    String time = timeController.text.toString();
    if(title.isEmpty || content.isEmpty || time.isEmpty) return;
    if(_image==null) return;

    _apiUploadImage(title, content, time);
  }

  void _apiUploadImage(String title,String content, String time) {
    setState((){
      isLoading = true;
    });

    StoreService.uploadImage(_image!).then((img_url) => {
      _apiAddPost(title, content, time, img_url!),
    });
  }

  _apiAddPost(String title, String content, String time, String img_url) async{
    var id = await Prefs.loadUserId();
    RTDBService.addPost(Post(id!, title, content, time, img_url)).then((response) => {
      _respAddPost(),
    });
  }

  _respAddPost(){
    setState((){
      isLoading = false;
    });
    Navigator.of(context).pop({"data":"done"});
  }

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bugungi vazifalar"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _getImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: _image != null ?
                      Image.file(_image!,fit: BoxFit.cover)
                          :Image.asset("assets/images/ic_camera.png",),
                    ),
                  ),
                  const SizedBox(height: 15,),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: "vazifa nomi",
                    ),
                  ),
                  const SizedBox(height: 15,),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      hintText: "batafsil",
                    ),
                  ),
                  const SizedBox(height: 15,),
                  TextField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      hintText: "ajratilgan vaqt",
                    ),
                  ),
                  const SizedBox(height: 15,),

                  Container(
                    width: double.infinity,
                    height: 45,
                    child: FlatButton(
                      onPressed: _addPost,
                      color: Colors.purple,
                      child: const Text("Vazifani qo'shish",style: TextStyle(color: Colors.white,),),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading ? const Center(
            child: CircularProgressIndicator(),
          ): const SizedBox.shrink(),
        ],
      ),
    );
  }
}
