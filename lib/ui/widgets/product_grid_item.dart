import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';

class ProductGridItem extends StatelessWidget {
  final String title;
  final String price;
  final String imageUrl;
  final Function onPressed;

  const ProductGridItem(
      {Key key, this.title, this.price, this.imageUrl, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        width: 180,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: this.imageUrl != null ? this.imageUrl : "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Image.asset(
                      PLACEHOLDER_IMAGE,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              child: Text(
                "Samsung A20 QUAD CORE Processor 2019/2020",
                style: TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric( horizontal: 6),
              child: Text(
                this.price != null ? this.price : "",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
