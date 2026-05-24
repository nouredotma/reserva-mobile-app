import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reservamobile/app/router/app_router.dart';
import 'package:reservamobile/core/assets/app_assets.dart';
import 'package:reservamobile/core/bootstrap/bootstrap_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final BootstrapService _bootstrapService = BootstrapService();
  late final AnimationController _controller;
  late final Animation<double> _reveal;
  late final Animation<double> _shift;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _reveal = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _shift = Tween<double>(begin: 91, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _controller.forward();
    _runBootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runBootstrap() async {
    await _bootstrapService.initialize();
    await Future<void>.delayed(const Duration(milliseconds: 3000));
    if (!mounted) {
      return;
    }
    context.go(AppRoute.shell);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const _TileTexture(top: -16, right: -16, width: 210, rotation: 0.2),
          const _TileTexture(top: -20, left: -20, width: 180, rotation: -0.45),
          const _TileTexture(
            bottom: -16,
            right: -12,
            width: 200,
            rotation: 0.7,
          ),
          const _TileTexture(
            bottom: -20,
            left: -16,
            width: 190,
            rotation: -0.28,
          ),
          const _TileTexture(top: 260, right: -24, width: 150, rotation: 1.05),
          const _TileTexture(
            bottom: 180,
            left: -24,
            width: 145,
            rotation: -0.9,
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: _reveal.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(_shift.value, 0),
                      child: child,
                    ),
                  ),
                );
              },
              child: Image.asset(
                AppAssets.logo,
                width: 280,
                fit: BoxFit.contain,
                semanticLabel: 'Reserva logo',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TileTexture extends StatelessWidget {
  const _TileTexture({
    this.top,
    this.right,
    this.bottom,
    this.left,
    required this.width,
    required this.rotation,
  });

  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final double width;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Transform.rotate(
        angle: rotation,
        child: Opacity(
          opacity: 0.5,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            child: IgnorePointer(
              child: Image.asset(
                AppAssets.tileJpg,
                width: width,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
