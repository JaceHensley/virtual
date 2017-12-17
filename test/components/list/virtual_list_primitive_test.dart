import 'dart:html';
import 'package:over_react_test/over_react_test.dart';
import 'package:over_react/over_react.dart';
import 'package:test/test.dart';

import 'package:virtual/virtual.dart';

void main() {
  group('VirtualListPrimitive', () {
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

    test('renders the root node with correct props', () {
      var jacket = mount<VirtualListPrimitiveComponent>((VirtualListPrimitive()
        ..height = '100px'
        ..width = '200px'
        ..itemCount = 10
        ..itemSize = new Size.autoWidth(10)
        ..scrollDirection = ScrollDirection.vertical
        ..itemRenderer = (index, isScrolling) {
          return Dom.div()('Item $index');
        }
      )(), autoTearDown: false, mountNode: mountNode, attachedToDocument: true);

      expect(jacket.getNode(), hasProp('style', 'height: 100px; width: 200px; overflow: auto;'));
    });

    test('renders the inner wrapper node with correct props', () {
      var jacket = mount<VirtualListPrimitiveComponent>((VirtualListPrimitive()
        ..height = '100px'
        ..width = '200px'
        ..itemCount = 10
        ..itemSize = new Size.autoWidth(10)
        ..scrollDirection = ScrollDirection.vertical
        ..itemRenderer = (index, isScrolling) {
          return Dom.div()('Item $index');
        }
      )(), autoTearDown: false, mountNode: mountNode, attachedToDocument: true);
      var innerWrapperProps = queryByTestId(jacket.getInstance(), 'VirtualListPrimitive.innerWrapper');

      expect(innerWrapperProps, hasProp('style', 'position: relative; width: 100%; min-height: 100%; height: 100px;'));
    });

    test('renders the items wrappers with correct props', () {
      var calls = [];
      var jacket = mount<VirtualListPrimitiveComponent>((VirtualListPrimitive()
        ..height = '100px'
        ..width = '200px'
        ..itemCount = 50
        ..itemSize = new Size.autoWidth(10)
        ..scrollDirection = ScrollDirection.vertical
        ..itemRenderer = (index, isScrolling) {
          calls.add('itemRenderer');
          return Dom.div()('Item $index');
        }
      )(), autoTearDown: false, mountNode: mountNode, attachedToDocument: true);
      var allItems = queryAllByTestId(jacket.getInstance(), 'VirtualListPrimitive.child');

      expect(allItems, hasLength(10));
      expect(calls, new List.generate(10, (_) => 'itemRenderer'));

      for (var i = 0; i < allItems.length; i++) {
        expect(allItems[i], hasProp('style', 'position: absolute; left: 0px; width: 100%; top: ${i * 10}px; height: 10px;'));
      }
    });
  });
}
