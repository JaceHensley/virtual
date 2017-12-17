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

import 'package:over_react/over_react.dart';

import 'package:virtual/src/components.dart';
import 'package:virtual/src/utils.dart';
import 'package:virtual/src/internal.dart';

@PropsMixin()
abstract class SharedVirtualProps implements UiProps {
  static final SharedVirtualPropsMapView defaultProps = new SharedVirtualPropsMapView({})
    ..overscanCount = 0;

  @override
  Map get props;

  /// The overall height of the VirtualListPrimitive
  @requiredProp
  String height;

  /// The overall width of the VirtualListPrimitive
  @requiredProp
  String width;

  /// Which direction the virtual scrolls, either vertical or horizontal.
  @requiredProp
  ScrollDirection scrollDirection;

  /// The number of extra items to be rendered outside the visible items.
  int overscanCount;

  /// Optional callback that is called when new items are rendered.
  ItemScrolledCalback onItemsRendered;

  /// Optional callback that is called when the list is scrolled.
  ListScrollCalback onListScroll;
}

class SharedVirtualPropsMapView extends UiPropsMixinMapView with SharedVirtualProps {
  SharedVirtualPropsMapView(Map map) : super(map);
}
