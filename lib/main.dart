import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vmath;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedBackgroundScreen(),
    );
  }
}

class AnimatedBackgroundScreen extends StatefulWidget {
  @override
  _AnimatedBackgroundScreenState createState() =>
      _AnimatedBackgroundScreenState();
}

class _AnimatedBackgroundScreenState extends State<AnimatedBackgroundScreen> {
  ScrollController _scrollController = ScrollController();
  Color _backgroundColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    double offset = _scrollController.offset;
    setState(() {
      _backgroundColor = Color.lerp(Colors.black, Colors.purple, offset / 500)!
          .withOpacity(1.0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        color: _backgroundColor,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            _onScroll();
            return true;
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                Container(
                  height: 1000, // Increase for longer scroll effect
                  child: Center(child: ThreeDAnimatedBox()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ThreeDAnimatedBox extends StatefulWidget {
  @override
  _ThreeDAnimatedBoxState createState() => _ThreeDAnimatedBoxState();
}

class _ThreeDAnimatedBoxState extends State<ThreeDAnimatedBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _rotationX = 0;
  double _rotationY = 0;
  double _scale = 1.0;
  Color _boxColor = Colors.blue;
  double _opacity = 1.0;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();

    // Opacity Animation - Fades in and out
    Future.delayed(Duration.zero, _startOpacityAnimation);
  }

  void _startOpacityAnimation() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _opacity = _opacity == 1.0 ? 0.3 : 1.0;
        });
        _startOpacityAnimation(); // Loop the effect
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotationX += details.delta.dy * 0.01;
      _rotationY += details.delta.dx * 0.01;
    });
  }

  void _onTap() {
    setState(() {
      _scale = 1.2;
      _boxColor = _getRandomColor();
    });

    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  void _onHover(bool hovering) {
    setState(() {
      _isHovering = hovering;
      _scale = hovering ? 1.1 : 1.0;
    });
  }

  Color _getRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onPanUpdate: _onPanUpdate,
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double angle = _controller.value * 2 * pi;
            return AnimatedOpacity(
              duration: Duration(seconds: 1),
              opacity: _opacity,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.005) // Perspective depth
                  ..rotateX(_rotationX + angle / 2)
                  ..rotateY(_rotationY + angle / 3)
                  ..scale(_scale),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: _boxColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: _boxColor.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
