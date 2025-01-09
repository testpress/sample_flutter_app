import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';

class DownloadedVideoScreen extends StatefulWidget {
  final DownloadAsset downloadAsset;

  const DownloadedVideoScreen({
    super.key,
    required this.downloadAsset,
  });

  @override
  State<DownloadedVideoScreen> createState() => _DownloadedVideoScreenState();
}

class _DownloadedVideoScreenState extends State<DownloadedVideoScreen> {
  late TPStreamsPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.downloadAsset.title ?? 'Downloaded Video'),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: TPStreamPlayer.offline(
              assetId: widget.downloadAsset.assetId,
            ),
          ),
          // ... player controls
        ],
      ),
    );
  }
} 