# virtual

Virtual component library based on [https://github.com/clauderic/react-tiny-virtual-list](https://github.com/clauderic/react-tiny-virtual-list).

## VirtualList

### Example Usage

```dart
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
```

### Props

| Name | Type | Required | Default Value | Description |
|:-----|:-----|:-----|:-----|:-----|
| `itemCount` | `int` | Yes | - | Number of items to render. |
| `itemSize` | `Size | List<Size> | ItemSizeCallback` | Yes | - | Either a fixed size, a list containing the sizes of all the items in your list, or a function that returns the size of an item given its index. |
| `itemRenderer` | `ItemRenderer` | Yes | - | Returns a `ReactElement` given it's index and whether the list is currently scrolling. |

See more props [here](#shared-virtual-collection-props).

## VirtualTree

### Example Usage

```
import 'dart:html';

import 'package:react/react_dom.dart' as react_dom;
import 'package:over_react/over_react.dart';

import 'package:virtual/virtual.dart';

import 'node.dart' as tree;

void main() {
  setClientConfiguration();

  var content = (VirtualTree()
    ..scrollDirection = ScrollDirection.vertical
    ..height = '500px'
    ..width = 'auto'
    ..overscanCount = 100
    ..root = makeTree()
    ..nodeRenderer = (index, isScrolling, node) {
      return (tree.Node()
        ..isScrolling = isScrolling
        ..key = index
        ..index = index
        ..node = node
      )();
    }
  )();

  react_dom.render(content, querySelector('#output'));
}
```

### Props

| Name | Type | Required | Default Value | Description |
|:-----|:-----|:-----|:-----|:-----|
| `root` | `TreeNode` | Yes | - | The backing tree node structure of the virtual tree. |
| `nodeRenderer` | `NodeRenderer` | Yes | - | Returns a `ReactElement` given it's index, whether the list is currently scrolling, and the backing `TreeNode`. |

See more props [here](#shared-virtual-collection-props).

## Shared Virtual Collection Props

| Name | Type | Required | Description |
|:-----|:-----|:-----|:-----|
| `height` | `dynamic` | Yes | - | The overall height of the virtual collection. |
| `width` | `dynamic` | Yes | - | The overall width of the virtual collection. |
| `scrollDirection` | `ScrollDirection` | Yes | - | Which direction the virtual scrolls, either vertical or horizontal. |
| `overscanCount` | `int` | No | 0 | The number of extra items to be rendered outside the visible items. |
| `onItemsRendered` | `ItemScrolledCalback` | No | - | Optional callback that is called when new items are rendered. |
| `onListScroll` | `ListScrollCalback` | No | - | Optional callback that is called when the list is scrolled. |

## BaseTreeNodeMixinProps / BaseTreeNodeMixin

Base props/component classes to help create components that render `TreeNode`s.

### Example Usage

```dart
import 'package:meta/meta.dart';

import 'package:over_react/over_react.dart';
import 'package:virtual/virtual.dart';

@Factory()
UiFactory<NodeProps> Node;

@Props()
class NodeProps extends UiProps with BaseTreeNodePropsMixin {}

@Component()
class NodeComponent extends UiComponent<NodeProps> with BaseTreeNodeMixin<NodeProps> {
  String get expanderText => props.node.isCollapsed ? 'Expand' : 'Collapse';

  @override
  Map getDefaultProps() => (newProps()
    ..addProps(BaseTreeNodePropsMixin.defaultProps)
  );

  @override
  @mustCallSuper
  void componentWillMount() {
    super.componentWillMount();

    bindSub();
  }

  @override
  @mustCallSuper
  void componentWillUnmount() {
    super.componentWillUnmount();

    unbindSub();
  }

  @override
  render() {
    var style = <String, dynamic>{}
      ..['paddingLeft'] = props.node.depth * 28
      ..['height'] = '100%';

    var children = [];

    if (props.isScrolling) {
      children.add('Loading');
    } else {
      children.addAll([
        props.node.content,
        _renderToggleButton(),
        _renderToggleAllButton(),
      ]);
    }

    return (Dom.div()
      ..style = style
    )(children);
  }

  ReactElement _renderToggleButton() {
    if (props.node.isLeaf) return null;

    return (Dom.button()
      ..onClick = _handleExpansionToggleClick
      ..key = 'toggle'
    )(expanderText);
  }

  ReactElement _renderToggleAllButton() {
    if (props.node.isLeaf) return null;

    return (Dom.button()
      ..onClick = _handleExpansionAllToggleClick
      ..key = 'toggle all'
    )('$expanderText all');
  }

  void _handleExpansionAllToggleClick(_) {
    toggle(all: true);
  }

  void _handleExpansionToggleClick(_) {
    toggle();
  }
}
```

### Props

| Name | Type | Required | Default Value | Description |
|:-----|:-----|:-----|:-----|:-----|
| `node` | `TreeNode` | Yes | - | The backing `TreeNode` of this component. |
| `index` | `int` | Yes | - | The index of this component. |
| `isScrolling` | `bool` | No | `false` | Whether the component is being scrolled. |
