/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @emails oncall+relay
 * 
 * @format
 */
'use strict';

var mockWarning = jest.fn();
jest.mock("fbjs/lib/warning", function () {
  return mockWarning;
});

var React = require('react'); // $FlowFixMe


var TestRenderer = require('react-test-renderer');

var useStaticPropWarning = require('../useStaticPropWarning');

var warningMessage = 'Relay: The %s has to remain the same over the lifetime of a component. Changing ' + 'it is not supported and will result in unexpected behavior.';
var notWarned = [true, warningMessage, 'prop foo'];
var warned = [false, warningMessage, 'prop foo'];

function Example(props) {
  useStaticPropWarning(props.foo, 'prop foo');
  return null;
}

test('warn when a static prop changes', function () {
  // initial render doesn't warn
  var testRenderer = TestRenderer.create(React.createElement(Example, {
    foo: "foo1",
    bar: "bar1"
  }));
  expect(mockWarning.mock.calls.length).toBe(1);
  expect(mockWarning.mock.calls[0]).toEqual(notWarned); // updating a non-checked prop doesn't warn

  testRenderer.update(React.createElement(Example, {
    foo: "foo1",
    bar: "bar2"
  }));
  expect(mockWarning.mock.calls.length).toBe(2);
  expect(mockWarning.mock.calls[1]).toEqual(notWarned); // updating a expected static prop warns

  testRenderer.update(React.createElement(Example, {
    foo: "foo2",
    bar: "bar2"
  }));
  expect(mockWarning.mock.calls.length).toBe(3);
  expect(mockWarning.mock.calls[2]).toEqual(warned);
});