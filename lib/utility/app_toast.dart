import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shows a premium animated toast overlay.
///
/// [type] controls the icon and accent colour:
///   - [ToastType.success] → green checkmark
///   - [ToastType.error]   → red close icon
enum ToastType { success, error }

class AppToast {
  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required String title,
    String? subtitle,
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 4),
  }) {
    _current?.remove();
    _current = null;

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _ToastWidget(
        title: title,
        subtitle: subtitle,
        type: type,
        duration: duration,
        onDismissed: () {
          entry.remove();
          if (_current == entry) _current = null;
        },
      ),
    );

    _current = entry;
    overlay.insert(entry);
  }
}

// ---------------------------------------------------------------------------
// Internal animated toast widget
// ---------------------------------------------------------------------------

class _ToastWidget extends StatefulWidget {
  final String title;
  final String? subtitle;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismissed;

  const _ToastWidget({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

// TickerProviderStateMixin (not Single) because we use two AnimationControllers.
class _ToastWidgetState extends State<_ToastWidget>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _progressCtrl;

  late final Animation<double> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    // ── Entrance animation ────────────────────────────────────────────────
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
    );

    _slide = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic),
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _entranceCtrl.forward();

    // ── Progress bar countdown ───────────────────────────────────────────
    _progressCtrl = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();

    // Schedule dismiss slightly before the progress bar hits zero so the
    // reverse animation finishes cleanly.
    Future.delayed(
      widget.duration - const Duration(milliseconds: 350),
      _dismiss,
    );
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (!mounted) return;
    await _entranceCtrl.reverse();
    widget.onDismissed();
  }

  Color get _accentColor => widget.type == ToastType.success
      ? Colors.green.shade600
      : Colors.red.shade600;

  IconData get _icon => widget.type == ToastType.success
      ? Icons.check_circle_rounded
      : Icons.error_rounded;

  @override
  Widget build(BuildContext context) {
    final isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Positioned(
      top: MediaQuery.paddingOf(context).top + 12,
      left: 16,
      right: 16,
      child: AnimatedBuilder(
        animation: _entranceCtrl,
        builder: (_, child) => FractionalTranslation(
          translation: Offset(0, _slide.value),
          child: Opacity(opacity: _fade.value, child: child),
        ),
        child: GestureDetector(
          onTap: _dismiss,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDark ? const Color(0xFF1E2536) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: _accentColor.withValues(alpha: 0.25),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: isDark ? 0.4 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: _accentColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AnimatedCheckIcon(
                          color: _accentColor,
                          icon: _icon,
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black87,
                                  height: 1.3,
                                ),
                              ),
                              if (widget.subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  widget.subtitle!,
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.grey[600],
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _dismiss,
                          child: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: isDark
                                ? Colors.white30
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Progress bar — driven by _progressCtrl (1.0 → 0.0)
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: AnimatedBuilder(
                      animation: _progressCtrl,
                      builder: (_, __) => LinearProgressIndicator(
                        value: 1.0 - _progressCtrl.value,
                        minHeight: 3,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation(_accentColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bouncing icon with elastic scale-in entrance
// ---------------------------------------------------------------------------

class _AnimatedCheckIcon extends StatefulWidget {
  final Color color;
  final IconData icon;
  const _AnimatedCheckIcon({required this.color, required this.icon});

  @override
  State<_AnimatedCheckIcon> createState() => _AnimatedCheckIconState();
}

class _AnimatedCheckIconState extends State<_AnimatedCheckIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    Future.delayed(const Duration(milliseconds: 150), _ctrl.forward);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withValues(alpha: 0.12),
        ),
        child: Icon(widget.icon, color: widget.color, size: 20),
      ),
    );
  }
}
