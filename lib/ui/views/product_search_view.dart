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
  String sort = "";
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
              endDrawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Sort',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('Done',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor)),
                          )
                        ],
                      ),
                    ),
                    Divider(),
                    Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.trending_down),
                          title: Text(
                            'High to Low',
                            style: TextStyle(fontSize: 16),
                          ),
                          // trailing: Icon(
                          //   Icons.check_circle,
                          //   color: Colors.green,
                          // ),
                          onTap: () {
                            this.sort = "price:desc";
                            model.searchProducts(
                                query: _queryController.text,
                                sort: this.sort,
                                perPage: PER_PAGE_COUNT);
                            Navigator.pop(context);
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.trending_up),
                          title: Text(
                            'Low to High',
                            style: TextStyle(fontSize: 16),
                          ),
                          // trailing: Icon(
                          //   Icons.check_circle,
                          //   color: Colors.grey,
                          // ),
                          onTap: () {
                            this.sort = "price:asc";

                            model.searchProducts(
                                query: _queryController.text,
                                sort: this.sort,
                                perPage: PER_PAGE_COUNT);
                            Navigator.pop(context);
                          },
                        ),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.access_time),
                          title: Text(
                            'Newly Listed',
                            style: TextStyle(fontSize: 16),
                          ),
                          // trailing: Icon(
                          //   Icons.check_circle,
                          //   color: Colors.grey,
                          // ),
                          onTap: () {
                            this.sort = "createdAt:desc";
                            model.searchProducts(
                                query: _queryController.text,
                                sort: this.sort,
                                perPage: PER_PAGE_COUNT);
                            Navigator.pop(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              // appBar: AppBar(title: Text("Search")),
              body: Builder(
                builder: (context) => Column(
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
                                      sort: this.sort,
                                      query: _queryController.text);
                                }
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (_queryController.text.isNotEmpty) {
                                model.searchProducts(
                                    sort: this.sort,
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
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(4),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Sort',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.sort,
                                              color: primaryColor,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          model.setIsSort(true);
                                          Scaffold.of(context).openEndDrawer();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Expanded(
                                  flex: 1,
                                  child: InfiniteGridView(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2),
                                    itemBuilder: (context, index) {
                                      Product product =
                                          model.searchedProducts[index];
                                      return ProductGridItem(
                                        title: product.name,
                                        price: product.priceLabel,
                                        minOrderQuantity: product.minOrderLabel,
                                        imageUrl: product.thumbnail,
                                        onPressed: () => Navigator.pushNamed(
                                            context, "/product_detail",
                                            arguments: {
                                              "productId": product.id
                                            }),
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
                  ],
                ),
              ),
            ));
  }

  void loadNextData(ProductModel model) async {
    bool flag = await model.searchProducts(
        query: this._queryController.text,
        hideLoading: true,
        sort: this.sort,
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
