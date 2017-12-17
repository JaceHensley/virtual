import 'package:meta/meta.dart';
import 'package:over_react/over_react.dart';
import 'package:virtual/virtual.dart';

@Factory()
UiFactory<NodeProps> Node;

@Props()
class NodeProps extends UiProps with BaseTreeNodePropsMixin {}

@Component()
class NodeComponent extends UiComponent<NodeProps> with BaseTreeNodeComponentMixin<NodeProps> {
  String get expanderText => props.node.isCollapsed ? 'Expand' : 'Collapse';

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

    return (Dom.div()
      ..style = style
    )(
      props.node.content,
      _renderExpandButton(),
      _renderExpandAllButton(),
    );
  }

  ReactElement _renderExpandButton() {
    if (props.node.isLeaf) return null;

    return (Dom.button()
      ..onClick = _handleExpansionToggleClick
    )(expanderText);
  }

  ReactElement _renderExpandAllButton() {
    if (props.node.isLeaf) return null;

    return (Dom.button()
      ..onClick = _handleExpansionAllToggleClick
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
