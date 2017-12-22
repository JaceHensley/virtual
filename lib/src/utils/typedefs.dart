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
import 'package:over_react/over_react.dart';

import 'package:virtual/src/components.dart';

typedef Size ItemSizeCallback(int itemIndex);

// --------------------------------------------------------------------------
// VirtualViewport Typedefs
// --------------------------------------------------------------------------

typedef ViewportScrollCalback(SyntheticUIEvent event, Point point);

// --------------------------------------------------------------------------
// VirtualList Typedefs
// --------------------------------------------------------------------------

typedef ReactElement ItemRenderer(int itemIndex, bool isScrolling);
typedef ListScrollCalback(SyntheticUIEvent event, int offset);
typedef ItemsRenderedCalback(int startIndex, int endIndex);

// --------------------------------------------------------------------------
// VirtualTree Typedefs
// --------------------------------------------------------------------------

typedef ReactElement NodeRenderer(int itemIndex, bool isScrolling, TreeNode node);
typedef TreeScrollCalback(SyntheticUIEvent event, int offset);
typedef NodesRenderedCalback(int startIndex, int endIndex, TreeNode startNode, TreeNode endNode);
