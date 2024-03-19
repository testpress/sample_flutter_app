import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

class PlayerWidget extends StatefulWidget {
  final String assetId;
  final String accessToken;

  const PlayerWidget(
      {Key? key, required this.assetId, required this.accessToken})
      : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.white)
    ..loadRequest(Uri.parse(
        'https://app.tpstreams.com/live-chat/6eafqn/79TddQyuTxZ'))
    ..enableZoom(false);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text("Streams Demo"),
        ),
        body: Column(
          children: [
            TPStreamPlayer(
              assetId: widget.assetId,
              accessToken: widget.accessToken,
            ),
            const TabBar(
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'More'),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  WebViewWidget(controller: controller),
                  const Center(
                    child: Text('More Tab Content'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
