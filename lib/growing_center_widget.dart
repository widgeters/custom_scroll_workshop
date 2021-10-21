import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GrowingWhenCentered extends SingleChildRenderObjectWidget {
  GrowingWhenCentered({required Widget child, Key? key}) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return GrowingWhenCenteredRenderSliver();
  }
}

class GrowingWhenCenteredRenderSliver extends RenderSliverSingleBoxAdapter {
  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    assert(this.constraints.axis == Axis.vertical);

    final SliverConstraints constraints = this.constraints;
    final BoxConstraints initialChildConstraints = constraints.asBoxConstraints();
    child!.layout(initialChildConstraints, parentUsesSize: true);

    final double initialChildExtent = child!.size.height;

    final offsetFromTop =
        (constraints.viewportMainAxisExtent - constraints.remainingPaintExtent - constraints.scrollOffset)
            .clamp(-constraints.scrollOffset, constraints.viewportMainAxisExtent);

    final relativeOffsetFromTop =
        (offsetFromTop + constraints.scrollOffset) / (constraints.viewportMainAxisExtent + constraints.scrollOffset);

    final childScale = 1 + Curves.easeInOutQuad.transform(1 - 2 * (0.5 - relativeOffsetFromTop).abs());

    final resizedChildConstraints = initialChildConstraints.tighten(
      height: initialChildExtent * childScale,
    );

    child!.layout(resizedChildConstraints, parentUsesSize: true);

    final double childExtent = child!.size.height;
    final double paintedChildSize = calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent = calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent || constraints.scrollOffset > 0.0,
    );

    setChildParentData(child!, constraints, geometry!);
  }
}
