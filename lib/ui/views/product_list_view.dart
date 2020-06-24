import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/widgets/category_list_item.dart';
import 'package:online_china_app/ui/widgets/product_grid_item.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class ProductListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    Category parentCategory = params != null ? params['parentCategory'] : null;
    return BaseView<ProductModel>(
        model: ProductModel(productService: Provider.of(context)),
        onModelReady: (model) async {
          model.getProducts(categoryIds: parentCategory.id);
        },
        builder: (context, model, child) => Scaffold(
              appBar: AppBar(title: Text(parentCategory.name)),
              body: SafeArea(
                child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(model.products.length, (index) {
                      Product product = model.products[index];
                      return ProductGridItem(
                        title: product.name,
                        price: product.priceLabel,
                        imageUrl: "https://onlinechina.co/logo.png",
                        onPressed: () => Navigator.pushNamed(
                            context, "/product_detail",
                            arguments: product),
                      );
                    })),

                // child: ListView.builder(
                //     itemCount:
                //         model.products == null ? 0 : model.products.length,
                //     shrinkWrap: false,
                //     itemBuilder: (BuildContext context, int index) {
                //       Product product = model.products[index];

                //       return CategoryListItem(
                //         title: product.name,
                //         imageUrl: "https://onlinechina.co/logo.png",

                //       );
                //     }),
              ),
            ));
  }
}
