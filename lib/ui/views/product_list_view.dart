import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/widgets/product_grid_item.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class ProductListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    Category parentCategory = params != null ? params['parentCategory'] : null;

    double width = MediaQuery.of(context).size.width;
    double gridWidth = width / 2 - 18;
    double gridAspectRatio = gridWidth / (gridWidth + 20);

    return BaseView<ProductModel>(
      model: ProductModel(productService: Provider.of(context)),
      onModelReady: (model) async {
        model.getProducts(categoryIds: parentCategory.id);
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: Text(parentCategory.name)),
        body: SafeArea(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: gridAspectRatio,
            shrinkWrap: true,
            children: List.generate(model.products.length, (index) {
              Product product = model.products[index];
              return ProductGridItem(
                title: product.name,
                price: product.priceLabel,
                imageUrl: product.thumbnail,
                onPressed: () => Navigator.pushNamed(context, "/product_detail",
                    arguments: product),
              );
            }),
          ),
        ),
      ),
    );
  }
}
