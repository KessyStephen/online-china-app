import 'package:flutter/material.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/favorite.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/widgets/product_grid_item.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class FavoriteListView extends StatefulWidget {
  @override
  _FavoriteListViewState createState() => _FavoriteListViewState();
}

class _FavoriteListViewState extends State<FavoriteListView> {
  int page = 2;
  bool showLoading = true;

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> params =
    //     ModalRoute.of(context).settings.arguments;
    // Category parentCategory = params != null ? params['parentCategory'] : null;

    return BaseView<ProductModel>(
      model: ProductModel(productService: Provider.of(context)),
      onModelReady: (model) async {
        model.getFavorites(perPage: PER_PAGE_COUNT);
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: Text("Wishlist")),
        body: SafeArea(
          child: model.state == ViewState.Busy
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : InfiniteGridView(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    // crossAxisCount: 2,
                    maxCrossAxisExtent: 230.0,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    Favorite favorite = model.favorites[index];

                    //handle no product
                    if (favorite == null || favorite.product == null) {
                      return ProductGridItem(
                        title: "",
                        price: "",
                        imageUrl: "",
                      );
                    }

                    Product product = favorite.product;
                    return ProductGridItem(
                      title: product.name,
                      price: product.priceLabel,
                      minOrderQuantity: product.minOrderLabel,
                      imageUrl: product.thumbnail,
                      onPressed: () => Navigator.pushNamed(
                          context, "/product_detail",
                          arguments: {"productId": product.id}),
                    );
                  },
                  itemCount: model.favorites != null
                      ? model.favorites.length
                      : 0, // Current itemCount you have
                  hasNext: model.favorites.length >= PER_PAGE_COUNT
                      ? this.showLoading
                      : false, // if we have fewer than requested, there is no next
                  nextData: () {
                    this.loadNextData(model);
                  }, // callback called when end to the list is reach and hasNext is true
                ),
        ),
      ),
    );
  }

  void loadNextData(ProductModel model) async {
    bool flag = await model.getFavorites(
        hideLoading: true, page: this.page, perPage: PER_PAGE_COUNT);
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
