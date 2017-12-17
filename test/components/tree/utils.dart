import 'package:virtual/virtual.dart';

TreeNode<String> makeTree() {
  var nodes = <TreeNode<String>>[];

  for (var i = 0; i < 100; i++) {
    if (i % 3 == 0) {
      nodes.add(new TreeNode('$i', size: new Size.autoWidth(30)));
    } else if (i % 3 == 1) {
      nodes.add(new TreeNode('$i',
          children: [
            new TreeNode('$i.a', size: new Size.autoWidth(30)),
            new TreeNode('$i.b', size: new Size.autoWidth(30))
          ],
          size: new Size.autoWidth(30)));
    } else if (i % 3 == 2) {
      nodes.add(new TreeNode('$i',
          children: [
            new TreeNode('$i.a', size: new Size.autoWidth(30)),
            new TreeNode('$i.b',
                children: [
                  new TreeNode('$i.b.i', size: new Size.autoWidth(30)),
                  new TreeNode('$i.b.ii', size: new Size.autoWidth(30)),
                  new TreeNode('$i.b.iii', size: new Size.autoWidth(30))
                ],
                size: new Size.autoWidth(30))
          ],
          size: new Size.autoWidth(30)));
    }
  }

  return new TreeNode('Root Node', children: nodes, size: new Size.autoWidth(30));
}
