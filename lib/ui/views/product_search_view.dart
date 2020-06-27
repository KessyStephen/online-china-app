import 'package:flutter/material.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
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
    return BaseView<ProductModel>(
        model: ProductModel(productService: Provider.of(context)),
        onModelReady: (model) => model.clearSearchData(),
        builder: (context, model, child) => Scaffold(
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(
                              left: 18.0, right: 18.0, top: 10),
                          itemCount: model.searchedProducts == null
                              ? 0
                              : model.searchedProducts.length,
                          shrinkWrap: false,
                          itemBuilder: (BuildContext context, int index) {
                            Product product = model.searchedProducts[index];

                            return ProductListItem(
                              title: product.name,
                              price: product.priceLabel,
                              imageUrl: "https://onlinechina.co/logo.png",
                              hideQuantityInput: false,
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ));
  }
}
