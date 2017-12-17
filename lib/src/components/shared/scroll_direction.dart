import 'package:over_react/over_react.dart';

class ScrollDirection extends DebugFriendlyConstant {
  final directionStyleKey;
  final positionStyleKey;

  const ScrollDirection._(String name, this.directionStyleKey, this.positionStyleKey) : super(name);

  static const vertical = const ScrollDirection._('vertical', 'height', 'top');
  static const horizontal = const ScrollDirection._('horizontal', 'width', 'left');

  bool get isVertical => this == vertical;

  @override
  String get debugDescription => 'directionStyleKey: $directionStyleKey, positionStyleKey: $positionStyleKey';
}
