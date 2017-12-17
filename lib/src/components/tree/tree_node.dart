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
import 'dart:collection';

import 'package:meta/meta.dart';

import 'package:virtual/src/components.dart';

class TreeNode<T> {
  final T content;
  final StreamController<Null> _updatesController;

  TreeNode<T> _parent;

  Size _size;

  List<TreeNode<T>> _children = [];

  bool _isCollapsed;

  bool _isSelected = false;

  int _depth = -1;

  TreeNode(this.content, {@required Size size, bool isCollapsed = false, Iterable<TreeNode<T>> children = const []}) : _size = size, _isCollapsed = isCollapsed, _updatesController = new StreamController<Null>.broadcast() {
    _addChildren(children);
  }

  // --------------------------------------------------------------------------
  // Private Utility Methods
  // --------------------------------------------------------------------------

  void _addChildren(Iterable<TreeNode<T>> newChildren) {
    for (var child in newChildren) {
      if (child.parent != null) child.parent._children.remove(child);

      child._setParent(this);

      if (!children.contains(child)) _children.add(child);
    }
  }

  void _setParent(TreeNode<T> newParent) {
    _parent = newParent;
    traverse((node) {
      node._depth = -1;
      return true;
    });
  }

  void _unsetParent() {
    _setParent(null);
  }

  void _clearChildren() {
    for (var child in children) {
      child._unsetParent();
    }

    _children = [];
  }

  void _removeChildren(Iterable<TreeNode<T>> oldChildren) {
    for (var child in oldChildren) {
      child._unsetParent();
      _children.remove(child);
    }
  }

  // --------------------------------------------------------------------------
  // Public API Methods
  // --------------------------------------------------------------------------

  Stream get stream => _updatesController.stream;

  TreeNode<T> get parent => _parent;

  bool get isBranch => !isLeaf && !isRoot;

  bool get isCollapsed => _isCollapsed;

  bool get isExpanded => !_isCollapsed;

  List<TreeNode<T>> get children => new UnmodifiableListView(_children);
  set children(Iterable<TreeNode<T>> newChildren) {
    if (newChildren == null) return;

    _clearChildren();
    _addChildren(newChildren);
    trigger();
    triggerRoot();
  }

  Size get size => _size;
  set size(Size value) {
    if (value != _size) {
      _size = value;
      triggerRoot();
    }
  }

  bool get isLeaf => children.isEmpty;

  bool get isRoot => parent == null;

  bool get isSelected => _isSelected;

  int get depth {
    if (_depth.isNegative) {
      _depth = 0;
      var node = parent;
      while (node != null) {
        _depth++;
        node = node.parent;
      }
    }

    return _depth;
  }

  void traverse(visitor(TreeNode<T> node)) {
    var queue = new Queue<TreeNode<T>>()
      ..addFirst(this);

    while (queue.isNotEmpty) {
      var node = queue.removeFirst();
      var shouldVisitChildren = visitor(node) ?? false;

      if (shouldVisitChildren) {
        node.children.reversed.forEach(queue.addFirst);
      }
    }
  }

  void addChild(TreeNode<T> newChild) {
    addChildren([newChild]);
  }

  void addChildren(Iterable<TreeNode<T>> newChildren) {
    _addChildren(newChildren);
    trigger();
    triggerRoot();
  }

  void clearChildren() {
    _clearChildren();
    trigger();
    triggerRoot();
  }

  void removeChild(TreeNode<T> oldChild) {
    removeChildren([oldChild]);
  }

  /// Remove the given nodes from the list of children and set their
  /// parents to [null] if they are in the list, otherwise ignore them.
  void removeChildren(Iterable<TreeNode<T>> oldChildren) {
    _removeChildren(oldChildren);
    trigger();
    triggerRoot();
  }

  void trigger() {
    _updatesController.add(null);
  }

  void triggerRoot() {
    if (isRoot) {
      trigger();
    } else {
      parent.triggerRoot();
    }
  }

  void select({bool exclusive: true}) {
    if (exclusive) {
      unselectAll();
    }
    _isSelected = true;
    trigger();
  }

  void unselect() {
    _isSelected = false;
    trigger();
  }

  void unselectAll() {
    if (isRoot) {
      traverse((child) {
        child.unselect();
        return true;
      });
    } else {
      parent.unselectAll();
    }
  }

  void collapse({bool all = false}) {
    if (_isCollapsed && !all) return;

    traverse((child) {
      child._isCollapsed = true;
      child.trigger();
      return all;
    });

    triggerRoot();
  }

  void expand({bool all = false}) {
    if (!_isCollapsed && !all) return;

    traverse((child) {
      child._isCollapsed = false;
      child.trigger();
      return all;
    });

    triggerRoot();
  }
}
