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

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';

import 'package:virtual/src/components.dart';

@Factory()
UiFactory<VirtualListProps> VirtualList;

@Props()
class VirtualListProps extends UiProps with SharedVirtualListProps, SharedVirtualProps, SharedVirtualCollectionProps {}

@State()
class VirtualListState extends UiState {
  /// Current scroll offset of the list.
  int offset;

  /// Whether the list is currently scrolling.
  bool isScrolling;
}

@Component()
class VirtualListComponent extends UiStatefulComponent<VirtualListProps, VirtualListState> {
  Timer _scrollingTimeout;
  VirtualListPrimitiveComponent _primitiveRef;

  @override
  Map getDefaultProps() => (newProps()
    ..addProps(SharedVirtualCollectionProps.defaultProps)
  );

  @override
  Map getInitialState() => (newState()
    ..offset = 0
    ..isScrolling = false
  );

  @mustCallSuper
  @override
  void componentWillUnmount() {
    super.componentWillUnmount();

    _scrollingTimeout.cancel();
    _scrollingTimeout = null;
  }

  @override
  render() {
    return (VirtualListPrimitive()
      ..addProps(copyUnconsumedProps())
      ..offset = state.offset
      ..isScrolling = state.isScrolling
      ..onListScroll = _handleListScroll
      ..ref = (ref) { _primitiveRef = ref; }
      ..addTestId('VirtualList.VirtualListPrimitive')
    )();
  }

  // --------------------------------------------------------------------------
  // Private Utility Methods
  // --------------------------------------------------------------------------

  void _handleListScroll(SyntheticUIEvent event, int offset) {
    scrollToOffset(offset);

    if (props.onListScroll != null) {
      props.onListScroll(event, offset);
    }
  }

  // --------------------------------------------------------------------------
  // Public API Methods
  // --------------------------------------------------------------------------

  /// Scroll the list to [offset].
  void scrollToOffset(int offset) {
    _scrollingTimeout = new Timer(const Duration(milliseconds: 50), () {
      _scrollingTimeout = null;
      if (state.isScrolling) {
        setState(newState()
          ..isScrolling = false
        );
      }
    });

    setState(newState()
      ..offset = offset
      ..isScrolling = true
    );
  }

  /// Recompute the calculated sizes from [startIndex].
  ///
  /// Proxies [VirtualListPrimitiveComponent.recomputeSizes].
  void recomputeSizes([int startIndex = 0]) {
    _primitiveRef.recomputeSizes(startIndex);
  }
}
