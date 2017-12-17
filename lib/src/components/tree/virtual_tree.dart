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

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';

import 'package:virtual/src/components.dart';

@Factory()
UiFactory<VirtualTreeProps> VirtualTree;

@Props()
class VirtualTreeProps extends UiProps with SharedVirtualProps, SharedVirtualTreeProps {}

@State()
class VirtualTreeState extends UiState {
  /// The list of currently visible nodes.
  List<TreeNode> visibleNodes;
}

@Component()
class VirtualTreeComponent extends UiStatefulComponent<VirtualTreeProps, VirtualTreeState> {
  StreamSubscription _nodeSubscription;
  VirtualTreePrimitiveComponent _primitiveRef;

  VirtualTreePrimitiveComponent get primitiveRef => _primitiveRef;

  @override
  Map getDefaultProps() => (newProps()
    ..addProps(SharedVirtualProps.defaultProps)
  );

  @override
  Map getInitialState() => (newState()
    ..visibleNodes = const <TreeNode>[]
  );

  @override
  void componentWillMount() {
    super.componentWillMount();

    _setVisibleNodes();
  }

  @override
  void componentDidMount() {
    _nodeSubscription = props.root.stream.listen(_handleRootNodeTrigger);
  }

  @override
  @mustCallSuper
  void componentWillReceiveProps(Map nextProps) {
    super.componentWillReceiveProps(nextProps);

    var tNextProps = typedPropsFactory(nextProps);

    _setVisibleNodes(tNextProps.root);

    if (tNextProps.root != props.root) {
      _nodeSubscription.cancel();
      _nodeSubscription = tNextProps.root.stream.listen(_handleRootNodeTrigger);
    }
  }

  @override
  @mustCallSuper
  void componentWillUnmount() {
    super.componentWillUnmount();

    _nodeSubscription.cancel();
    _nodeSubscription = null;
  }

  @override
  render() {
    return (VirtualTreePrimitive()
      ..addProps(copyUnconsumedProps())
      ..visibleNodes = state.visibleNodes
      ..ref = (ref) { _primitiveRef = ref; }
      ..addTestId('VirtualTree.VirtualTreePrimitive')
    )();
  }

  // --------------------------------------------------------------------------
  // Private Utility Methods
  // --------------------------------------------------------------------------

  void _handleRootNodeTrigger(_) {
    _setVisibleNodes();
  }

  void _setVisibleNodes([TreeNode root]) {
    root ??= props.root;

    var visibleNodes = <TreeNode>[];

    root.traverse((node) {
      visibleNodes.add(node);
      return !node.isCollapsed;
    });

    // If the visible nodes haven't changed, short circuit.
    if (!const ListEquality().equals(state.visibleNodes, visibleNodes)) {
      setState(newState()..visibleNodes = visibleNodes);
    }
  }
}
