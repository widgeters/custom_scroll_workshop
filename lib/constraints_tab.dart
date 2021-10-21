import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ConstraintsTab extends StatefulWidget {
  @override
  State<ConstraintsTab> createState() => _ConstraintsTabState();
}

class _ConstraintsTabState extends State<ConstraintsTab> {
  SliverConstraints? constraints;
  SliverGeometry? geometry;

  void _updateChildContext(BuildContext? childContext) {
    if (childContext == null) {
      setState(() {
        constraints = null;
        geometry = null;
      });
    } else {
      final childRenderObject = childContext.findRenderObject();
      if (childRenderObject is! RenderSliver) {
        debugPrint(
            'RenderObject is not a RenderSliver! (is $childRenderObject)');
      } else {
        setState(() {
          constraints = childRenderObject.constraints;
          geometry = childRenderObject.geometry;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: SimpleScroll(childContextCallback: _updateChildContext)),
        const SizedBox(width: 16),
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 16),
              DisplayProps(
                title: Text('SliverConstraints',
                    style: Theme.of(context).textTheme.headline5),
                props: {
                  'axisDirection': constraints?.axisDirection,
                  'growthDirection': constraints?.growthDirection,
                  'userScrollDirection': constraints?.userScrollDirection,
                  'scrollOffset': constraints?.scrollOffset,
                  'precedingScrollExtent': constraints?.precedingScrollExtent,
                  'overlap': constraints?.overlap,
                  'remainingPaintExtent': constraints?.remainingPaintExtent,
                  'crossAxisExtent': constraints?.crossAxisExtent,
                  'crossAxisDirection': constraints?.crossAxisDirection,
                  'viewportMainAxisExtent': constraints?.viewportMainAxisExtent,
                  'remainingCacheExtent': constraints?.remainingCacheExtent,
                  'cacheOrigin': constraints?.cacheOrigin,
                },
                highlightProps: {
                  'remainingPaintExtent',
                  'remainingCacheExtent',
                  'cacheOrigin',
                  'scrollOffset',
                  'viewportMainAxisExtent',
                },
              ),
              const SizedBox(height: 8),
              DisplayProps(
                title: Text('SliverGeometry',
                    style: Theme.of(context).textTheme.headline5),
                props: {
                  'cacheExtent': geometry?.cacheExtent,
                  'hasVisualOverflow': geometry?.hasVisualOverflow,
                  'hitTestExtent': geometry?.hitTestExtent,
                  'layoutExtent': geometry?.layoutExtent,
                  'maxPaintExtent': geometry?.maxPaintExtent,
                  'maxScrollObstructionExtent':
                      geometry?.maxScrollObstructionExtent,
                  'paintExtent': geometry?.paintExtent,
                  'paintOrigin': geometry?.paintOrigin,
                  'scrollExtent': geometry?.scrollExtent,
                  'scrollOffsetCorrection': geometry?.scrollOffsetCorrection,
                  'visible': geometry?.visible,
                },
                highlightProps: {
                  'cacheExtent',
                  'layoutExtent',
                  'paintExtent',
                  'paintOrigin',
                  'scrollExtent',
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        )
      ],
    );
  }
}

class SimpleScroll extends StatefulWidget {
  static const cacheExtent = 100.0;

  final void Function(BuildContext?) childContextCallback;

  SimpleScroll({required this.childContextCallback});

  @override
  State<SimpleScroll> createState() => _SimpleScrollState();
}

class _SimpleScrollState extends State<SimpleScroll> {
  final controller = ScrollController();
  final childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      widget.childContextCallback(childKey.currentContext);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      cacheExtent: SimpleScroll.cacheExtent,
      slivers: [
        SliverToBoxAdapter(
          child: Placeholder(
            fallbackHeight:
                MediaQuery.of(context).size.height + SimpleScroll.cacheExtent,
          ),
        ),
        SliverToBoxAdapter(
          key: childKey,
          child: Container(
            height: SimpleScroll.cacheExtent * 2,
            color: Colors.red,
          ),
        ),
        SliverToBoxAdapter(
          child: Placeholder(
            fallbackHeight:
                MediaQuery.of(context).size.height + SimpleScroll.cacheExtent,
          ),
        ),
      ],
    );
  }
}

class DisplayProps extends StatelessWidget {
  final Widget title;
  final Map<String, dynamic> props;
  final Set<String> highlightProps;

  DisplayProps({
    required this.title,
    required this.props,
    required this.highlightProps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        title,
        for (final propName in [...props.keys]..sort((a, b) => a.compareTo(b)))
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: highlightProps.contains(propName)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                children: [
                  TextSpan(
                    text: '$propName: ',
                    style: highlightProps.contains(propName)
                        ? TextStyle(fontWeight: FontWeight.bold)
                        : null,
                  ),
                  TextSpan(text: '${props[propName]}'),
                ],
              ),
            ),
          )
      ],
    );
  }
}
