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

import 'dart:html';

import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';
import 'package:resize_observer_polyfill_wrapper/resize_observer_polyfill_wrapper.dart' as ro;

@Factory()
UiFactory<ResizeObserverProps> ResizeObserver;

@Props()
class ResizeObserverProps extends UiProps {
  ResizeCallback onResize;
}

@Component()
class ResizeObserverComponent extends UiComponent<ResizeObserverProps> {
  Element _childRef;
  ro.ResizeObserver _resizeObserver;

  @override
  void componentDidMount() {
    _resizeObserver = new ro.ResizeObserver(_resizeObserverCallback)
      ..observe(_childRef);
  }

  @mustCallSuper
  @override
  void componentWillUnmount() {
    super.componentWillUnmount();

    _resizeObserver
      ..unobserve(_childRef)
      ..disconnect();
  }

  @override
  @mustCallSuper
  void validateProps(Map propsMap) {
    super.validateProps(propsMap);

    var tPropsMap = typedPropsFactory(propsMap);

    if (tPropsMap.children.length != 1) {
      throw new PropError.value(tPropsMap.children, 'children', 'ResizeObserver expects a single child.');
    }
  }

  @override
  render() {
    var propsToAdd = domProps()
      ..ref = chainRef(props.children.single, (ref) { _childRef = findDomNode(ref); });

    return cloneElement(props.children.single, propsToAdd);
  }

  void _resizeObserverCallback(List<ro.ResizeObserverEntry> entries, _) {
    for (var entry in entries) {
      if (entry.target == _childRef && props.onResize != null) props.onResize(entry.rectangle);
    }
  }
}

typedef void ResizeCallback(Rectangle rectangle);
