import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

void main() {
  TPStreamsSDK.initialize(orgCode: "6eafqn");

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
                    assetId: '68PAFnYTjSU',
                    accessToken: '5f3ded52-ace8-487e-809c-10de895872d6')),
          )
        ],
      ),
    );
  }
}
