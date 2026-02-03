import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

class VideoScreen extends StatefulWidget {
  final String assetId;
  final String accessToken;
  final bool showDownloadOption;
  final bool startInFullscreen;
  final Map<String, String>? metadata;

  const VideoScreen({
    super.key,
    required this.assetId,
    required this.accessToken,
    this.showDownloadOption = false,
    this.startInFullscreen = false,
    this.metadata,
    this.preferences,
  });

  final TPStreamsPlayerPreferences? preferences;

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late TPStreamsPlayerController _controller;
  bool _isPlaying = false;
  final _downloadManager = TPStreamsDownloadManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: TPStreamPlayer(
              assetId: widget.assetId,
              accessToken: widget.accessToken,
              showDownloadOption: widget.showDownloadOption,
              startInFullscreen: widget.startInFullscreen,
              metadata: widget.metadata,
              preferences: widget.preferences,
              onPlayerCreated: (controller) {
                _controller = controller;
                _controller.onBeforeFullScreenEnter = () {
                  print('Will enter fullscreen');
                };

                _controller.onBeforeFullScreenExit = () {
                  print('Will exit fullscreen');
                };
                // Listen to player value changes
                _controller.addListener(_onPlayerValueChanged);

                _controller.onAccessTokenExpired = (String videoId) async {
                  String newToken = "5fa9d056-9a59-424c-ada1-2e08f75050e2"; // await getNewToken();
                  return newToken;
                };
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 32,
                onPressed: () {
                  if (_isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                },
              ),
              if (widget.showDownloadOption) ...[
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _downloadManager.startDownload(
                      widget.assetId,
                      widget.accessToken,
                      widget.metadata,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Download started'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _onPlayerValueChanged() {
    final newIsPlaying = _controller.value.isPlaying;
    if (newIsPlaying != _isPlaying) {
      setState(() {
        _isPlaying = newIsPlaying;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerValueChanged);
    super.dispose();
  }
} 