/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @flow strict-local
 * @format
 */

'use strict';

const RelayReasonGenerator = require('./RelayReasonGenerator');

const formatGeneratedModule = require('./formatGeneratedModule');

const { find } = require('./FindGraphQLTags');

// $FlowFixMe
import type { PluginInterface } from '../RelayLanguagePluginInterface';

module.exports = (): PluginInterface => ({
  inputExtensions: ['re'],
  outputExtension: 're',
  typeGenerator: RelayReasonGenerator,
  formatModule: formatGeneratedModule,
  findGraphQLTags: find
});
