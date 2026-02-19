import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import 'screens/downloads_screen.dart';
import 'screens/video_screen.dart';
import 'screens/live_chat_screen.dart';

void main() {
  TPStreamsSDK.initialize(provider: PROVIDER.tpstreams, orgCode: "9q94nm");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TPStreams Player Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final videos = [
      (
        title: 'DRM',
        assetId: '42h2tZ5fmNf',
        accessToken: '9327e2d0-fa13-4288-902d-840f32cd0eed',
        startInFullscreen: false,
        metadata: {
          'course_id': 'flutter-100',
          'module': 'drm-video',
          'category': 'mobile-development',
          'lecture_id': 'lecture-1001',
        },
      ),
      (
        title: 'Non-DRM', 
        assetId: 'BEArYFdaFbt',
        accessToken: 'e6a1b485-daad-42eb-8cf2-6b6e51631092',
        startInFullscreen: false,
        metadata: {
          'course_id': 'flutter-101',
          'module': 'non-drm-video',
          'lecture_id': 'lecture-1002',
        },
      ),
      (
        title: 'Launch in Fullscreen', 
        assetId: 'BEArYFdaFbt',
        accessToken: 'e6a1b485-daad-42eb-8cf2-6b6e51631092',
        startInFullscreen: true,
        metadata: {
          'course_id': 'flutter-101',
          'module': 'non-drm-video',
          'lecture_id': 'lecture-1002',
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('TPStreams Player Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...videos.map((video) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoScreen(
                        assetId: video.assetId,
                        accessToken: video.accessToken,
                        showDownloadOption: true,
                        startInFullscreen: video.startInFullscreen,
                        autoPlay: true,
                        metadata: video.metadata,
                        preferences: TPStreamsPlayerPreferences(
                          enableFullscreen: false,
                          enablePlaybackSpeed: false,
                          enableCaptions: false,
                          showResolutionOptions: true,
                          enableSeekButtons: false,
                          seekBarColor: Colors.yellow.value,
                        ),
                      ),
                    ),
                  );
                },
                child: Text(video.title),
              ),
            )),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadsScreen(),
                  ),
                );
              },
              child: const Text('Downloads'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveChatScreen(
                      username: "Flutter user",
                      roomId: "93b76b94-c9a5-42df-a0af-c196cff1103c",
                      title: "Flutter Live Chat",
                    ),
                  ),
                );
              },
              child: const Text('Live Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
