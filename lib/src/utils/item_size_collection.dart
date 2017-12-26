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

import 'dart:collection';

import 'package:collection/collection.dart';

import 'package:virtual/src/utils.dart';

abstract class ItemSizeCollection implements List<Size> {
  factory ItemSizeCollection.fixed(int count, Size size) {
    if (count == null) throw new ArgumentError.notNull('count');
    if (count.isNegative) throw new ArgumentError.value(count, 'count', 'count cannot be a negative number');
    if (size == null) throw new ArgumentError.notNull('size');

    return new FixedItemSizeCollection(count, size);
  }

  factory ItemSizeCollection.variable(List<Size> sizes, {bool isDynamic = false}) {
    if (sizes == null) throw new ArgumentError.notNull('sizes');
    if (sizes.isEmpty) throw new ArgumentError.value(sizes, 'sizes', 'sizes cannot be an empty list');

    return isDynamic
        ? new DynamicVariableItemSizeCollection(sizes)
        : new VariableItemSizeCollection(sizes);
  }

  factory ItemSizeCollection.auto(int count, {bool isDynamic = false}) {
    if (count == null) throw new ArgumentError.notNull('count');
    if (count.isNegative) throw new ArgumentError.value(count, 'count', 'count cannot be a negative number');

    return isDynamic
        ? new DynamicAutomaticItemSizeCollection(count)
        : new AutomaticItemSizeCollection(count);
  }

  /// Whether all the items in this collection are of the same, fixed size.
  bool get isFixed;

  /// Whether the items in this collection can change over time.
  bool get isDynamic;

  /// Whether the items in this collection can be automatically measured.
  bool get isAutomatic;

  /// Returns true if this collection is equivalent to another.
  bool equals(covariant ItemSizeCollection other);
}

abstract class ItemSizeCollectionEqualsMixin implements ItemSizeCollection {
  @override
  bool equals(covariant ItemSizeCollection other) {
    if (isFixed != other.isFixed) return false;
    if (isDynamic != other.isDynamic) return false;
    if (length != other.length) return false;

    if (isFixed) {
      return (this as FixedItemSizeCollection).size == (other as FixedItemSizeCollection).size;
    }

    return const ListEquality().equals(this, other);
  }
}

class FixedItemSizeCollection extends ListBase<Size> with ItemSizeCollectionEqualsMixin implements ItemSizeCollection {
  final int count;
  final Size size;

  FixedItemSizeCollection(this.count, this.size);

  @override
  bool get isFixed => true;
  @override
  bool get isDynamic => false;
  @override
  bool get isAutomatic => false;

  @override
  bool equals(FixedItemSizeCollection other) => count == other.count && size == other.size;

  /// Returns the [Size] of the item at the given index.
  @override
  Size operator [](int index) {
    if (index >= 0 && index < count) return size;

    throw new RangeError.index(index, this);
  }

  /// Returns the number of items in this collection.
  @override
  int get length => count;

  @override
  set length(int value) => throw new UnsupportedError('Cannot resize a FixedItemSizeCollection');

  @override
  void operator []=(int index, Size value) {
    throw new UnsupportedError('Cannot modify a FixedItemSizeCollection');
  }
}

class VariableItemSizeCollection extends UnmodifiableListView<Size> with ItemSizeCollectionEqualsMixin implements ItemSizeCollection {
  VariableItemSizeCollection(List<Size> sizes) : super(sizes);

  @override
  bool get isFixed => false;
  @override
  bool get isDynamic => false;
  @override
  bool get isAutomatic => false;

  @override
  set length(int value) => throw new UnsupportedError('Cannot resize a VariableItemSizeCollection');
}

class DynamicVariableItemSizeCollection extends DelegatingList<Size> with ItemSizeCollectionEqualsMixin implements ItemSizeCollection {
  DynamicVariableItemSizeCollection(List<Size> sizes) : super(sizes);

  @override
  bool get isFixed => false;
  @override
  bool get isDynamic => true;
  @override
  bool get isAutomatic => false;

  @override
  set length(int value) => throw new UnsupportedError('Cannot resize a DynamicVariableItemSizeCollection');
}

class AutomaticItemSizeCollection extends DelegatingList<Size> with ItemSizeCollectionEqualsMixin implements ItemSizeCollection {
  AutomaticItemSizeCollection(int count) : super(new List.filled(count, new Size.auto()));

  @override
  bool get isFixed => false;
  @override
  bool get isDynamic => false;
  @override
  bool get isAutomatic => true;

  @override
  set length(int value) => throw new UnsupportedError('Cannot resize an AutomaticItemSizeCollection');
}

class DynamicAutomaticItemSizeCollection extends DelegatingList<Size> with ItemSizeCollectionEqualsMixin implements ItemSizeCollection {
  DynamicAutomaticItemSizeCollection(int count) : super(new List.filled(count, new Size.auto()));

  @override
  bool get isFixed => false;
  @override
  bool get isDynamic => true;
  @override
  bool get isAutomatic => true;

  @override
  set length(int value) => throw new UnsupportedError('Cannot resize a DynamicAutomaticItemSizeCollection');
}
