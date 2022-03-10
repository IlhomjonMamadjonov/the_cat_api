import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_cat_api/pages/search_page.dart';
import 'package:the_cat_api/pages/upload_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  static const String id = "/main_page";

  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController controller = PageController();
  File? _image;

  void getImage() async {
    var result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        _image = File(result.path);
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadPage(
                    file: _image,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: false,
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          HomePage(),
          SearchPage(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.cyan,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4,
        color: Colors.indigoAccent,
        child: Container(
          height: 65,
          child: Row(
            //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  controller.animateToPage(0,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  controller.animateToPage(1,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
