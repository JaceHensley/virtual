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
    ..itemRenderer = (index, isScrolling) {
      return Dom.div()(isScrolling ? 'Loading...' : 'Item $index');
    }
  )();

  react_dom.render(content, querySelector('#output'));
}