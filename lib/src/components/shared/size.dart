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

import 'package:virtual/src/components.dart';

class Size {
  final int width;
  final int height;

  Size(this.width, this.height);
  Size.autoWidth(this.height) : this.width = null;
  Size.autoHeight(this.width) : this.height = null;
  factory Size.autoWithDirection(Direction direction, int size) {
    if (direction.isVertical) return new Size.autoHeight(size);

    return new Size.autoWidth(size);
  }

  int ofDirection(Direction direction) {
    return direction.isVertical ? height ?? 0 : width ?? 0;
  }
}
