import 'package:flutter/material.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/product_grid_item.dart';
import 'package:online_china_app/ui/widgets/search_bar.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class ProductSearchView extends StatefulWidget {
  @override
  _ProductSearchViewState createState() => _ProductSearchViewState();
}

class _ProductSearchViewState extends State<ProductSearchView> {
  final _queryController = TextEditingController();
  int page = 2;
  bool showLoading = true;

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
                              autofocus: true,
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
                            onPressed: () {
                              if (_queryController.text.isNotEmpty) {
                                model.searchProducts(
                                    query: _queryController.text);
                                FocusScope.of(context).unfocus();
                              }
                            },
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
                    model.state == ViewState.Busy
                        ? Expanded(
                            flex: 1,
                            child: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              ),
                            ),
                          )
                        : Expanded(
                            flex: 1,
                            child: InfiniteGridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                Product product = model.searchedProducts[index];
                                return ProductGridItem(
                                  title: product.name,
                                  price: product.priceLabel,
                                  minOrderQuantity: product.minOrderQuantity,
                                  imageUrl: product.thumbnail,
                                  onPressed: () => Navigator.pushNamed(
                                      context, "/product_detail",
                                      arguments: {"productId": product.id}),
                                );
                              },
                              itemCount: model.searchedProducts == null
                                  ? 0
                                  : model.searchedProducts
                                      .length, // Current itemCount you have
                              hasNext: model.searchedProducts.length >=
                                      PER_PAGE_COUNT
                                  ? this.showLoading
                                  : false, // if we have fewer than requested, there is no next
                              nextData: () {
                                this.loadNextData(model);
                              }, // callback called when end to the list is reach and hasNext is true
                            ),
                          ),
                  ],
                ),
              ),
            ));
  }

  void loadNextData(ProductModel model) async {
    bool flag = await model.searchProducts(
        query: this._queryController.text,
        hideLoading: true,
        page: this.page,
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
