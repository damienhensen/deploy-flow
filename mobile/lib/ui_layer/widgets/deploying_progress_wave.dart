import 'package:flutter/material.dart';

class DeployingProgressWave extends StatefulWidget {
  final Color color;

  const DeployingProgressWave({super.key, required this.color});

  @override
  State<DeployingProgressWave> createState() => _DeployingProgressWaveState();
}

class _DeployingProgressWaveState extends State<DeployingProgressWave>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _color;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _color = ColorTween(
      begin: widget.color.withValues(alpha: 0.65),
      end: widget.color,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _color,
      builder: (context, _) {
        return ColoredBox(color: _color.value ?? widget.color);
      },
    );
  }
}
