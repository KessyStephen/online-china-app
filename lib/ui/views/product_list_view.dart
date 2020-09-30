import 'package:flutter/material.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/category.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/product_grid_item.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class ProductListView extends StatefulWidget {
  @override
  _ProductListViewState createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  String sort = "";
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      model.getProducts(
                          categoryIds: parentCategory.id,
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
                      model.getProducts(
                          categoryIds: parentCategory.id,
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
                      model.getProducts(
                          categoryIds: parentCategory.id,
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
        appBar: AppBar(
          title: Text(parentCategory.name),
          actions: <Widget>[Container()],
        ),
        body: Builder(
          builder: (context) => model.state == ViewState.Busy
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : Column(
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
                          // Text(
                          //   ' | ',
                          //   style: TextStyle(fontSize: 20),
                          // ),
                          // InkWell(
                          //   child: Row(
                          //     children: <Widget>[
                          //       Text(
                          //         'Filter',
                          //         style: TextStyle(fontSize: 16),
                          //       ),
                          //       SizedBox(
                          //         width: 5,
                          //       ),
                          //       Icon(Icons.filter_list, color: primaryColor),
                          //     ],
                          //   ),
                          //   onTap: () {
                          //     model.setIsSort(false);
                          //     Scaffold.of(context).openEndDrawer();
                          //   },
                          // )
                        ],
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: InfiniteGridView(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          // crossAxisCount: 2,
                          maxCrossAxisExtent: 230.0,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          Product product = model.products[index];
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
                  ],
                ),
        ),
      ),
    );
  }

  void loadNextData(ProductModel model, dynamic categoryIds) async {
    bool flag = await model.getProducts(
        hideLoading: true,
        sort: this.sort,
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
