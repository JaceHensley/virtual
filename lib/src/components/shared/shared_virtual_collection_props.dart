import 'package:over_react/over_react.dart';

import 'package:virtual/src/components.dart';
import 'package:virtual/src/internal.dart';

@PropsMixin()
abstract class SharedVirtualCollectionProps implements UiProps {
  static final SharedVirtualCollectionPropsMapView defaultProps = new SharedVirtualCollectionPropsMapView({})
    ..overscanCount = 0;

  @override
  Map get props;

  /// The overall height of the virtual collection.
  @requiredProp
  String height;

  /// The overall width of the virtual collection.
  @requiredProp
  String width;

  /// Which direction the virtual scrolls, either vertical or horizontal.
  @requiredProp
  ScrollDirection scrollDirection;

  /// The number of extra items to be rendered outside the visible items.
  int overscanCount;
}

class SharedVirtualCollectionPropsMapView extends UiPropsMixinMapView with SharedVirtualCollectionProps {
  SharedVirtualCollectionPropsMapView(Map map) : super(map);
}
