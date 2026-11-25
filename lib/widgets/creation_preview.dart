import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../core/l10n_ext.dart';

/// Runs a creation's HTML/CSS/JS inside a sandboxed WebView.
///
/// Navigation away from the document is blocked, so a creation cannot open
/// external websites inside the app.
class CreationPreview extends StatefulWidget {
  const CreationPreview({
    super.key,
    required this.code,
    this.captureAllGestures = false,
  });

  final String code;

  /// When true the WebView receives every gesture (drags included). Leave it
  /// false inside the vertical feed so swipes still change page; taps always
  /// reach the creation.
  final bool captureAllGestures;

  @override
  State<CreationPreview> createState() => _CreationPreviewState();
}

class _CreationPreviewState extends State<CreationPreview> {
  late final WebViewController _controller;
  bool _loaded = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loaded = true);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true && mounted) {
              setState(() => _failed = true);
            }
          },
          onNavigationRequest: (request) {
            final url = request.url;
            final allowed =
                url.startsWith('about:') ||
                url.startsWith('data:') ||
                url.startsWith('blob:');
            return allowed
                ? NavigationDecision.navigate
                : NavigationDecision.prevent;
          },
        ),
      );
    _load();
  }

  @override
  void didUpdateWidget(CreationPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.code != widget.code) _load();
  }

  void _load() {
    _loaded = false;
    _failed = false;
    _controller.loadHtmlString(widget.code);
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Center(
        child: Text(
          context.l10n.previewError,
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        // Fade the creation in once it has rendered.
        AnimatedOpacity(
          opacity: _loaded ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          child: WebViewWidget(
            controller: _controller,
            gestureRecognizers: widget.captureAllGestures
                ? {Factory<EagerGestureRecognizer>(EagerGestureRecognizer.new)}
                : const <Factory<OneSequenceGestureRecognizer>>{},
          ),
        ),
        if (!_loaded)
          const Center(child: CircularProgressIndicator(color: Colors.white)),
      ],
    );
  }
}
