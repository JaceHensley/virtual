import 'dart:html';

import 'package:over_react_test/over_react_test.dart';
import 'package:over_react/over_react.dart';
import 'package:test/test.dart';

import 'package:virtual/virtual.dart';

import 'utils.dart';

void main() {
  group('VirtualTreePrimitive', () {
    DivElement mountNode;

    setUp(() {
      mountNode = new DivElement()
        ..style.width = '1000px'
        ..style.height = '1000px';
    });

    tearDown(() {
      mountNode.remove();
      mountNode = null;
    });

    test('renders a VirtualList with correct props', () {
      var root = makeTree();
      var visibleNodes = [];

      root.traverse((node) {
        visibleNodes.add(node);
        return !node.isCollapsed;
      });

      var jacket = mount<VirtualTreePrimitiveComponent>((VirtualTreePrimitive()
        ..height = '100px'
        ..width = '200px'
        ..root = makeTree()
        ..visibleNodes = visibleNodes
        ..scrollDirection = ScrollDirection.vertical
        ..nodeRenderer = (index, isScrolling, node) {
          return Dom.div()('Item $index');
        }
      )(), autoTearDown: false, mountNode: mountNode, attachedToDocument: true);
      var virtualTreePrimitiveProps = VirtualListPrimitive(getPropsByTestId(jacket.getInstance(), 'VirtualTreePrimitive.VirtualList'));

      expect(virtualTreePrimitiveProps.itemCount, visibleNodes.length);
      expect(virtualTreePrimitiveProps.itemSize, visibleNodes.map((node) => node.size).toList());
      expect(virtualTreePrimitiveProps.itemRenderer, isNotNull);
    });
  });
}
