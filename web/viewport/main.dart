import 'dart:html';

import 'package:react/react_dom.dart' as react_dom;
import 'package:over_react/over_react.dart';

import 'package:virtual/virtual.dart';

void main() {
  setClientConfiguration();

  var content = (VirtualViewport()
    ..contentSize = new Size(10000, 10000)
    ..height = '1000px'
    ..width = '1000px'
  )(
    (Dom.div()..className = 'content')(
      (Dom.div()..className = 'position__label position__label--nw')('top left'),
      (Dom.div()..className = 'position__label position__label--ne')('top right'),
      (Dom.div()..className = 'position__label position__label--se')('bottom right'),
      (Dom.div()..className = 'position__label position__label--sw')('bottom left'),
    ),
  );

  react_dom.render(content, querySelector('#output'));
}
