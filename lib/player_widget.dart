import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/player_controller.dart';
import 'package:tpstreams_player_sdk/tpstreams_player.dart';

class PlayerWidget extends StatefulWidget {
  final String assetId;
  final String accessToken;

  const PlayerWidget({super.key, required this.assetId, required this.accessToken});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  TPStreamsPlayerController? _controller;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text("Streams Demo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Video Player widget
          TPStreamPlayer(
            assetId: widget.assetId,
            accessToken: widget.accessToken,
            onPlayerCreated: _onPlayerCreated,
          ),
          const SizedBox(height: 20),

          // Display current state: Playing or Paused
          Text(
            _isPlaying ? 'Playing' : 'Paused',
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 10),

          // Display current position and total duration
          Text(
            '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 20),

          // Play/Pause Button
          ElevatedButton(
            onPressed: _togglePlayPause,
            child: Text(_isPlaying ? 'Pause' : 'Play'),
          ),
        ],
      ),
    );
  }

  void _onPlayerCreated(TPStreamsPlayerController controller) {
    _controller = controller;

    _controller?.addListener(() {
      setState(() {
        _isPlaying = _controller!.value.isPlaying;
        _position = _controller!.value.position;
        _duration = _controller!.value.duration;
      });
    });
  }

  void _togglePlayPause() {
    if (_controller != null) {
      if (_isPlaying) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
