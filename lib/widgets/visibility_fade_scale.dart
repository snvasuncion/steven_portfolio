import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Like [DelayedFadeScale] but triggers when the widget becomes visible on screen.
/// Falls back to a simple delayed animation if visibility can't be determined.
class VisibilityFadeScale extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;

  const VisibilityFadeScale({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
  });

  @override
  State<VisibilityFadeScale> createState() => _VisibilityFadeScaleState();
}

class _VisibilityFadeScaleState extends State<VisibilityFadeScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  bool _hasBeenVisible = false;
  final String _keyId = 'vfs_${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().hashCode}';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasBeenVisible && info.visibleFraction > 0) {
      _hasBeenVisible = true;
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(_keyId),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
