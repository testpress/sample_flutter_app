import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import './player_widget.dart';

void main() {
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
                    provider: "tpstreams", assetId: "68PAFnYTjSU",accessToken: "5f3ded52-ace8-487e-809c-10de895872d6",
                  )),
                );
              },
              child: const Text('Play a TPStreams Video'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerWidget(
                    provider: "testpress", assetId: "1jWroFoTI5K",accessToken: "1f19410f-25e9-4aca-aae7-03b378f583b0",
                  )),
                );
              },
              child: const Text('Play a Testpress Video'),
            ),
          ],
        ),
      ),
    );
  }
}
