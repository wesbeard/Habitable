import 'package:flutter/material.dart';
import 'dart:math';

/*
  Created using Expandable FAB tutorial from
  https://flutter.dev/docs/cookbook/effects/expandable-fab
*/

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key key,
    this.initialOpen,
    this.distance,
    this.children,
  }) : super(key: key);

  final bool initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();

    _open = widget.initialOpen ?? false;

    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(), // Spreads the entire list
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    final theme = Theme.of(context);
    return SizedBox(
      width: 56,
      height: 56,
      child: Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        color: theme.primaryColorLight,
        child: InkWell(
          onTap: _toggle,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90 / (count - 1);

    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform:
            Matrix4.diagonal3Values(_open ? 0.7 : 1.0, _open ? 0.7 : 1.0, 1.0),
        duration: const Duration(microseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
            opacity: _open ? 0.0 : 1.0,
            curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
            duration: const Duration(microseconds: 250),
            child: FloatingActionButton(
              tooltip: 'Add a habit',
              onPressed: _toggle,
              child: const Icon(Icons.add),
            )),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
    this.onPressed,
    this.icon,
    this.tooltip,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.buttonColor,
      elevation: 4,
      child: IconTheme.merge(
        data: theme.accentIconTheme,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
          tooltip: tooltip,
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  _ExpandingActionButton({
    Key key,
    this.directionInDegrees,
    this.maxDistance,
    this.progress,
    this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (BuildContext context, Widget child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (pi / 180),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4 + offset.dx,
          bottom: 4 + offset.dy,
          width: 56,
          height: 56,
          child: Transform.rotate(
            angle: (1 - progress.value) * pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
