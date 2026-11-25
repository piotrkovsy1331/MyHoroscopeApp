import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/l10n_extension.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../domain/entities/zodiac_sign.dart';
import '../widgets/sign_tile.dart';

class SignsPage extends StatelessWidget {
  const SignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    // Fewer, taller tiles for large accessibility text sizes.
    final columns = width >= 600 ? 4 : (textScale > 1.3 ? 2 : 3);
    // Glyph + paddings are fixed; the two text lines grow with the scale.
    final tileHeight = 96 + 44 * textScale;

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.signsTitle)),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: tileHeight,
        ),
        itemCount: ZodiacSign.values.length,
        itemBuilder: (context, index) {
          final sign = ZodiacSign.values[index];
          return FadeSlideIn(
            delay: Duration(milliseconds: 40 * index),
            child: SignTile(
              sign: sign,
              onTap: () => context.push(AppRoutes.signDetail(sign.id)),
            ),
          );
        },
      ),
    );
  }
}
