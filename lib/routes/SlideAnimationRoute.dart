import 'package:flutter/material.dart';

class SlideAnimationRoute<T> extends MaterialPageRoute<T> {
  final TraversalDirection direction;

  static const Map beginOffset = {
    TraversalDirection.left: const Offset(1, 0),
    TraversalDirection.up: const Offset(0, -1),
    TraversalDirection.right: const Offset(-1, 0),
    TraversalDirection.down: const Offset(0, 1),
  };

  SlideAnimationRoute({
    @required WidgetBuilder builder,
    this.direction: TraversalDirection.left,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
    builder: builder,
    maintainState: maintainState,
    settings: settings,
    fullscreenDialog: fullscreenDialog,
  );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 400);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset[direction],
        end: Offset.zero,
      ).animate(animation),
      child: child, // child is th// e value returned by pageBuilder
    );
  }
}
