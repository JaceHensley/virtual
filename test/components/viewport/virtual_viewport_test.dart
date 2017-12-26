import 'dart:html';

import 'package:over_react_test/over_react_test.dart';
import 'package:test/test.dart';

import 'package:virtual/virtual.dart';

void main() {
  group('VirtualViewport', () {
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
      var jacket = mount<VirtualViewportComponent>((VirtualViewport()
        ..height = '100px'
        ..width = '200px'
        ..contentSize = new Size(10000, 10000)
      )(), autoTearDown: false, mountNode: mountNode, attachedToDocument: true);

      expect(jacket.getNode(), hasProp('style', 'height: 100px; width: 200px; overflow: auto;'));
    });

    test('renders the content wrapper node with correct props', () {
      var jacket = mount<VirtualViewportComponent>((VirtualViewport()
        ..height = '100px'
        ..width = '200px'
        ..contentSize = new Size(10000, 10000)
      )(), autoTearDown: false, mountNode: mountNode, attachedToDocument: true);
      var contentWrapper = queryByTestId(jacket.getInstance(), 'VirtualViewport.contentWrapper');

      expect(contentWrapper, hasProp('style', 'position: relative; min-height: 100%; min-width: 100%; height: 10000px; width: 10000px;'));
    });
  });
}
