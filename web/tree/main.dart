import 'dart:html';

import 'package:react/react_dom.dart' as react_dom;
import 'package:over_react/over_react.dart';

import 'package:virtual/virtual.dart';

import 'node.dart' as tree;

void main() {
  setClientConfiguration();

  var root = makeTree();

  var content = (VirtualTree()
    ..scrollDirection = ScrollDirection.vertical
    ..height = '500px'
    ..width = 'auto'
    ..overscanCount = 100
    ..root = root
    ..nodeRenderer = (index, isScrolling, node) {
      return (tree.Node()
        ..isScrolling = isScrolling
        ..key = index
        ..index = index
        ..node = node
      )();
    }
  )();

  react_dom.render(content, querySelector('#output'));
}

TreeNode makeTree() {
  var nodes = <TreeNode>[];

  for (var i = 0; i < 100; i++) {
    if (i % 3 == 0) {
      nodes.add(new TreeNode('$i', size: new Size.autoWidth(30)));
    } else if (i % 3 == 1) {
      nodes.add(new TreeNode('$i',
          children: [
            new TreeNode('$i.a', size: new Size.autoWidth(30)),
            new TreeNode('$i.b', size: new Size.autoWidth(30))
          ],
          size: new Size.autoWidth(30)));
    } else if (i % 3 == 2) {
      nodes.add(new TreeNode('$i',
          children: [
            new TreeNode('$i.a', size: new Size.autoWidth(30)),
            new TreeNode('$i.b',
                children: [
                  new TreeNode('$i.b.i', size: new Size.autoWidth(30)),
                  new TreeNode('$i.b.ii', size: new Size.autoWidth(30)),
                  new TreeNode('$i.b.iii', size: new Size.autoWidth(30))
                ],
                size: new Size.autoWidth(30))
          ],
          size: new Size.autoWidth(30)));
    }
  }

  return new TreeNode('Root Node', children: nodes, size: new Size.autoWidth(30));
}

