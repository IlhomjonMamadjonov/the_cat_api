import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ZoomPage extends StatelessWidget {
  String url;
  int idImage;

  ZoomPage({Key? key, required this.idImage, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "$idImage",
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5,
          child: CachedNetworkImage(
            imageUrl: url,
          ),
        ));
  }
}
