import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';

class CategoryGridItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Function onPressed;

  const CategoryGridItem({Key key, this.title, this.imageUrl, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        width: 64,
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 64,
              width: 64,
              margin: EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.all(10.0),
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: CachedNetworkImage(
                imageUrl: this.imageUrl != null ? this.imageUrl : "",
                fit: BoxFit.contain,
                placeholder: (context, url) => Image.asset(
                  PLACEHOLDER_IMAGE,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Text(
              this.title,
              style: const TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
