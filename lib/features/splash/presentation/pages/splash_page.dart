import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/motion.dart';
import '../../../../core/widgets/constellation_view.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';
import '../../../zodiac/presentation/constellations.dart';

/// Brief branded intro: the constellation of the current Sun sign draws
/// itself, then the app moves on to Today.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer ??= Timer(
      reduceMotionOf(context)
          ? const Duration(milliseconds: 600)
          : const Duration(milliseconds: 2400),
      () {
        if (mounted) context.go(AppRoutes.today);
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final sign = ZodiacSign.fromDate(DateTime.now());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 200,
              child: ExcludeSemantics(
                child: ConstellationView(shape: sign.constellation),
              ),
            ),
            const SizedBox(height: 28),
            FadeSlideIn(
              delay: const Duration(milliseconds: 600),
              child: Text(l10n.appTitle, style: theme.textTheme.headlineMedium),
            ),
            const SizedBox(height: 8),
            FadeSlideIn(
              delay: const Duration(milliseconds: 900),
              child: Text(
                l10n.splashTagline,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
