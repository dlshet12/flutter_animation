import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  late final WebViewController _webViewController;
  final PageController _pageController = PageController();

  final List<String> sketchfabUrls = [
    "https://sketchfab.com/models/b8f38e5911034412a545a6aaef4e4bb1/embed?camera=0,0,10", // Default view
    "https://sketchfab.com/models/b8f38e5911034412a545a6aaef4e4bb1/embed?camera=0,10,5", // Adjusted for second tab
    "https://sketchfab.com/models/b8f38e5911034412a545a6aaef4e4bb1/embed?camera=10,0,0", // Adjusted for third tab
  ];

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(sketchfabUrls[_selectedIndex]));
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
      _webViewController.loadRequest(Uri.parse(sketchfabUrls[index])); // Update camera view
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            // 3D Model Viewer (WebViewWidget)
            Expanded(
              flex: 3,
              child: WebViewWidget(controller: _webViewController),
            ),

            // PageView for content
            Expanded(
              flex: 2,
              child: PageView(
                controller: _pageController,
                onPageChanged: _onTabChanged,
                children: [
                  _buildContentPage("Daily Goals", ["Calories: 1200", "Steps: 5000", "Sleep: 7 hrs"]),
                  _buildContentPage("Journal", ["Morning Walk", "Lunch Break", "Workout"]),
                  _buildContentPage("Profile", ["Name: John Doe", "Age: 30", "Weight: 75kg"]),
                ],
              ),
            ),
          ],
        ),

        // Bottom Navigation
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabChanged,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Goals"),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: "Journal"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPage(String title, List<String> items) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(title: Text(items[index])),
              );
            },
          ),
        ),
      ],
    );
  }
}
