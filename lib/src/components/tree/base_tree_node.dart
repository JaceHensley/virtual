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

import 'package:virtual/src/internal.dart';
import 'package:virtual/virtual.dart';

@PropsMixin()
abstract class BaseTreeNodePropsMixin implements UiProps {
  static BaseTreeNodePropsMixinMapView defaultProps = new BaseTreeNodePropsMixinMapView({})
    ..isScrolling = false;

  @override
  Map get props;

  /// The backing `TreeNode` of this component.
  @requiredProp
  TreeNode node;

  /// The index of this component.
  @requiredProp
  int index;

  /// Whether the component is being scrolled.
  ///
  /// Default: `false`
  bool isScrolling;
}

class BaseTreeNodePropsMixinMapView extends UiPropsMixinMapView with BaseTreeNodePropsMixin {
  BaseTreeNodePropsMixinMapView(Map map) : super(map);
}

@AbstractComponent()
abstract class  BaseTreeNodeComponentMixin<T extends BaseTreeNodePropsMixin> implements UiComponent<T> {
  // --------------------------------------------------------------------------
  // Public Utility Methods
  // --------------------------------------------------------------------------

  /// The subscription that get triggered when the backing [TreeNode] updates.
  @protected
  StreamSubscription subscription;

  /// Binds [subscription] to trigger a [redraw] of this component.
  @protected
  void bindSub() {
    subscription = props.node.stream.listen((_) => redraw());
  }

  /// Unbinds [subscription].
  @protected
  void unbindSub() {
    subscription?.cancel();
    subscription = null;
  }

  // --------------------------------------------------------------------------
  // Public API Methods
  // --------------------------------------------------------------------------

  /// Trigger an expansion of this component.
  ///
  /// Set [all] to `true` to optionally expand all child nodes.
  void expand({bool all = false}) {
    props.node.expand(all: all);
  }

  /// Trigger a collapse of this component.
  ///
  /// Set [all] to `true` to optionally collapse all child nodes.
  void collapse({bool all = false}) {
    props.node.collapse(all: all);
  }

  /// Toggle the expaned state of this component.
  ///
  /// Set [all] to `true` to optionally toggle all child nodes.
  void toggle({bool all = false}) {
    if (props.node.isCollapsed) {
      expand(all: all);
    } else {
      collapse(all: all);
    }
  }
}
