import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';

class ProductGridItem extends StatelessWidget {
  final String title;
  final String price;
  final String minOrderQuantity;
  final String imageUrl;
  final Function onPressed;

  const ProductGridItem(
      {Key key,
      this.title,
      this.price,
      this.minOrderQuantity,
      this.imageUrl,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        width: 200,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(16))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 120),
                  child: CachedNetworkImage(
                    imageUrl: this.imageUrl != null ? this.imageUrl : "",
                    fit: BoxFit.fill,
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
                this.title != null ? this.title : "",
                style: TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
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
            if (this.minOrderQuantity != null)
              Padding(
                padding: const EdgeInsets.only(left: 6, right: 6, top: 4),
                child: Text(
                  this.minOrderQuantity != null
                      ? "Min. Order: " + this.minOrderQuantity.toString()
                      : "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
