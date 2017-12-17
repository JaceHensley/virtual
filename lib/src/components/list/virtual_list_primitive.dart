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
class VirtualListPrimitiveProps extends UiProps with SharedVirtualListProps, SharedVirtualProps {
  /// The scroll offset of the list.
  int offset;

  /// Whether the list is being scrolled.
  bool isScrolling;
}

@Component()
class VirtualListPrimitiveComponent extends UiComponent<VirtualListPrimitiveProps> {
  Element _rootNode;
  SizeAndPositionManager _sizeAndPositionManager;
  Map<int, Map<String, dynamic>> _styleCache = {};

  @override
  Map getDefaultProps() => (newProps()
    ..addProps(SharedVirtualListProps.defaultProps)
    ..addProps(SharedVirtualProps.defaultProps)
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
    if (listOffsetHasChanged) _scrollToOffset(tNextProps.offset);
  }

  @override
  render() {
    return _renderRoot(_renderInnerWrapper(_renderChildren()));
  }

  // --------------------------------------------------------------------------
  // Private Render Methods
  // --------------------------------------------------------------------------

  ReactElement _renderRoot(ReactElement inner) {
    return (Dom.div()
      ..addProps(copyUnconsumedDomProps())
      ..onScroll = _handleListScroll
      ..style = _getRootStyles()
      ..ref = (ref) { _rootNode = ref; }
    )(inner);
  }

  ReactElement _renderInnerWrapper(List<ReactElement> children) {
    return (Dom.div()
      ..style = _getInnerWrapperStyles()
    )(children);
  }

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
      props.onItemsRendered(start,stop);
    }

    return items;
  }

  ReactElement _renderChild(int index) {
    return (Dom.div()
      ..style = _getItemWrapperStyle(index)
      ..key = index
    )(
      props.itemRenderer(index, props.isScrolling)
    );
  }

  // --------------------------------------------------------------------------
  // Private Utility Methods
  // --------------------------------------------------------------------------

  void _handleListScroll(SyntheticUIEvent event) {
    if (event.target != _rootNode) return;
    if (_rootNode == null) return;

    var offset = _getOffset();

    if (offset.isNegative) return;

    if (props.onListScroll != null) {
      props.onListScroll(event, offset);
    }
  }

  int _getOffset() {
    if (_rootNode == null) return 0;

    int offset;

    switch (props.scrollDirection) {
      case ScrollDirection.vertical:
        offset = _rootNode.scrollTop;
        break;
      case ScrollDirection.horizontal:
        offset = _rootNode.scrollLeft;
        break;
    }

    return offset;
  }

  Map<String, dynamic> _getRootStyles() {
    return {
      'height': props.height,
      'width': props.width,
      'overflow': 'auto',
    }..addAll(newStyleFromProps(props));
  }

  Map<String, dynamic> _getInnerWrapperStyles() {
    return {
      'position': 'relative',
      'overflow': 'relative',
      'width': '100%',
      'minHeight': '100%',
      props.scrollDirection.directionStyleKey: _sizeAndPositionManager.getTotalSize()
    };
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

  void _scrollToOffset(int value) {
    if (_rootNode == null) return;

    switch (props.scrollDirection) {
      case ScrollDirection.vertical:
        _rootNode.scrollTop = value;
        break;
      case ScrollDirection.horizontal:
        _rootNode.scrollLeft = value;
        break;
    }
  }

  // --------------------------------------------------------------------------
  // Public API Methods
  // --------------------------------------------------------------------------

  void recomputeSizes([int startIndex = 0]) {
    _styleCache = {};
    _sizeAndPositionManager.resetCacheToIndex(startIndex);
  }
}
