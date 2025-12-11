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
                    // Display metadata if available
                    if (asset.metadata != null && asset.metadata!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildMetadataChips(asset.metadata!),
                    ],
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

  Widget _buildMetadataChips(Map<String, String> metadata) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: metadata.entries
          .map((entry) => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${entry.key}: ${entry.value}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))
          .toList(),
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

  void _showMetadataInfo(int downloadsWithMetadata) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.label, color: Colors.blue),
            SizedBox(width: 8),
            Text('Download Metadata'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Statistics',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              _buildInfoRow('Total Downloads', '${_downloads.length}'),
              _buildInfoRow('With Metadata', '$downloadsWithMetadata'),
              _buildInfoRow('Without Metadata', '${_downloads.length - downloadsWithMetadata}'),
              const SizedBox(height: 16),
              Text(
                'What is Metadata?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Metadata allows you to attach custom information to downloads, such as course ID, module name, or category.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                'How to Add Metadata',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Metadata is set when loading the player in native code (Android/iOS). See METADATA_TESTING.md in the example folder for detailed instructions.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💡 Tip',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Metadata appears as blue chips below the video title in the downloads list.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
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
    final downloadsWithMetadata = _downloads.where((d) => 
      d.metadata != null && d.metadata!.isNotEmpty
    ).length;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showMetadataInfo(downloadsWithMetadata),
            tooltip: 'Metadata Info',
          ),
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
