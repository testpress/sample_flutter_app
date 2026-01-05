import 'package:flutter/material.dart';
import 'package:tpstreams_player_sdk/tpstreams_player_sdk.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class VideoScreen extends StatefulWidget {
  final String assetId;
  final String accessToken;
  final bool showDownloadOption;
  final Map<String, String>? metadata;

  const VideoScreen({
    super.key,
    required this.assetId,
    required this.accessToken,
    this.showDownloadOption = false,
    this.metadata,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late TPStreamsPlayerController _controller;
  bool _isPlaying = false;
  final _downloadManager = TPStreamsDownloadManager();
  
  // PDF viewer state (similar to TPStreamsVideoPlayerPage)
  bool _showPdf = false;
  bool _pdfLoading = false;
  String? _pdfError;
  final PdfViewerController _pdfViewerController = PdfViewerController();
  
  // Cached TPStreams player widget to prevent rebuilding
  Widget? _cachedTPStreamsPlayerWidget;
  
  // Free public PDF for testing
  // Using a sample PDF from Mozilla
  final String _pdfUrl = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

  @override
  void initState() {
    super.initState();
    // Initialize after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _pdfLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cache the video player widget to avoid rebuilding (like in client code)
    _cachedTPStreamsPlayerWidget ??= TPStreamPlayer(
      assetId: widget.assetId,
      accessToken: widget.accessToken,
      showDownloadOption: widget.showDownloadOption,
      metadata: widget.metadata,
      onPlayerCreated: (controller) {
        _controller = controller;
        // Listen to player value changes
        _controller.addListener(_onPlayerValueChanged);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_showPdf ? 'PDF Viewer' : 'Video Player'),
      ),
      body: Column(
        children: [
          // Conditionally show Video or PDF with different sizing
          if (_showPdf)
            // PDF viewer takes more space - uses Expanded
            Expanded(
              child: _buildPdfViewer(),
            )
          else
            // Video player uses AspectRatio
            AspectRatio(
              aspectRatio: 16 / 9,
              child: _cachedTPStreamsPlayerWidget!,
            ),
          const SizedBox(height: 16),
          // Toggle button to switch between Video and PDF
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _showPdf = !_showPdf;
              });
            },
            icon: Icon(_showPdf ? Icons.video_library : Icons.picture_as_pdf),
            label: Text(_showPdf ? 'Show Video' : 'Show PDF'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          // Info banner
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _showPdf 
                      ? 'PDF viewer active. Switch back to video on Android 12 to check if controls appear.'
                      : 'Video player active. Toggle to PDF to reproduce Android 12 controls issue.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Player controls (only show when video is active)
          if (!_showPdf) ...[
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
        ],
      ),
    );
  }

  Widget _buildPdfViewer() {
    if (_pdfError != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading PDF: $_pdfError'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _pdfError = null;
                  _pdfLoading = true;
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_pdfLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Syncfusion PDF Viewer (same as in client code)
    return SfPdfViewer.network(
      _pdfUrl,
      controller: _pdfViewerController,
      onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
        setState(() {
          _pdfError = details.error;
          _pdfLoading = false;
        });
      },
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
    _pdfViewerController.dispose();
    super.dispose();
  }
} 