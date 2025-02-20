import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sketchfab 3D Model',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
          'https://sketchfab.com/models/b8f38e5911034412a545a6aaef4e4bb1/embed')); // Replace with your Sketchfab model ID
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Stack(
          children: [
            // WebView to load Sketchfab 3D model
            WebViewWidget(controller: _webViewController),

            // UI Elements
            PageView(
              children: [
                ListView.builder(
                  padding: EdgeInsets.fromLTRB(12, height * 0.8, 12, 100),
                  itemCount: 10,
                  itemBuilder: (context, index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/image1.jpg',
                              fit: BoxFit.cover, width: 70, height: 70),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'A simple way to stay healthy',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Dr Babak',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Icon(Icons.location_on, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                ),
                ClipPath(
                  clipper: InvertedCircleClipper(),
                  child: Container(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InvertedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width * 0.45))
    ..addRect(Rect.fromLTRB(0, 0, size.width, size.height))
    ..fillType = PathFillType.evenOdd;

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
