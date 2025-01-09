import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import 'downloaded_video_screen.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final _downloadManager = TPStreamsDownloadManager();
  List<DownloadAsset> _downloads = [];

  @override
  void initState() {
    super.initState();
    _loadDownloads();
    _listenToDownloadProgress();
  }

  void _loadDownloads() async {
    final downloads = await _downloadManager.getAllDownloads();
    setState(() {
      _downloads = downloads;
    });
  }

  void _listenToDownloadProgress() {
    _downloadManager.downloadsStream.listen(
      (downloads) {
        setState(() {
          _downloads = downloads;
        });
      },
      onError: (error) {
        debugPrint('Download progress error: $error');
      },
    );
  }

  void _playDownloadedVideo(DownloadAsset asset) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DownloadedVideoScreen(
          downloadAsset: asset,
        ),
      ),
    );
  }

  String _getStateText(DownloadState state) {
    switch (state) {
      case DownloadState.notDownloaded:
        return 'Not Downloaded';
      case DownloadState.downloading:
        return 'Downloading';
      case DownloadState.paused:
        return 'Paused';
      case DownloadState.completed:
        return 'Completed';
      case DownloadState.failed:
        return 'Failed';
    }
  }

  Color _getStateColor(DownloadState state) {
    switch (state) {
      case DownloadState.notDownloaded:
        return Colors.grey;
      case DownloadState.downloading:
        return Colors.blue;
      case DownloadState.paused:
        return Colors.orange;
      case DownloadState.completed:
        return Colors.green;
      case DownloadState.failed:
        return Colors.red;
    }
  }

  Widget _buildActionButtons(DownloadAsset asset) {
    final List<Widget> buttons = [];

    switch (asset.state) {
      case DownloadState.downloading:
        if (!Platform.isIOS) {
          buttons.add(_buildIconButton(
            icon: Icons.pause,
            onPressed: () => _downloadManager.pauseDownload(asset),
            tooltip: 'Pause',
          ));
        }
        buttons.add(_buildIconButton(
          icon: Icons.cancel,
          onPressed: () => _downloadManager.cancelDownload(asset),
          tooltip: 'Cancel',
        ));
        break;
      case DownloadState.paused:
        if (!Platform.isIOS) {
          buttons.add(_buildIconButton(
            icon: Icons.play_arrow,
            onPressed: () => _downloadManager.resumeDownload(asset),
            tooltip: 'Resume',
          ));
        }
        buttons.add(_buildIconButton(
          icon: Icons.cancel,
          onPressed: () => _downloadManager.cancelDownload(asset),
          tooltip: 'Cancel',
        ));
        break;
      case DownloadState.completed:
        buttons.add(_buildIconButton(
          icon: Icons.play_arrow,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadedVideoScreen(downloadAsset: asset),
            ),
          ),
          tooltip: 'Play',
        ));
        buttons.add(_buildIconButton(
          icon: Icons.delete,
          onPressed: () => _downloadManager.deleteDownload(asset),
          tooltip: 'Delete',
        ));
        break;
      case DownloadState.failed:
        buttons.add(_buildIconButton(
          icon: Icons.refresh,
          onPressed: () => _downloadManager.resumeDownload(asset),
          tooltip: 'Retry',
        ));
        break;
      default:
        break;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons,
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
    );
  }

  Widget _buildDownloadProgress(DownloadAsset asset) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: asset.progress / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(_getStateColor(asset.state)),
        ),
        const SizedBox(height: 4),
        Text(
          '${(asset.progress).toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadItem(DownloadAsset asset) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      asset.title ?? 'Untitled',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildStateIndicator(asset.state),
                  ],
                ),
              ),
              _buildActionButtons(asset),
            ],
          ),
          if (asset.state == DownloadState.downloading)
            _buildDownloadProgress(asset),
        ],
      ),
    );
  }

  Widget _buildStateIndicator(DownloadState state) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getStateColor(state).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        _getStateText(state),
        style: TextStyle(
          fontSize: 12,
          color: _getStateColor(state),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showDeleteAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Downloads'),
        content: const Text('Are you sure you want to delete all downloads?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _downloadManager.deleteAllDownloads();
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        actions: [
          if (_downloads.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _showDeleteAllDialog,
              tooltip: 'Delete All',
            ),
        ],
      ),
      body: _downloads.isEmpty
          ? const Center(
              child: Text(
                'No downloads available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _downloads.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) => _buildDownloadItem(_downloads[index]),
            ),
    );
  }

  @override
  void dispose() {
    _downloadManager.dispose();
    super.dispose();
  }
} 
