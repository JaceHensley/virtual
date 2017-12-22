import 'dart:html';

import 'package:over_react/over_react.dart';

import 'package:virtual/src/components.dart';
import 'package:virtual/src/utils.dart';

@Factory()
UiFactory<VirtualViewportProps> VirtualViewport;

@Props()
class VirtualViewportProps extends UiProps {
  /// The size of the content within the virutal viewport.
  Size contentSize;

  /// The overall height of the virtual viewport.
  @requiredProp
  String height;

  /// The overall width of the virtual viewport.
  @requiredProp
  String width;

  /// Optional callback that is called when the list is scrolled.
  ViewportScrollCalback onViewportScroll;
}

@Component()
class VirtualViewportComponent extends UiComponent<VirtualViewportProps> {
  // Refs
  DivElement _rootNode;

  // --------------------------------------------------------------------------
  // React Component Specifications and Lifecycle Methods
  // --------------------------------------------------------------------------

  @override
  Map getDefaultProps() => (newProps());

  @override
  render() {
    return _renderViewport(_renderContent());
  }

  // --------------------------------------------------------------------------
  // Private Render Methods
  // --------------------------------------------------------------------------

  ReactElement _renderViewport(ReactElement content) {
    return (Dom.div()
      ..onScroll = _handleViewportScroll
      ..style = _getViewportStyles()
      ..ref = (ref) { _rootNode = ref; }
    )(content);
  }

  ReactElement _renderContent() {
    return (Dom.div()
      ..style = _getConentWrapperStyles()
    )(props.children);
  }

  // --------------------------------------------------------------------------
  // Private Utility Methods
  // --------------------------------------------------------------------------

  Map<String, dynamic> _getViewportStyles() {
    return {
      'height': props.height,
      'width': props.width,
      'overflow': 'auto',
    }..addAll(newStyleFromProps(props));
  }

  Map<String, dynamic> _getConentWrapperStyles() {
    return {
      'position': 'relative',
      'minHeight': '100%',
      'minWidth': '100%',
      'height': props.contentSize.height ?? '100%',
      'width': props.contentSize.width ?? '100%',
    };
  }

  void _handleViewportScroll(SyntheticUIEvent event) {
    if (event.target != _rootNode) return;
    if (_rootNode == null) return;

    var point = new Point(_rootNode.scrollTop, _rootNode.scrollLeft);

    if (point.x.isNegative || point.y.isNegative) return;

    if (props.onViewportScroll != null) {
      props.onViewportScroll(event, point);
    }
  }

  // --------------------------------------------------------------------------
  // Public API Methods
  // --------------------------------------------------------------------------

  void scrollToPoint(Point point) {
    if (_rootNode == null) return;

    _rootNode
      ..scrollLeft = point.x
      ..scrollTop = point.y;
  }

  Point getOffset() {
    if (_rootNode == null) return const Point(0, 0);

    return new Point(_rootNode.scrollLeft, _rootNode.scrollTop);
  }
}
