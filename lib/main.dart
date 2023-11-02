import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

void main() {
  TPStreamsSDK.initialize(provider: PROVIDER.tpstreams, orgCode: "6eafqn");

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
      body: const Column(
        children: [
          TPStreamPlayer(
                    assetId: 'peBmzxeQ7Mf',
                    accessToken: 'd7ebb4b2-8dee-4dff-bb00-e833195b0756'),
        ],
      ),
    );
  }
}
