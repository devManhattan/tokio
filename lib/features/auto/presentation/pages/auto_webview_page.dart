import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AutoWebViewPage extends StatefulWidget {
  const AutoWebViewPage({super.key, required this.url});

  final String url;

  @override
  State<AutoWebViewPage> createState() => _AutoWebViewPageState();
}

class _AutoWebViewPageState extends State<AutoWebViewPage> {
  WebViewController? _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageFinished: (_) {
              if (mounted) setState(() => _loading = false);
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Automóvel')),
      body: kIsWeb ? _buildWebFallback() : _buildWebView(),
    );
  }

  Widget _buildWebView() {
    return Stack(
      children: [
        WebViewWidget(controller: _controller!),
        if (_loading) const LinearProgressIndicator(),
      ],
    );
  }

  Widget _buildWebFallback() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () =>
            launchUrl(Uri.parse(widget.url), webOnlyWindowName: '_blank'),
        icon: const Icon(Icons.open_in_new),
        label: const Text('Abrir no navegador'),
      ),
    );
  }
}
