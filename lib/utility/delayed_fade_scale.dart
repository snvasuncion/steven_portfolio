import 'package:flutter/material.dart';

class DelayedFadeScale extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final bool animateOnExit; // NEW: Control whether to animate on exit

  const DelayedFadeScale({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeInOut,
    this.animateOnExit = false, 
  });

  @override
  State<DelayedFadeScale> createState() => _DelayedFadeScaleState();
}

class _DelayedFadeScaleState extends State<DelayedFadeScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  bool _isExiting = false;

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
    
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );
    
    // Start animation after delay
    Future.delayed(widget.delay, () {
      if (mounted && !_isExiting) {
        _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(DelayedFadeScale oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If widget changed and we should animate on exit, reverse animation
    if (widget.child != oldWidget.child && widget.animateOnExit) {
      _reverseAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _reverseAnimation() {
    if (mounted && _controller.status != AnimationStatus.dismissed) {
      _isExiting = true;
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
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
    );
  }
}