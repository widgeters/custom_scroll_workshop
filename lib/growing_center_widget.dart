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
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);

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
