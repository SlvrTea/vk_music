
import 'package:flutter/widgets.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

enum PlayStatus {
  trackPlaying,
  trackInPause,
  submissionFailure,
  empty,
}