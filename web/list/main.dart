import 'dart:html';

import 'package:react/react_dom.dart' as react_dom;
import 'package:over_react/over_react.dart';

import 'package:virtual/virtual.dart';

void main() {
  setClientConfiguration();

  var content = (VirtualList()
    ..itemSize = new Size.autoWidth(34)
    ..scrollDirection = ScrollDirection.vertical
    ..height = '500px'
    ..width = 'auto'
    ..overscanCount = 100
    ..itemCount = 10000
    ..itemRenderer = (index) {
      return Dom.div()('Item $index');
    }
    ..scrollingItemRenderer = (index) {
      return Dom.div()('Loding...');
    }
  )();

  react_dom.render(content, querySelector('#output'));
}
