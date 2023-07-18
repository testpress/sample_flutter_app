import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

void main() {
  TPStreamsSDK.initialize(provider: PROVIDER.testpress, orgCode: "lmsdemo");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streams Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Streams Demo"),
      ),
      body: Column(
        children: [
          Container(
            height: 240,
            color: Colors.black,
            child: const Center(
                child: TPStreamPlayer(
                    assetId: 'XRvyrS2CSju',
                    accessToken: '87dcb513-4535-4be0-b91a-486f008086ff')),
          )
        ],
      ),
    );
  }
}
