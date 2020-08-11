import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/viewmodels/views/product_model.dart';
import 'package:online_china_app/ui/base_widget.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/big_button_outline.dart';
import 'package:online_china_app/ui/widgets/product_option_list_item.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:provider/provider.dart';

class ProductOptionsModal extends StatelessWidget {
  final Function onAddToCart;
  final Function onBuyNow;
  final Function onQuantityChange;
  final Product product;
  final ProductAction action;

  const ProductOptionsModal(
      {Key key,
      this.onAddToCart,
      this.onBuyNow,
      this.onQuantityChange,
      this.product,
      this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double heightFull = MediaQuery.of(context).size.height;

    // height without SafeArea
    var padding = MediaQuery.of(context).padding;
    double height = heightFull - padding.top - padding.bottom;

    return BaseView<ProductModel>(
      model: ProductModel(productService: Provider.of(context)),
      onModelReady: (model) {},
      builder: (context, model, child) => Container(
        height: height,
        // color: Colors.white,
        padding: EdgeInsets.all(16),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Options',
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    FontAwesome.times,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
            Expanded(
              flex: 1,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: product != null && product.variations != null
                    ? product.variations.length
                    : 0,
                itemBuilder: (context, index) {
                  var variation = product.variations[index];
                  return ProductOptionListItem(
                      title: variation.attributesLabel,
                      price: variation.priceLabel,
                      quantity: variation.quantity,
                      onQuantityChanged: (value) {
                        product.setVariationQuantity(index, value);
                        model.setState(ViewState.Idle);
                      },
                      addItem: () {
                        //this.onQuantityChange(index, 1);
                        product.increaseVariationQuantity(index, 1);
                        model.setState(ViewState.Idle);
                      },
                      removeItem: () {
                        // this.onQuantityChange(index, -1);
                        product.increaseVariationQuantity(index, -1);
                        model.setState(ViewState.Idle);
                      });
                },
              ),
            ),
            Container(
              //color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total Amount",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    product?.variationsTotalPrice?.toStringAsFixed(2),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: BigButtonOutline(
                    buttonTitle: 'CANCEL',
                    functionality: () {
                      Get.back();
                    },
                  ),
                ),
                if (this.action != ProductAction.None)
                  SizedBox(
                    width: 20,
                  ),
                if (this.action == ProductAction.AddToItems)
                  Expanded(
                    flex: 1,
                    child: BigButton(
                        color: product.variationsItemCount > 0
                            ? primaryColor
                            : Colors.grey,
                        buttonTitle: 'ADD TO ITEMS',
                        functionality: () {
                          if (product.variationsItemCount > 0) {
                            Get.back();
                            if (this.onAddToCart != null) {
                              this.onAddToCart();
                            }
                          }
                        }),
                  ),
                if (this.action == ProductAction.BuyNow)
                  Expanded(
                    flex: 1,
                    child: BigButton(
                        color: product.variationsItemCount > 0
                            ? primaryColor
                            : Colors.grey,
                        buttonTitle: 'BUY NOW',
                        functionality: () {
                          if (product.variationsItemCount > 0) {
                            Get.back();
                            if (this.onBuyNow != null) {
                              this.onBuyNow();
                            }
                          }
                        }),
                  ),
                if (this.action == ProductAction.Update)
                  Expanded(
                    flex: 1,
                    child: BigButton(
                        color: primaryColor,
                        buttonTitle: 'UPDATE',
                        functionality: () {
                          Get.back();
                          if (this.onAddToCart != null) {
                            this.onAddToCart();
                          }
                        }),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
