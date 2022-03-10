import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:the_cat_api/models/breed_model.dart';
import 'package:the_cat_api/models/cat_model.dart';
import 'package:the_cat_api/pages/grid_builder_page.dart';
import 'package:the_cat_api/pages/zoom_page.dart';
import 'package:the_cat_api/services/http_service.dart';

import '../services/util_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const String id = "/search_page";

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool isTyping = false;
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  List<Cat> cats = [];
  String text = "";

  void _search() async {
    text = controller.text.trim().toString();
    if (text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await Network.GET(
              Network.API_SEARCH_BREED, Network.paramsBreedSearch(text))
          .then(getCategories);
      setState(() {
        isLoading = false;
      });
    } else {
      Utils.fireSnackBar("Please enter some text to search!", context);
    }
  }

  void getCategories(String? response) async {
    setState(() {
      isLoading = true;
    });
    if (response != null) {
      List<Breeds> list = Network.parseSearchBreed(response);
      String? breedId;
      for (int i = 0; i < list.length; i++) {
        if (list[i].name.toLowerCase().startsWith(text.toLowerCase())) {
          breedId = list[i].id;
          break;
        }
      }

      await Network.GET(
              Network.API_LIST, Network.paramsSearch(breedId ?? "", 0))
          .then(getSearchCats);
    } else {
      Utils.fireSnackBar("Internal Server Error", context);
    }
    setState(() {
      isLoading = false;
    });
  }

  void getSearchCats(String? response) {
    if (response != null) {
      setState(() {
        cats = Network.parseResponse(response);
      });
    } else {
      Utils.fireSnackBar("Not found this breed of cat", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Stack(
          children: [
            // #body
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // #search
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.only(left: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: TextField(
                                textInputAction: TextInputAction.search,
                                controller: controller,
                                style: const TextStyle(fontSize: 18),
                                onSubmitted: (text) {
                                  setState(() {
                                    isTyping = false;
                                    _search();
                                  });
                                },
                                onTap: () {
                                  setState(() {
                                    isTyping = true;
                                  });
                                },
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: !isTyping
                                        ? const Icon(
                                            Icons.search,
                                            color: Colors.black,
                                            size: 30,
                                          )
                                        : null,
                                    suffixIcon: const Icon(
                                      CupertinoIcons.camera_fill,
                                      color: Colors.black,
                                    ),
                                    hintText: "Search by breeds",
                                    hintStyle: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          isTyping
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      isTyping = false;
                                      cats.clear();
                                      controller.clear();
                                    });
                                  },
                                  child: const Text(
                                    " Cancel",
                                    style: TextStyle(fontSize: 17),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),

                    // #gridview
                    MasonryGridView.count(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      itemCount: cats.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      itemBuilder: (context, index) {
                        return  InkWell(
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
                      },
                    ),
                  ],
                ),
              ),
            ),

            // #indicator
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
