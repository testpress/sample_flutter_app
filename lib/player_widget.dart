import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Streams Demo"),
      ),
      body: Column(
        children: [
          Container(
            height: 240,
            color: Colors.black,
            child: const Center(
                child: TPStreamPlayer(
                    assetId: '68PAFnYTjSU',
                    accessToken: '5f3ded52-ace8-487e-809c-10de895872d6')),
          )
        ],
      ),
    );
  }
}