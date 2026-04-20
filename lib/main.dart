import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/navigation_bloc.dart';
import 'blocs/theme_cubit.dart';
import 'views/home_page.dart';
import 'data/data_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTextTheme =
        GoogleFonts.openSansTextTheme(ThemeData.light().textTheme).copyWith(
      headlineMedium: GoogleFonts.poppins(
          textStyle: ThemeData.light().textTheme.headlineMedium),
      headlineSmall: GoogleFonts.poppins(
          textStyle: ThemeData.light().textTheme.headlineSmall),
      titleLarge: GoogleFonts.poppins(
          textStyle: ThemeData.light().textTheme.titleLarge),
      titleMedium: GoogleFonts.poppins(
          textStyle: ThemeData.light().textTheme.titleMedium),
    );

    final darkTextTheme =
        GoogleFonts.openSansTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineMedium: GoogleFonts.poppins(
          textStyle: ThemeData.dark()
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white)),
      headlineSmall: GoogleFonts.poppins(
          textStyle: ThemeData.dark()
              .textTheme
              .headlineSmall
              ?.copyWith(color: Colors.white)),
      titleLarge: GoogleFonts.poppins(
          textStyle: ThemeData.dark()
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white)),
      titleMedium: GoogleFonts.poppins(
          textStyle: ThemeData.dark()
              .textTheme
              .titleMedium
              ?.copyWith(color: Colors.white)),
      bodyLarge: GoogleFonts.openSans(
          textStyle: ThemeData.dark()
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white)),
      bodyMedium: GoogleFonts.openSans(
          textStyle: ThemeData.dark()
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.white70)),
      bodySmall: GoogleFonts.openSans(
          textStyle: ThemeData.dark()
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white54)),
    );

    final lightTheme = ThemeData(
      primarySwatch: Colors.deepPurple,
      primaryColor: Colors.deepPurple,
      cardColor: Colors.white,
      scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      textTheme: lightTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.deepPurple,
          side: const BorderSide(color: Colors.deepPurple, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );

    final darkTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.deepPurple[200]!,
      colorScheme: ColorScheme.dark(
        primary: Colors.deepPurple[200]!,
        secondary: Colors.deepPurple[100]!,
        surface: const Color(0xFF1F2937),
      ),
      scaffoldBackgroundColor: const Color(0xFF111827),
      cardColor: const Color(0xFF1F2937),
      textTheme: darkTextTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF111827),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple[200]!,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.deepPurple[200]!,
          side: BorderSide(color: Colors.deepPurple[200]!, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationBloc()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Steven Nikko Asuncion | Software Developer',
            themeAnimationDuration: Duration.zero,
            themeMode: themeMode,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const SplashFadeInWrapper(child: HomePage()),
          );
        },
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
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
        const AssetImage('assets/images/SNVWorks_Logo_wText.png'), context);
    precacheImage(const AssetImage('assets/images/SNVWorks_Logo.png'), context);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
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

    _initApp();
  }

  Future<void> _initApp() async {
    final animationFuture = _controller.forward();
    final dataFuture = Future.wait([
      DataProvider().getProfileData(),
      DataProvider().getProjectsData(),
    ]);

    await animationFuture;
    await dataFuture;

    if (mounted) {
      setState(() {
        _isInitialized = true;
        _showSplash = false;
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
    return Stack(
      children: [
        if (_controller.value > 0.1 || _isInitialized)
          FadeTransition(
            opacity: _appOpacity,
            child: widget.child,
          ),

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
                        child: Column(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Theme.of(context).primaryColor,
                              highlightColor: Colors.white,
                              period: const Duration(milliseconds: 1500),
                              loop: 1,
                              child: Image.asset(
                                'assets/images/SNVWorks_Logo_wText.png',
                                height: 180,
                                color: Theme.of(context).primaryColor,
                                colorBlendMode: BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Steven Nikko Villanueva Asuncion',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ],
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
