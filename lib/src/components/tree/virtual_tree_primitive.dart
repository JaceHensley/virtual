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
import 'package:virtual/src/utils.dart';

@Factory()
UiFactory<VirtualTreePrimitiveProps> VirtualTreePrimitive;

@Props()
class VirtualTreePrimitiveProps extends UiProps with SharedVirtualTreeProps, SharedVirtualProps, SharedVirtualCollectionProps {
  /// The list of visible nodes.
  @requiredProp
  List<TreeNode> visibleNodes;
}

@Component()
class VirtualTreePrimitiveComponent extends UiComponent<VirtualTreePrimitiveProps> {
  StreamSubscription _nodeSubscription;
  VirtualListComponent _virtualListRef;

  VirtualListComponent get virtualListRef => _virtualListRef;

  @override
  Map getDefaultProps() => (newProps()
    ..addProps(SharedVirtualCollectionProps.defaultProps)
  );

  @override
  @mustCallSuper
  void componentWillUnmount() {
    super.componentWillUnmount();

    _nodeSubscription.cancel();
    _nodeSubscription = null;
  }

  @override
  render() {
    var itemSizeCollection = new ItemSizeCollection.variable(props.visibleNodes.map((node) => node.size).toList());

    return (VirtualList()
      ..addProps(copyUnconsumedProps())
      ..itemSizes = itemSizeCollection
      ..itemRenderer = _nodeRenderer
      ..onItemsRendered = _handleItemsRendered
      ..onListScroll = props.onTreeScroll
      ..ref = (ref) { _virtualListRef = ref; }
      ..addTestId('VirtualTreePrimitive.VirtualList')
    )();
  }

  ReactElement _nodeRenderer(int index, bool isScrolling) => props.nodeRenderer(index, isScrolling, props.visibleNodes[index]);

  void _handleItemsRendered(int startIndex, int endIndex) {
    if (props.onNodesRendered != null) {
      props.onNodesRendered(startIndex, endIndex, props.visibleNodes[startIndex], props.visibleNodes[endIndex]);
    }
  }
}
