import 'dart:convert';
import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:online_china_app/core/enums/constants.dart';
import 'package:online_china_app/core/enums/viewstate.dart';
import 'package:online_china_app/core/models/order.dart';
import 'package:online_china_app/core/viewmodels/views/order_model.dart';
import 'package:online_china_app/ui/shared/app_colors.dart';
import 'package:online_china_app/ui/views/base_view.dart';
import 'package:online_china_app/ui/widgets/big_button.dart';
import 'package:online_china_app/ui/widgets/orderitem_list_item.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class OrderDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    final String orderId = params != null ? params['orderId'] : "";

    Order order;
    return BaseView<OrderModel>(
        model: OrderModel(orderService: Provider.of(context)),
        onModelReady: (model) async {
          order = await model.getOrder(orderId: orderId);
        },
        builder: (context, model, child) => Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(title: Text("Order Details")),
              body: SafeArea(
                  child: Stack(
                children: <Widget>[
                  if (model.state == ViewState.Busy)
                    Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  if (order == null)
                    Container()
                  else
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            itemCount: order.products != null
                                ? order.products.length
                                : 0,
                            shrinkWrap: false,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            itemBuilder: (BuildContext context, int index) {
                              var product = order.products[index];
                              return OrderItemListItem(
                                subtitle: product.variations != null &&
                                        product.variations.length > 0
                                    ? product.variations[0]?.attributesLabel
                                    : null,
                                title: product.name,
                                price: product.priceLabel,
                                imageUrl: product.thumbnail,
                                quantity: product.quantity,
                              );
                            },
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Total Amount",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    order.priceLabel,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                if (order.status == "Pending")
                                  Expanded(
                                    flex: 1,
                                    child: BigButton(
                                      color: Color.fromRGBO(152, 2, 32, 1.0),
                                      buttonTitle: "CANCEL",
                                      functionality: () async {
                                        bool success = await model.updateOrder(
                                            orderId: order.id,
                                            statusCode:
                                                ORDER_STATUSCODE_CANCELLED);

                                        if (success) {
                                          // Navigator.pop(context);
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              "/",
                                              (Route<dynamic> route) => false,
                                              arguments: {"switchToIndex": 0});
                                        }
                                      },
                                    ),
                                  ),
                                if (order.status != "Cancelled")
                                  Expanded(
                                    flex: 1,
                                    child: BigButton(
                                      color: primaryColor,
                                      buttonTitle: "GET INVOICE",
                                      functionality: () async {
                                        String response = await model
                                            .getInvoiceHTML(orderId: order.id);
                                        var invoicePDFData =
                                            await model.generateInvoicePDF(
                                                htmlContent: response);

                                        if (Platform.isAndroid) {
                                          await savePDF(
                                              model, invoicePDFData, order.id);
                                        } else {
                                          await sharePDF(
                                              invoicePDFData, order.id);
                                        }
                                      },
                                    ),
                                  ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                ],
              )),
            ));
  }

  Future<void> sharePDF(var htmlContent, String filename) async {
    filename = filename + ".pdf";
    await Printing.sharePdf(bytes: htmlContent, filename: filename);
  }

  Future<void> generatePDF(String htmlContent, String filename) async {
//---- Printing
    // await Printing.layoutPdf(
    //     onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
    //           format: format,
    //           html: htmlContent,
    //         ));

    filename = filename + ".pdf";
    final pdf = await Printing.convertHtml(
      format: PdfPageFormat.a4,
      html: htmlContent,
    );

//save
    // final output = await getTemporaryDirectory();
    // final file = File("${output.path}/${filename}");
    // await file.writeAsBytes(pdf);

    // print("FILENAME");
    // print("${output.path}/${filename}");

//share
    await Printing.sharePdf(bytes: pdf, filename: filename);
  }
}

Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
  final android = AndroidNotificationDetails(
      'channel id', 'channel name', 'channel description',
      priority: Priority.High, importance: Importance.Max);
  final iOS = IOSNotificationDetails();
  final platform = NotificationDetails(android, iOS);
  final json = jsonEncode(downloadStatus);
  final success = downloadStatus['success'];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.show(
      0, // notification id
      success ? 'Success' : 'Failure',
      success
          ? 'File has been downloaded successfully!'
          : 'There was an error while downloading the file.',
      platform,
      payload: json);
}

Future<void> savePDF(OrderModel model, var htmlContent, String filename) async {
  if (await Permission.storage.request().isGranted) {
    filename = "Shamwaaa_" + filename + ".pdf";

    var output = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    String fullPath = "${output}/${filename}";

    final file = File(fullPath);
    await file.writeAsBytes(htmlContent);

    model.showAlertMessage(message: "Invoice saved to Downloads", error: false);

    //post local notification
    Map<String, dynamic> result = {
      'success': true,
      'filePath': fullPath,
      'error': null,
    };
    _showNotification(result);
  } else {
    model.showAlertMessage(
        message: "Failed to save invoice, please grant storage permissions",
        error: true);
  }
}

class OrderProperty extends StatelessWidget {
  final String keyText;
  final String valueText;
  const OrderProperty({Key key, this.keyText, this.valueText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Text(this.keyText != null ? this.keyText : ""),
          Text(this.valueText != null ? this.valueText : ""),
        ],
      ),
    );
  }
}
