import 'package:flutter/material.dart';

class HoverInteractiveContainer extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const HoverInteractiveContainer({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
  });

  @override
  State<HoverInteractiveContainer> createState() =>
      _HoverInteractiveContainerState();
}

class _HoverInteractiveContainerState extends State<HoverInteractiveContainer> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = _isHovered
        ? theme.primaryColor
        : (isDark ? Colors.transparent : Colors.grey[300]!);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: widget.margin,
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          decoration: BoxDecoration(
            color: _isHovered && isDark
                ? Color.lerp(theme.cardColor, theme.primaryColor, 0.05)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: theme.primaryColor
                          .withValues(alpha: isDark ? 0.4 : 0.2),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 10),
                    ),
                    if (isDark)
                      BoxShadow(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        blurRadius: 40,
                        spreadRadius: -5,
                      ),
                  ]
                : [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    )
                  ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
