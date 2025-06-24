import 'package:flutter/material.dart';
import 'package:match_web_app/widgets/custom_shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LazyLoadWidget extends StatefulWidget {
  final Widget child;
  final double visibilityThreshold;

  const LazyLoadWidget({
    super.key,
    required this.child,
    this.visibilityThreshold = 0.15,
  });

  @override
  State<LazyLoadWidget> createState() => _LazyLoadWidgetState();
}

class _LazyLoadWidgetState extends State<LazyLoadWidget> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.child.hashCode.toString()),
      onVisibilityChanged: (info) {
        if (!_isVisible && info.visibleFraction >= widget.visibilityThreshold) {
          setState(() => _isVisible = true);
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _isVisible
            ? widget.child
            : const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: CustomShimmer(),
              ),
      ),
    );
  }
}
