import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_cat_api/models/cat_model.dart';

class GridBuilder extends StatelessWidget {
  Cat cat;
  String? search;

  GridBuilder({Key? key, required this.cat, this.search}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// #Post image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: cat.url,
              placeholder: (context, url) => AspectRatio(
                aspectRatio: cat.width / cat.height,
                child: Container(
                  color: Colors.grey.shade700,
                ),
              ),
              errorWidget: (context, url, error) => AspectRatio(
                aspectRatio: cat.width / cat.height,
                child: Container(color: Colors.grey.shade700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
