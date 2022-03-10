import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:the_cat_api/models/cat_model.dart';
import 'package:the_cat_api/pages/grid_builder_page.dart';
import 'package:the_cat_api/pages/zoom_page.dart';
import '../services/http_service.dart';

class HomePage extends StatefulWidget {
  static const String id = "/home_page";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = true;
  bool loading = false;
  List<Cat> cats = [];
  int length = 0;
  final PageController _controller = PageController();
  int _selectedIndex = 0;
  int pageNumber = 0;

  @override
  void initState() {
    super.initState();
    _loadPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          loading = true;
          _loadPosts();
        });
      }
    });
  }

  void showResponse(String response) {
    setState(() {
      isLoading = false;
      loading = false;
      if (response != null && cats.isEmpty) {
        cats = Network.parseResponse(response);
      } else if (response != null) {
        cats.addAll(Network.parseResponse(response));
      }
    });
  }

  void _loadPosts() async {
    setState(() {
      pageNumber += 1;
    });
    await Network.GET(Network.API_LIST, Network.paramsPage(pageNumber))
        .then((response) => {showResponse(response!)});
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation(Colors.black),
              ),
            )
          : WillPopScope(
              onWillPop: () async {
                if (_selectedIndex != 0) {
                  setState(() {
                    --_selectedIndex;
                    _controller.jumpToPage(_selectedIndex);
                  });
                  return false;
                } else {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else {
                    exit(0);
                  }
                  return false;
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 35, bottom: 10),
                    height: 80,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.16,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.black,
                      ),
                      child: const Text(
                        "All",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      backgroundColor: Colors.cyan,
                      edgeOffset: 2.90,
                      color: Colors.tealAccent,
                      onRefresh: () async {
                        setState(() {
                          cats.shuffle();
                        });
                      },
                      child: MasonryGridView.count(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: cats.length,
                          crossAxisCount: 2,
                          mainAxisSpacing: 11,
                          crossAxisSpacing: 10,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              ZoomPage(
                                                  idImage: index,
                                                  url: cats[index].url),
                                          transitionDuration:
                                              Duration(milliseconds: 400),
                                          transitionsBuilder: (context,
                                              animation, animation2, child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          fullscreenDialog: true));
                                },
                                child: Hero(
                                    tag: '$index',
                                    // transitionOnUserGestures:true,
                                    child: GridBuilder(cat: cats[index])));
                          }),
                    ),
                  ),
                  if (loading)
                    const SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                ],
              ),
            ),
    );
  }
}
