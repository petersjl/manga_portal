import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../services/mangadex_api.dart';

/// Renders a single manga page and handles MangaDex@Home reporting.
///
/// For images served from a third-party node (base URL not containing
/// 'mangadex.org'), reports load success/failure to api.mangadex.network.
class ReaderPageImage extends StatefulWidget {
  const ReaderPageImage({
    super.key,
    required this.url,
    required this.isThirdParty,
    required this.apiService,
    required this.onLoadFailure,
  });

  /// The full resolved page URL.
  final String url;

  /// Whether the base URL came from a third-party MD@Home node.
  final bool isThirdParty;

  final MangaDexApiService apiService;

  /// Called when the image fails to load so the parent can refresh the
  /// at-home server URL before retrying.
  final VoidCallback onLoadFailure;

  @override
  State<ReaderPageImage> createState() => _ReaderPageImageState();
}

class _ReaderPageImageState extends State<ReaderPageImage> {
  final _stopwatch = Stopwatch();
  bool _reported = false;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  void _reportSuccess({required bool wasSynchronous}) {
    if (_reported) return;
    _reported = true;
    _stopwatch.stop();
    if (!widget.isThirdParty) return;
    widget.apiService.reportImageLoad(
      url: widget.url,
      success: true,
      bytes: 0,
      duration: wasSynchronous ? 0 : _stopwatch.elapsedMilliseconds,
      cached: wasSynchronous,
    );
  }

  void _onError() {
    if (_reported) return;
    _reported = true;
    _stopwatch.stop();
    if (widget.isThirdParty) {
      widget.apiService.reportImageLoad(
        url: widget.url,
        success: false,
        bytes: 0,
        duration: _stopwatch.elapsedMilliseconds,
        cached: false,
      );
    }
    widget.onLoadFailure();
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: CachedNetworkImageProvider(widget.url),
      fit: BoxFit.contain,
      // frameBuilder lets us distinguish synchronous (memory-cached) loads
      // from async loads. When wasSynchronouslyLoaded is true the image was
      // already in Flutter's memory cache — show it instantly with no
      // placeholder so preloaded pages slide in with zero delay.
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          _reportSuccess(wasSynchronous: true);
          return child;
        }
        if (frame != null) {
          // First frame decoded asynchronously — image is ready.
          _reportSuccess(wasSynchronous: false);
          return child;
        }
        // Still fetching — show a spinner only for genuinely unloaded pages.
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _onError());
        return const Center(
          child: Icon(Icons.broken_image_outlined, size: 48),
        );
      },
    );
  }
}
