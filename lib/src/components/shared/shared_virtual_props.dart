import 'package:over_react/over_react.dart';

import 'package:virtual/src/components.dart';
import 'package:virtual/src/internal.dart';

@PropsMixin()
abstract class SharedVirtualProps implements UiProps, SharedVirtualCollectionProps {
  static final SharedVirtualPropsMapView defaultProps = new SharedVirtualPropsMapView({});

  @override
  Map get props;

  /// The overall height of the virtual collection.
  @requiredProp
  String height;

  /// The overall width of the virtual collection.
  @requiredProp
  String width;
}

class SharedVirtualPropsMapView extends UiPropsMixinMapView with SharedVirtualProps, SharedVirtualCollectionProps {
  SharedVirtualPropsMapView(Map map) : super(map);
}
