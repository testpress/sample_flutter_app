import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

class PlayerWidget extends StatelessWidget {
  final String assetId;
  final String accessToken;
  final String provider;

  PlayerWidget({super.key, required this.assetId, required this.accessToken, required this.provider}) {
    TPStreamsSDK.initialize(
        provider: provider == "testpress" ? PROVIDER.testpress : PROVIDER.tpstreams,
        orgCode: provider == "testpress" ? "lmsdemo" : "6eafqn");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Streams Demo"),
      ),
      body: Column(
        children: [
          TPStreamPlayer(
              assetId: assetId,
              accessToken: accessToken)
        ],
      ),
    );
  }
}
