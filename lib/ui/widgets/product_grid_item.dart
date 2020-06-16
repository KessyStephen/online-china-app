import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
        width: 150,
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 150,
              width: 150,
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54, width: 1.0)),
              child: CachedNetworkImage(
                imageUrl: this.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(this.title, style: TextStyle(fontSize: 14)),
            ),
            Text(
              this.price,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
