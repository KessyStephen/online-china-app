import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';

class CategoryListItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Function onPressed;

  const CategoryListItem({Key key, this.title, this.imageUrl, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        onTap: this.onPressed,
        leading: Container(
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
        title: Text(this.title != null ? this.title : ""),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
