import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/navigation_bloc.dart';
import 'views/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NavigationBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Steven Nikko Asuncion | Software Developer',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashFadeInWrapper(child: HomePage()),
      ),
    );
  }
}

class SplashFadeInWrapper extends StatefulWidget {
  final Widget child;

  const SplashFadeInWrapper({super.key, required this.child});

  @override
  State<SplashFadeInWrapper> createState() => _SplashFadeInWrapperState();
}

class _SplashFadeInWrapperState extends State<SplashFadeInWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _splashOpacity;
  late Animation<double> _appOpacity;
  late Animation<double> _nameScale;
  late Animation<double> _titleOpacity;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200), // 1.2 seconds total
      vsync: this,
    );

    _splashOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 4),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _appOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.66,
        1.0,
        curve: Curves.easeOutCubic,
      ),
    ));

    _nameScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.0,
        0.5,
        curve: Curves.easeOutBack,
      ),
    ));

    _titleOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(
        0.166,
        0.5,
        curve: Curves.easeOut,
      ),
    ));

    _controller.forward().whenComplete(() {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeTransition(
          opacity: _appOpacity,
          child: widget.child,
        ),

        // Splash overlay (shown first, then fades out)
        if (_showSplash)
          Positioned.fill(
            child: FadeTransition(
              opacity: _splashOpacity,
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _nameScale,
                        child: Text(
                          'Steven Nikko Villanueva Asuncion',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FadeTransition(
                        opacity: _titleOpacity,
                        child: Text(
                          'Software Developer',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
