import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'growing_center_widget.dart';

class CustomScrollTab extends StatelessWidget {
  static const _colors = Colors.primaries;

  const CustomScrollTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 26, color: Colors.white),
      child: CustomScrollView(
        clipBehavior: Clip.none,
        // center: ValueKey(_colors[_colors.length ~/2]),
        slivers: [
          SliverFillViewport(
            key: ValueKey('first'),
            delegate: SliverChildListDelegate(
              [PurpleLabel(text: 'Get ready')],
            ),
          ),
          for (final color in _colors)
            GrowingWhenCentered(
              key: ValueKey(color),
              child: ColoredBar(
                color: color,
                text: '#${_colors.indexOf(color)}',
              ),
            ),
          SliverFillViewport(
            key: ValueKey('last'),
            delegate: SliverChildListDelegate(
              [PurpleLabel(text: 'That\'s all, folks!')],
            ),
          ),
        ],
      ),
    );
  }
}

class ColoredBar extends StatelessWidget {
  const ColoredBar({
    Key? key,
    required this.color,
    required this.text,
  }) : super(key: key);

  final MaterialColor color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      child: LimitedBox(
        maxHeight: 128,
        child: Container(
          clipBehavior: Clip.none,
          padding: const EdgeInsets.all(16),
          color: color,
          alignment: Alignment.center,
          child: Text(text),
        ),
      ),
    );
  }
}

class PurpleLabel extends StatelessWidget {
  final String text;

  const PurpleLabel({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      color: Colors.white,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.purple),
        ),
      ),
    );
  }
}
