import 'package:flutter/material.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/widgets/product_grid_item.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class ProductListView extends StatefulWidget {
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  int page = 2;
  bool showLoading = true;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    Category parentCategory = params != null ? params['parentCategory'] : null;

    return BaseView<ProductModel>(
      model: ProductModel(productService: Provider.of(context)),
      onModelReady: (model) async {
        model.getProducts(
            categoryIds: parentCategory.id, perPage: PER_PAGE_COUNT);
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: Text(parentCategory.name)),
        body: SafeArea(
          child: InfiniteGridView(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              Product product = model.products[index];
              return ProductGridItem(
                title: product.name,
                price: product.priceLabel,
                imageUrl: product.thumbnail,
                onPressed: () => Navigator.pushNamed(context, "/product_detail",
                    arguments: product),
              );
            },
            itemCount: model.products != null
                ? model.products.length
                : 0, // Current itemCount you have
            hasNext: model.products.length >= PER_PAGE_COUNT
                ? this.showLoading
                : false, // if we have fewer than requested, there is no next
            nextData: () {
              this.loadNextData(model, parentCategory.id);
            }, // callback called when end to the list is reach and hasNext is true
          ),
        ),
      ),
    );
  }

  void loadNextData(ProductModel model, dynamic categoryIds) async {
    bool flag = await model.getProducts(
        hideLoading: true,
        page: this.page,
        categoryIds: categoryIds,
        perPage: PER_PAGE_COUNT);
    if (flag) {
      setState(() {
        this.page++;
      });
    } else {
      setState(() {
        this.showLoading = false;
      });
    }
  }
}
