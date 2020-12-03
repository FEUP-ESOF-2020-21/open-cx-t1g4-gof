// import 'package:flutter/material.dart';
//
// class HeroBackAnimationRoute<T> extends MaterialPageRoute<T> {
//   HeroBackAnimationRoute({
//     @required WidgetBuilder builder,
//     RouteSettings settings,
//     bool maintainState = true,
//     bool fullscreenDialog = false,
//   }) : super(
//     builder: builder,
//     maintainState: maintainState,
//     settings: settings,
//     fullscreenDialog: fullscreenDialog,
//   );
//
//   @override
//   Duration get transitionDuration => const Duration(milliseconds: 250);
//
//   @override
//   Widget buildTransitions(
//       BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
//     Animation<double> onlyForwardAnimation;
//     switch (animation.status) {
//       case AnimationStatus.reverse:
//       case AnimationStatus.dismissed:
//         onlyForwardAnimation = kAlwaysCompleteAnimation;
//         break;
//       case AnimationStatus.forward:
//       case AnimationStatus.completed:
//         onlyForwardAnimation = animation;
//         break;
//     }
//     return buildTransitions<T>(this, context, onlyForwardAnimation, secondaryAnimation, child);
//   }
// }
