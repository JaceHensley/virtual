import 'dart:async';
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

    group('renders a VirtualListPrimitive with correct props', () {
      test('by default', () {
        var jacket = mount<VirtualListComponent>((VirtualList()
          ..height = '100px'
          ..width = '200px'
          ..itemSizes = new ItemSizeCollection.fixed(10, new Size.autoWidth(10))
          ..scrollDirection = ScrollDirection.vertical
          ..itemRenderer = (index, isScrolling) {
            return Dom.div()('Item $index');
          }
        )(), autoTearDown: false, mountNode: mountNode, attachedToDocument: true);
        var primitiveProps = VirtualListPrimitive(getPropsByTestId(jacket.getInstance(), 'VirtualList.VirtualListPrimitive'));

        expect(primitiveProps.offset, isZero);
        expect(primitiveProps.isScrolling, isFalse);
        expect(primitiveProps.onListScroll, isNotNull);
      });

      test('when state.offset is non-zero', () {
        var jacket = mount<VirtualListComponent>((VirtualList()
          ..height = '100px'
          ..width = '200px'
          ..itemSizes = new ItemSizeCollection.fixed(10, new Size.autoWidth(10))
          ..scrollDirection = ScrollDirection.vertical
          ..itemRenderer = (index, isScrolling) {
            return Dom.div()('Item $index');
          }
        )(), autoTearDown: false, mountNode: mountNode, attachedToDocument: true);
        jacket.setState(jacket.getDartInstance().newState()..offset = 10);
        var primitiveProps = VirtualListPrimitive(getPropsByTestId(jacket.getInstance(), 'VirtualList.VirtualListPrimitive'));

        expect(primitiveProps.offset, 10);
      });

      test('when state.isScrolling is true', () {
        var jacket = mount<VirtualListComponent>((VirtualList()
          ..height = '100px'
          ..width = '200px'
          ..itemSizes = new ItemSizeCollection.fixed(10, new Size.autoWidth(10))
          ..scrollDirection = ScrollDirection.vertical
          ..itemRenderer = (index, isScrolling) {
            return Dom.div()('Item $index');
          }
        )(), autoTearDown: false, mountNode: mountNode, attachedToDocument: true);
        jacket.setState(jacket.getDartInstance().newState()..isScrolling = true);
        var primitiveProps = VirtualListPrimitive(getPropsByTestId(jacket.getInstance(), 'VirtualList.VirtualListPrimitive'));

        expect(primitiveProps.isScrolling, isTrue);
      });
    });

    test('correctly updates state when onListScroll is triggered', () async {
      var jacket = mount<VirtualListComponent>((VirtualList()
        ..height = '100px'
        ..width = '200px'
        ..itemSizes = new ItemSizeCollection.fixed(10, new Size.autoWidth(10))
        ..scrollDirection = ScrollDirection.vertical
        ..itemRenderer = (index, isScrolling) {
          return Dom.div()('Item $index');
        }
      )(), autoTearDown: false, mountNode: mountNode, attachedToDocument: true);
      var primitiveProps = VirtualListPrimitive(getPropsByTestId(jacket.getInstance(), 'VirtualList.VirtualListPrimitive'));

      primitiveProps.onListScroll(null, 10);

      expect(jacket.getDartInstance().state.offset, 10);
      expect(jacket.getDartInstance().state.isScrolling, isTrue);

      await new Future.delayed(const Duration(milliseconds: 50));

      expect(jacket.getDartInstance().state.isScrolling, isFalse);
    });
  });
}
