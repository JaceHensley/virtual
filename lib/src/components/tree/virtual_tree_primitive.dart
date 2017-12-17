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
UiFactory<VirtualTreePrimitiveProps> VirtualTreePrimitive;

@Props()
class VirtualTreePrimitiveProps extends UiProps with SharedVirtualTreeProps {
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
    ..addProps(SharedVirtualProps.defaultProps)
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
    return _renderList();
  }

  // --------------------------------------------------------------------------
  // Private Render Methods
  // --------------------------------------------------------------------------

  ReactElement _renderList() {
    return (VirtualList()
      ..addProps(copyUnconsumedProps())
      ..itemCount = props.visibleNodes.length
      ..itemSize = props.visibleNodes.map((node) => node.size).toList()
      ..itemRenderer = _nodeRenderer
      ..ref = (ref) { _virtualListRef = ref; }
    )();
  }

  ReactElement _nodeRenderer(int index) => props.nodeRenderer(index, props.visibleNodes[index]);
}
