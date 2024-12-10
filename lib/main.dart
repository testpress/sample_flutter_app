import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import './player_widget.dart';

void main() {
  TPStreamsSDK.initialize(orgCode: "4pts73");

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerWidget(
                    assetId: "BUA2jMpDbes",accessToken: "33e345b1-9f22-4382-8c5c-7e49a75d8027",
                  )),
                );
              },
              child: const Text('Play a DRM Video'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerWidget(
                    assetId: "peBmzxeQ7Mf",accessToken: "d7ebb4b2-8dee-4dff-bb00-e833195b0756",
                  )),
                );
              },
              child: const Text('Play a Video'),
            ),
          ],
        ),
      ),
    );
  }
}
