import 'package:flutter/material.dart';
import 'package:the_cat_api/pages/detail_page.dart';
import 'package:the_cat_api/pages/home_page.dart';
import 'package:the_cat_api/pages/main_page.dart';
import 'package:the_cat_api/pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Api',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        DetailPage.id: (context) => DetailPage(),
        SearchPage.id: (context) => SearchPage(),
        MainPage.id: (context) => MainPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
