// MIT License
//
// Copyright (c) 2017 Jace Hensley
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'dart:html';

import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';

import 'package:virtual/src/components.dart';
import 'package:virtual/src/utils.dart';
import 'package:virtual/src/internal.dart';

@Factory()
UiFactory<VirtualListPrimitiveProps> VirtualListPrimitive;

@Props()
class VirtualListPrimitiveProps extends UiProps with SharedVirtualListProps, SharedVirtualCollectionProps {
  /// The scroll offset of the list.
  ///
  /// Default: `0`
  int offset;

  /// Whether the list is being scrolled.
  ///
  /// Default: `false`
  bool isScrolling;
}

@Component()
class VirtualListPrimitiveComponent extends UiComponent<VirtualListPrimitiveProps> {
  VirtualViewportComponent _viewportRef;
  SizeAndPositionManager _sizeAndPositionManager;
  Map<int, Map<String, dynamic>> _styleCache = {};

  @override
  Map getDefaultProps() => (newProps()
    ..addProps(SharedVirtualCollectionProps.defaultProps)
    ..offset = 0
    ..isScrolling = false
  );

  @mustCallSuper
  @override
  void componentWillMount() {
    super.componentWillMount();

    Size getSize(int index) {
      if (props.itemSize is ItemSizeCallback) {
        return props.itemSize(index);
      } else if (props.itemSize is List<Size>) {
        return props.itemSize[index];
      } else if (props.itemSize is Size) {
        return props.itemSize;
      } else {
        throw new PropError.value(props.itemSize, 'SharedVirtualListPrimitiveProps.itemSize');
      }
    }

    _sizeAndPositionManager = new SizeAndPositionManager(getSize, props.itemCount, props.scrollDirection);
  }

  @mustCallSuper
  @override
  void componentWillReceiveProps(Map nextProps) {
    super.componentWillReceiveProps(nextProps);

    var tNextProps = typedPropsFactory(nextProps);

    var itemPropsHaveChanged = tNextProps.itemCount != props.itemCount || tNextProps.itemSize != props.itemSize;
    var listOffsetHasChanged = tNextProps.offset != props.offset;

    if (tNextProps.itemCount != props.itemCount) {
      _sizeAndPositionManager.itemCount = tNextProps.itemCount;
    }

    if (itemPropsHaveChanged) recomputeSizes();
    if (listOffsetHasChanged) scrollToOffset(tNextProps.offset);
  }

  @override
  render() {
    Size contentSize;

    switch (props.scrollDirection) {
      case ScrollDirection.horizontal:
        contentSize = new Size.autoHeight(_sizeAndPositionManager.getTotalSize());
        break;
      case ScrollDirection.vertical:
        contentSize = new Size.autoWidth(_sizeAndPositionManager.getTotalSize());
        break;
    }

    return (VirtualViewport()
      ..addProps(copyUnconsumedProps())
      ..height = props.height
      ..width = props.width
      ..contentSize = contentSize
      ..onViewportScroll = _handleViewportScroll
      ..ref = (ref) { _viewportRef = ref; }
    )(_renderChildren());
  }

  // --------------------------------------------------------------------------
  // Private Render Methods
  // --------------------------------------------------------------------------

  List<ReactElement> _renderChildren() {
    int containerSize;

    switch (props.scrollDirection) {
      case ScrollDirection.vertical:
        containerSize = new CssValue.parse(props.height).number.toInt();
        break;
      case ScrollDirection.horizontal:
        containerSize = new CssValue.parse(props.width).number.toInt();
        break;
    }
    var visibleRange = _sizeAndPositionManager.getVisibleRange(containerSize, _getOffset(), props.overscanCount);
    var start = visibleRange.start;
    var stop = visibleRange.stop;

    var items = <ReactElement>[];

    for (var index = start; index <= stop; index++) {
      items.add(_renderChild(index));
    }

    if (props.onItemsRendered != null) {
      props.onItemsRendered(start, stop);
    }

    return items;
  }

  ReactElement _renderChild(int index) {
    return (Dom.div()
      ..style = _getItemWrapperStyle(index)
      ..key = index
      ..addTestId('VirtualListPrimitive.child')
    )(
      props.itemRenderer(index, props.isScrolling)
    );
  }

  // --------------------------------------------------------------------------
  // Private Utility Methods
  // --------------------------------------------------------------------------

  void _handleViewportScroll(SyntheticUIEvent event, Point point) {
    if (props.onListScroll != null) {
      int offset;

      switch (props.scrollDirection) {
        case ScrollDirection.horizontal:
          offset = point.x;
          break;
        case ScrollDirection.vertical:
          offset = point.y;
          break;
        default:
      }

      props.onListScroll(event, offset);
    }
  }

  int _getOffset() {
    if (_viewportRef == null) return 0;

    int offset;

    switch (props.scrollDirection) {
      case ScrollDirection.vertical:
        offset = _viewportRef.getOffset().y;
        break;
      case ScrollDirection.horizontal:
        offset = _viewportRef.getOffset().x;
        break;
    }

    return offset;
  }

  Map<String, dynamic> _getItemWrapperStyle(int index) {
    if (_styleCache[index] == null) {
      var sizeAndOffset = _sizeAndPositionManager.getSizeAndPositionForIndex(index);

      _styleCache[index] = {
        'position': 'absolute',
        'left': 0,
        'width': '100%',
        props.scrollDirection.positionStyleKey: sizeAndOffset.offset,
        props.scrollDirection.directionStyleKey: sizeAndOffset.size.ofDirection(props.scrollDirection),
      };
    }

    return _styleCache[index];
  }

  // --------------------------------------------------------------------------
  // Public API Methods
  // --------------------------------------------------------------------------

  /// Recompute the calculated sizes from [startIndex].
  void recomputeSizes([int startIndex = 0]) {
    _styleCache = {};
    _sizeAndPositionManager.resetCacheToIndex(startIndex);
  }

  void scrollToOffset(int offset) {
    Point point;

    switch (props.scrollDirection) {
      case ScrollDirection.vertical:
        point = new Point(0, offset);
        break;
      case ScrollDirection.horizontal:
        point = new Point(offset, 0);
        break;
    }

    _viewportRef.scrollToPoint(point);
  }
}
