import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart'; // Import du WebView

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Initialisation de WebViewFlutter
    WebViewPlatformController.instance.clearCache();
    // Initialisation du WebViewController
    _webViewController = WebViewController();
    _webViewController.loadUrl('https://example.com');  // Remplacez par l'URL de votre choix
    _webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion au Net'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Recharger la page
              _webViewController.reload();
            },
          ),
        ],
      ),
      body: WebViewWidget(
        controller: _webViewController, // Passer le contrôleur au widget WebView
      ),
    );
  }
}
