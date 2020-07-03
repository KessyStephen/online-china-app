import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/product_grid_item.dart';
import 'package:online_china_app/ui/widgets/product_list_item.dart';
import 'package:online_china_app/ui/widgets/search_bar.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class ProductSearchView extends StatefulWidget {
  @override
  _ProductSearchViewState createState() => _ProductSearchViewState();
}

class _ProductSearchViewState extends State<ProductSearchView> {
  final _queryController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double gridWidth = width / 2 - 18;
    double gridAspectRatio = gridWidth / (gridWidth + 20);

    return BaseView<ProductModel>(
        model: ProductModel(productService: Provider.of(context)),
        onModelReady: (model) => model.clearSearchData(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              // appBar: AppBar(title: Text("Search")),
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding:
                          const EdgeInsets.only(top: 5, bottom: 5, right: 5),
                      color: primaryColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SearchBar(
                              controller: _queryController,
                              onSubmitPressed: () {
                                if (_queryController.text != null &&
                                    _queryController.text.isNotEmpty) {
                                  model.searchProducts(
                                      query: _queryController.text);
                                }
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () => model.searchProducts(
                                query: _queryController.text),
                            icon: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: gridAspectRatio,
                          shrinkWrap: true,
                          children: List.generate(
                              model.searchedProducts == null
                                  ? 0
                                  : model.searchedProducts.length, (index) {
                            Product product = model.searchedProducts[index];
                            return ProductGridItem(
                              title: product.name,
                              price: product.priceLabel,
                              imageUrl: product.thumbnail,
                              onPressed: () => Navigator.pushNamed(
                                  context, "/product_detail",
                                  arguments: product),
                            );
                          })),
                    ),
                  ],
                ),
              ),
            ));
  }
}
