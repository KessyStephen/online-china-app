import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebview extends StatefulWidget {
  @override
  _InAppWebviewState createState() => _InAppWebviewState();
}

class _InAppWebviewState extends State<InAppWebview> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;
    String title = params != null ? params['title'] : "";
    String body = params != null ? params['body'] : "";
    String initialUrl = params != null ? params['initialUrl'] : "";

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
          child: WebView(
        initialUrl: initialUrl,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;

          if (initialUrl == null || initialUrl.isEmpty) {
            _loadHtmlFromAssets(body, _controller);
          }
        },
      )),
    );
  }

  _loadHtmlFromAssets(htmlText, controller) async {
    controller.loadUrl(Uri.dataFromString(htmlText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
