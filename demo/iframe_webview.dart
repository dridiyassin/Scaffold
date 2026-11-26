import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

/// Browser stand-in for the Android/iOS WebView, used by the web demo only.
///
/// Each creation runs in a sandboxed `<iframe srcdoc>`: its scripts run, but
/// it cannot reach the app, cookies or storage, and cannot navigate the page.
class IframeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
    PlatformWebViewControllerCreationParams params,
  ) => _IframeController(params);

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
    PlatformNavigationDelegateCreationParams params,
  ) => _NavigationDelegate(params);

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
    PlatformWebViewWidgetCreationParams params,
  ) => _IframeWidget(params);
}

class _IframeController extends PlatformWebViewController {
  _IframeController(super.params) : super.implementation() {
    iframe
      ..setAttribute('sandbox', 'allow-scripts')
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.display = 'block';
    iframe.addEventListener(
      'load',
      ((web.Event _) => _delegate?.onPageFinished?.call('about:srcdoc')).toJS,
    );
    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int _) => iframe,
    );
  }

  static int _nextId = 0;

  final String viewType = 'scaffold-creation-${_nextId++}';
  final web.HTMLIFrameElement iframe = web.HTMLIFrameElement();
  _NavigationDelegate? _delegate;

  @override
  Future<void> setJavaScriptMode(JavaScriptMode javaScriptMode) async {}

  @override
  Future<void> setBackgroundColor(Color color) async {
    int c(double v) => (v * 255).round();
    iframe.style.background =
        'rgba(${c(color.r)}, ${c(color.g)}, ${c(color.b)}, ${color.a})';
  }

  @override
  Future<void> setPlatformNavigationDelegate(
    PlatformNavigationDelegate handler,
  ) async {
    _delegate = handler as _NavigationDelegate;
  }

  @override
  Future<void> loadHtmlString(String html, {String? baseUrl}) async {
    iframe.setAttribute('srcdoc', html);
    // The iframe only enters the page once Flutter paints it, and the app
    // keeps it invisible (not painted) until "page finished". A native
    // WebView loads off-screen, so report the page as loaded right away.
    Future<void>.delayed(
      const Duration(milliseconds: 150),
      () => _delegate?.onPageFinished?.call('about:srcdoc'),
    );
  }
}

class _NavigationDelegate extends PlatformNavigationDelegate {
  _NavigationDelegate(super.params) : super.implementation();

  PageEventCallback? onPageFinished;

  @override
  Future<void> setOnPageFinished(PageEventCallback onPageFinished) async {
    this.onPageFinished = onPageFinished;
  }

  // The sandbox already blocks navigation, so the other callbacks are unused.
  @override
  Future<void> setOnNavigationRequest(NavigationRequestCallback _) async {}

  @override
  Future<void> setOnPageStarted(PageEventCallback _) async {}

  @override
  Future<void> setOnProgress(ProgressCallback _) async {}

  @override
  Future<void> setOnWebResourceError(WebResourceErrorCallback _) async {}

  @override
  Future<void> setOnHttpError(HttpResponseErrorCallback _) async {}

  @override
  Future<void> setOnUrlChange(UrlChangeCallback _) async {}

  @override
  Future<void> setOnHttpAuthRequest(HttpAuthRequestCallback _) async {}

  @override
  Future<void> setOnSSlAuthError(SslAuthErrorCallback _) async {}
}

class _IframeWidget extends PlatformWebViewWidget {
  _IframeWidget(super.params) : super.implementation();

  @override
  Widget build(BuildContext context) {
    final controller = params.controller as _IframeController;
    // In the feed (no gesture recognizers) pointers go to Flutter so swipes
    // change page and the action rail stays tappable. The detail "Preview"
    // tab asks for every gesture, so there the creation is fully playable.
    controller.iframe.style.pointerEvents = params.gestureRecognizers.isEmpty
        ? 'none'
        : 'auto';
    return HtmlElementView(viewType: controller.viewType);
  }
}
