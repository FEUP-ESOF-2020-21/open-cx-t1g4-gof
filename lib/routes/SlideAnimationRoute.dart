import 'package:flutter/material.dart';

class SlideAnimationRoute<T> extends MaterialPageRoute<T> {
  SlideAnimationRoute({
    @required WidgetBuilder builder,
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
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
    // return SlideTransition(
    //   position: Tween<Offset>(
    //     begin: const Offset(0.0, 1.0),
    //     end: Offset.zero,
    //   ).animate(animation),
    //   child: child, // child is th// e value returned by pageBuilder
    // );
  }
}
