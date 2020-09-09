import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/product.dart';
import 'package:online_china_app/core/viewmodels/views/order_model.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:provider/provider.dart';

import '../../base_widget.dart';

class OrderAddressView extends StatefulWidget {
  @override
  _OrderAddressViewState createState() => _OrderAddressViewState();
}

class _OrderAddressViewState extends State<OrderAddressView> {
  final _formKey = GlobalKey<FormState>();
  final _countryController = TextEditingController(text: "Tanzania");
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _streetController = TextEditingController();

  Future<void> _clearSampleRequest(OrderModel model) async {
    if (model.isSampleRequest == true) {
      await model.clearCartData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    List<Product> products = params != null ? params['items'] : null;
    double total = params != null ? params['total'] : null;

    return BaseView<OrderModel>(
      model: OrderModel(orderService: Provider.of(context)),
      onModelReady: (model) => {},
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          await _clearSampleRequest(model);
          return Future<bool>.value(true);
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () async {
                await _clearSampleRequest(model);
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 30,
              ),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Address',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Enter your shipping address',
                      style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        readOnly: true,
                        initialValue: "Tanzania",
                        //controller: _countryController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter country name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Country',
                            labelStyle: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _cityController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter city name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'City',
                            labelStyle: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _regionController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter region name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Region',
                            labelStyle: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _streetController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter street name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Street',
                            labelStyle: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
              ),
              model.state == ViewState.Busy
                  ? Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: BigButton(
                        buttonTitle: "Continue",
                        functionality: () async {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();

                            await model.updateShippingDetails(
                                destCountry: _countryController.text);

                            Navigator.pushNamed(context, '/confirm_order',
                                arguments: {
                                  'items': products,
                                  'total': total,
                                  'destCountry': _countryController.text,
                                  'destCity': _cityController.text,
                                  'destRegion': _regionController.text,
                                  'destStreet': _streetController.text,
                                });
                          }
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
