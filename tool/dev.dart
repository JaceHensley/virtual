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

import 'package:dart_dev/dart_dev.dart' show Environment, TestRunnerConfig, config, dev;

main(List<String> args) async {
  const directories = const <String>[
    'lib/',
    'tool/',
  ];

  config.analyze.entryPoints = directories;
  config.copyLicense.directories = directories;

  config.genTestRunner.configs = [
    new TestRunnerConfig(
      directory: 'test',
      env: Environment.browser,
      filename: 'generated_runner_test',
      preTestCommands: [
        'setClientConfiguration();',
        'enableTestMode();',
      ],
      dartHeaders: [
        "import 'package:over_react/over_react.dart' show enableTestMode, setClientConfiguration;",
      ],
      genHtml: true,
      htmlHeaders: const [
        '<script src="packages/react/react_with_addons.js"></script>',
        '<script src="packages/react/react_dom.js"></script>'
      ],
    ),
  ];

  config.test
    ..platforms = ['vm', 'content-shell']
    ..pubServe = true
    ..unitTests = ['test/generated_runner_test.dart'];

  await dev(args);
}
