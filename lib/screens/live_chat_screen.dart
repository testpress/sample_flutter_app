import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class LiveChatScreen extends StatefulWidget {
  final String username;
  final String roomId;
  final String title;

  const LiveChatScreen({
    super.key,
    required this.username,
    required this.roomId,
    required this.title,
  });

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            debugPrint('Web resource error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            // It's safer to prevent navigation if the webview is self-contained.
            return NavigationDecision.prevent;
          },
        ),
      );

    final platform = _controller.platform;
    if (platform is AndroidWebViewController) {
      final cookieManager = WebViewCookieManager().platform;
      if (cookieManager is AndroidWebViewCookieManager) {
        cookieManager.setAcceptThirdPartyCookies(platform, true);
      }
    }

    _controller.loadHtmlString('''
<!DOCTYPE html>
<html lang="en" style="height: 100%">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
      <link rel="stylesheet" href="https://static.testpress.in/static/live_chat/live_chat.css">
      <script src="https://static.testpress.in/static/live_chat/live_chat.umd.cjs"></script>
  </head>
  <body style="height: 100%; margin: 0; padding: 0;">
    <div id="app" style="height: 100%; width: 100%;"></div>
    <script>
      window.onload = function() {
        if (window.TPStreamsChat) {
          new TPStreamsChat.load(document.querySelector("#app"), {
            username : ${json.encode(widget.username)},
            roomId: ${json.encode(widget.roomId)},
            title: ${json.encode(widget.title)}
          });
        }
      };
    </script>
  </body>
</html>
''', baseUrl: 'https://static.testpress.in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
