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
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        onTap: this.onPressed,
        leading: Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black54, width: 1.0)),
            child: CachedNetworkImage(
              imageUrl: this.imageUrl != null ? this.imageUrl : "",
              fit: BoxFit.contain,
              placeholder: (context, url) => Image.asset(
                PLACEHOLDER_IMAGE,
                fit: BoxFit.contain,
              ),
            )),
        title: Text(this.title != null ? this.title : ""),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
