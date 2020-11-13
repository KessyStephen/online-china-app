import 'package:flutter/material.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/helpers/lang_utils.dart';
import 'package:online_china_app/core/helpers/shared_prefs.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:provider/provider.dart';

import '../base_widget.dart';

class CurrencyListView extends StatefulWidget {
  @override
  _CurrencyListViewState createState() => _CurrencyListViewState();
}

class _CurrencyListViewState extends State<CurrencyListView> {
  int page = 2;
  bool showLoading = true;
  String selectedCurrency = DEFAULT_CURRENCY;

  @override
  Widget build(BuildContext context) {
    return BaseView<ProductModel>(
      model: ProductModel(productService: Provider.of(context)),
      onModelReady: (model) async {
        model.getCurrencies(perPage: PER_PAGE_COUNT);

        // selected currency
        var tmpCurrency = await LangUtils.getSelectedCurrency();
        setState(() {
          selectedCurrency = tmpCurrency;
        });
      },
      builder: (context, model, child) => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(title: Text("Select Currency")),
        body: SafeArea(
          child: model.state == ViewState.Busy
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : InfiniteListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  itemBuilder: (context, index) {
                    var val = model.currencies[index];

                    return ListTile(
                      // leading: Icon(Icons.trending_down),
                      title: Text(
                        val.currency,
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: Icon(
                        Icons.check,
                        color: selectedCurrency == val.code
                            ? primaryColor
                            : Colors.transparent,
                      ),
                      onTap: () async {
                        await SharedPrefs.setString(
                            SELECTED_CURRENCY_KEY, val.code);
                        Navigator.pushNamedAndRemoveUntil(
                            context, "/home", (Route<dynamic> route) => false,
                            arguments: {"switchToIndex": 0});
                      },
                    );
                  },
                  itemCount: model.currencies != null
                      ? model.currencies.length
                      : 0, // Current itemCount you have
                  hasNext: model.currencies.length >= PER_PAGE_COUNT
                      ? this.showLoading
                      : false, // if we have fewer than requested, there is no next
                  nextData: () => this.loadNextData(
                      model), // callback called when end to the list is reach and hasNext is true
                  separatorBuilder: (context, index) => Divider(height: 1),
                ),
        ),
      ),
    );
  }

  void loadNextData(ProductModel model) async {
    bool flag = await model.getCurrencies(
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
