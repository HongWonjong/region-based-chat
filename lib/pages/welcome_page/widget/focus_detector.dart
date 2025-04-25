import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

// 지도 화면을 벗어날때를 감지하는 위젯
class FocusDetector extends StatefulWidget {
  const FocusDetector({
    required this.child,
    required this.focusOnCallback,
    required this.focusOffCallback,
    super.key,
  });

  final Widget child;
  final VoidCallback? focusOnCallback;
  final VoidCallback? focusOffCallback;

  @override
  FocusDetectorState createState() => FocusDetectorState();
}

class FocusDetectorState extends State<FocusDetector> with WidgetsBindingObserver {
  final _visibilityDetectorKey = UniqueKey();

  bool _isWidgetVisible = false;

  bool _isAppInForeground = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _notifyPlaneTransition(state);
  }

  void _notifyPlaneTransition(AppLifecycleState state) {
    if (!_isWidgetVisible) {
      return;
    }

    final isAppResumed = state == AppLifecycleState.resumed;
    final wasResumed = _isAppInForeground;
    if (isAppResumed && !wasResumed) {
      _isAppInForeground = true;
      widget.focusOnCallback;
      return;
    }

    final isAppPaused = state == AppLifecycleState.paused;
    if (isAppPaused && wasResumed) {
      _isAppInForeground = false;
      widget.focusOffCallback;
    }
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
        key: _visibilityDetectorKey,
        onVisibilityChanged: (visibilityInfo) {
          final visibleFraction = visibilityInfo.visibleFraction;
          _notifyVisibilityStatusChange(visibleFraction);
        },
        child: widget.child,
      );

  void _notifyVisibilityStatusChange(double newVisibleFraction) {
    if (!_isAppInForeground) {
      return;
    }

    final wasFullyVisible = _isWidgetVisible;
    final isFullyVisible = newVisibleFraction == 1;
    if (!wasFullyVisible && isFullyVisible) {
      _isWidgetVisible = true;
      widget.focusOnCallback;
    }

    final isFullyInvisible = newVisibleFraction == 0;
    if (wasFullyVisible && isFullyInvisible) {
      _isWidgetVisible = false;

      widget.focusOffCallback;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
