import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reservamobile/core/assets/app_assets.dart';
import 'package:reservamobile/core/bootstrap/native_splash.dart';

/// Branded splash matching the web app's mobile preloader (`preloader.tsx`).
class SplashPreloader extends StatefulWidget {
  const SplashPreloader({required this.onComplete, super.key});

  final VoidCallback onComplete;

  @override
  State<SplashPreloader> createState() => _SplashPreloaderState();
}

class _SplashPreloaderState extends State<SplashPreloader>
    with TickerProviderStateMixin {
  static const Duration _displayDuration = Duration(seconds: 3);
  static const Duration _logoDuration = Duration(milliseconds: 2400);
  static const Duration _exitDuration = Duration(milliseconds: 700);

  static const List<_TileSpec> _tiles = <_TileSpec>[
    _TileSpec(top: -64, right: -64, width: 200, rotation: 12),
    _TileSpec(top: -80, left: -80, width: 170, rotation: -25),
    _TileSpec(bottom: -64, right: -48, width: 190, rotation: 40),
    _TileSpec(bottom: -80, left: -64, width: 180, rotation: -15),
    _TileSpec(topFraction: 1 / 3, right: -96, width: 150, rotation: 60),
    _TileSpec(bottomFraction: 0.25, left: -96, width: 140, rotation: -50),
  ];

  late final AnimationController _logoController;
  late final AnimationController _exitController;
  late final Animation<double> _revealFactor;
  late final Animation<double> _logoShift;
  late final Animation<double> _fadeOpacity;

  Timer? _exitTimer;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(vsync: this, duration: _logoDuration);
    _exitController = AnimationController(vsync: this, duration: _exitDuration);

    final Curve logoCurve = const Cubic(0.25, 0.1, 0.25, 1);
    final Curve exitCurve = const Cubic(0.76, 0, 0.24, 1);

    _revealFactor = Tween<double>(begin: 0.35, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: logoCurve),
    );
    _logoShift = Tween<double>(begin: 91, end: 0).animate(
      CurvedAnimation(parent: _logoController, curve: logoCurve),
    );
    _fadeOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _exitController, curve: exitCurve),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NativeSplash.remove();
      _logoController.forward();
      _exitTimer = Timer(_displayDuration, _startExit);
    });
  }

  Future<void> _startExit() async {
    if (!mounted) return;
    await _exitController.forward();
    if (mounted) {
      widget.onComplete();
    }
  }

  @override
  void dispose() {
    _exitTimer?.cancel();
    _logoController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeOpacity,
      child: ColoredBox(
        color: Colors.white,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            for (final _TileSpec tile in _tiles)
              _DecorativeTile(spec: tile),
            Center(
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                    offset: Offset(_logoShift.value, 0),
                    child: ClipRect(
                      clipper: _HorizontalRevealClipper(_revealFactor.value),
                      child: child,
                    ),
                  );
                },
                child: Image.asset(
                  AppAssets.logoWebp,
                  width: 200,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TileSpec {
  const _TileSpec({
    this.top,
    this.bottom,
    this.left,
    this.right,
    this.topFraction,
    this.bottomFraction,
    required this.width,
    required this.rotation,
  });

  final double? top;
  final double? bottom;
  final double? left;
  final double? right;
  final double? topFraction;
  final double? bottomFraction;
  final double width;
  final double rotation;
}

class _DecorativeTile extends StatelessWidget {
  const _DecorativeTile({required this.spec});

  final _TileSpec spec;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: spec.topFraction != null
          ? MediaQuery.sizeOf(context).height * spec.topFraction!
          : spec.top,
      bottom: spec.bottomFraction != null
          ? MediaQuery.sizeOf(context).height * spec.bottomFraction!
          : spec.bottom,
      left: spec.left,
      right: spec.right,
      child: Transform.rotate(
        angle: spec.rotation * 3.141592653589793 / 180,
        child: Opacity(
          opacity: 0.5,
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            child: Image.asset(
              AppAssets.tile,
              width: spec.width,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
      ),
    );
  }
}

class _HorizontalRevealClipper extends CustomClipper<Rect> {
  _HorizontalRevealClipper(this.revealFactor);

  final double revealFactor;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * revealFactor, size.height);
  }

  @override
  bool shouldReclip(_HorizontalRevealClipper oldClipper) {
    return oldClipper.revealFactor != revealFactor;
  }
}
