import 'dart:io';
import 'package:flutter/material.dart';
import 'package:the_cat_api/pages/main_page.dart';
import 'package:the_cat_api/services/http_service.dart';
import 'package:the_cat_api/services/util_service.dart';

class UploadPage extends StatefulWidget {
  static String id = "/upload_page";
  File? file;

  UploadPage({this.file, Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool isLoading = false;

  void upload() async {
    setState(() {
      isLoading=true;
    });
    Network.MULTIPART(Network.API_UPLOAD, widget.file!.path,
            Network.bodyUpload(widget.file!.hashCode.toString()))
        .then((value) {
      if (value != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainPage()),
            (route) => route.isFirst);
        setState(() {
          isLoading=false;
        });
      } else {
        Utils.fireSnackBar("Something error", context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: FileImage(widget.file!),
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
                MaterialButton(
                  onPressed: () {
                    upload();
                    Utils.fireSnackBar(
                        "Please wait your image is uploading...", context);
                  },
                  child: Text("Upload"),
                  textColor: Colors.white,
                  shape: StadiumBorder(),
                  height: 55,
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.blueAccent,
                ),
              ],
            ),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
