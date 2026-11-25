import 'package:flutter/widgets.dart';

/// Whether the user asked the OS to reduce motion
/// (iOS "Reduce Motion", Android "Remove animations").
bool reduceMotionOf(BuildContext context) =>
    MediaQuery.maybeDisableAnimationsOf(context) ?? false;
