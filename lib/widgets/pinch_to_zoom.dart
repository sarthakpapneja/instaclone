import 'package:flutter/material.dart';

class PinchToZoom extends StatefulWidget {
  final Widget child;

  const PinchToZoom({super.key, required this.child});

  @override
  State<PinchToZoom> createState() => _PinchToZoomState();
}

class _PinchToZoomState extends State<PinchToZoom> with SingleTickerProviderStateMixin {
  late TransformationController _controller;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  OverlayEntry? _entry;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        _controller.value = _animation!.value;
      })
    ..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showOverlay(BuildContext context) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _entry = OverlayEntry(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: 0.5)),
              ),
              Positioned(
                left: offset.dx,
                top: offset.dy,
                width: size.width,
                height: size.height,
                child: InteractiveViewer(
                  transformationController: _controller,
                  clipBehavior: Clip.none,
                  panEnabled: false,
                  onInteractionEnd: (details) {
                    _resetAnimation();
                  },
                  child: widget.child,
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_entry!);
  }

  void _removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  void _resetAnimation() {
    _animation = Matrix4Tween(
      begin: _controller.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        if (details.pointerCount >= 2) {
          _showOverlay(context);
        }
      },
      child: widget.child,
    );
  }
}
