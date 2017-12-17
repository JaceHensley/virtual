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
      ..['border'] = 'solid'
      ..['borderColor'] = _getBackgroundColor(props.index)
      ..['borderWidth'] = '1px'
      ..['boxSizing'] = 'border-box'
      ..['height'] = '100%';

    var children =[];

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

  String _getBackgroundColor(num n) {
    // cf: http://indiegamr.com/generate-repeatable-random-numbers-in-js/
    num nextChannel() {
      n = (n * 9301 + 49297) % 233280;
      var next = (n / 233280 * 256).floor();
      return next;
    }

    var r = nextChannel();
    var g = nextChannel();
    var b = nextChannel();
    return 'rgb($r, $g, $b)';
  }
}
