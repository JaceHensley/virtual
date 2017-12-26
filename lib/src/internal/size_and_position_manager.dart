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

import 'dart:math';

import 'package:meta/meta.dart';

import 'package:virtual/src/utils.dart';

class SizeAndPositionManager {
  ItemSizeCollection itemSizeCollection;

  Map<int, SizeAndPosition> _itemSizeAndPositionData;
  final ScrollDirection direction;
  int _lastMeasuredIndex;

  SizeAndPositionManager(this.itemSizeCollection, this.direction) : _itemSizeAndPositionData = {}, _lastMeasuredIndex = -1;

  // --------------------------------------------------------------------------
  // Public API Methods
  // --------------------------------------------------------------------------

  Range getVisibleRange(int containerSize, int offset, int overscanCount) {
    var totalSize = getTotalSize();

    if (totalSize == 0) return new Range.empty();

    var maxOffset = offset + containerSize;
    var start = _findNearestItem(offset);

    if (start == null) throw new Error();

    var datum = getSizeAndPositionForIndex(start);
    offset = datum.offset + datum.size.ofDirection(direction);

    var stop = start;

    while (offset < maxOffset && stop < itemSizeCollection.length - 1) {
      stop++;
      offset += getSizeAndPositionForIndex(stop).size.ofDirection(direction);
    }

    start = max(0, start - overscanCount);
    stop = min(stop + overscanCount, itemSizeCollection.length - 1);

    return new Range(
      start: start,
      stop: stop,
    );
  }

  void resetCacheToIndex(int index) {
    _lastMeasuredIndex = min(_lastMeasuredIndex, index - 1);
  }

  int getTotalSize() {
    var lastMeasuredSizeAndPosition = _getSizeAndPositionOfLastMeasuredItem();

    return lastMeasuredSizeAndPosition.offset + lastMeasuredSizeAndPosition.size.ofDirection(direction) + (itemSizeCollection.length - _lastMeasuredIndex - 1);
  }

  SizeAndPosition getSizeAndPositionForIndex(int index) {
    if (index == null || index >= itemSizeCollection.length) {
      throw new Error();
    }

    if (index > _lastMeasuredIndex) {
      var lastMeasuredSizeAndPosition = _getSizeAndPositionOfLastMeasuredItem();
      var offset = lastMeasuredSizeAndPosition.offset +
        lastMeasuredSizeAndPosition.size.ofDirection(direction);

      for (var i = _lastMeasuredIndex + 1; i <= index; i++) {
        var size = itemSizeCollection[i];

        if (size == null) throw new Error();

        _itemSizeAndPositionData[i] = new SizeAndPosition(
          offset: offset,
          size: size,
        );

        offset += size.ofDirection(direction);
      }

      _lastMeasuredIndex = index;
    }

    return _itemSizeAndPositionData[index];
  }

  // --------------------------------------------------------------------------
  // Private Utility Methods
  // --------------------------------------------------------------------------

  SizeAndPosition _getSizeAndPositionOfLastMeasuredItem() {
    return _lastMeasuredIndex >= 0
        ? _itemSizeAndPositionData[_lastMeasuredIndex]
        : new SizeAndPosition(offset: 0, size: new Size.autoWithDirection(direction, 0));
  }

  int _findNearestItem(int offset) {
    offset = max(0, offset);

    var lastMeasuredSizeAndPosition = _getSizeAndPositionOfLastMeasuredItem();

    var nextMeasuredIndex = max(0, _lastMeasuredIndex);

    if (lastMeasuredSizeAndPosition.offset >= offset) {
      // If we've already measured items within this range just use a binary search as it's faster.
      return _binarySearch(
        high: nextMeasuredIndex,
        low: 0,
        offset: offset,
      );
    } else {
      // If we haven't yet measured this high, fallback to an exponential search with an inner binary search.
      // The exponential search avoids pre-computing sizes for the full set of items as a binary search would.
      // The overall complexity for this approach is O(log n).
      return _exponentialSearch(
        index: nextMeasuredIndex,
        offset: offset,
      );
    }
  }

  int _binarySearch({int low, int high, int offset}) {
    var middle = 0;
    var currentOffset = 0;

    while (low <= high) {
      middle = low + ((high - low) / 2).floor();
      currentOffset = getSizeAndPositionForIndex(middle).offset;

      if (currentOffset == offset) {
        return middle;
      } else if (currentOffset < offset) {
        low = middle + 1;
      } else if (currentOffset > offset) {
        high = middle - 1;
      }
    }

    if (low > 0) {
      return low - 1;
    }

    return 0;
  }

  int _exponentialSearch({int index, int offset}) {
    var interval = 1;

    while (
      index < itemSizeCollection.length &&
      getSizeAndPositionForIndex(index).offset < offset
    ) {
      index += interval;
      interval *= 2;
    }

    return _binarySearch(
      high: min(index, itemSizeCollection.length - 1),
      low: (index / 2).floor(),
      offset: offset,
    );
  }
}

class SizeAndPosition {
  final Size size;
  final int offset;

  SizeAndPosition({@required this.size, @required this.offset});
}

class Range {
  final int start;
  final int stop;

  Range({@required this.start, @required this.stop});
  Range.empty() : this.start = 0, this.stop = 0;
}
