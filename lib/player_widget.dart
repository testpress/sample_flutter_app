import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

class PlayerWidget extends StatelessWidget {
  final String assetId;
  final String accessToken;

  const PlayerWidget({super.key, required this.assetId, required this.accessToken});

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
