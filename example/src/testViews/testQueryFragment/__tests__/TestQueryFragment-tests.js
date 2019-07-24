import * as React from 'react';
import { make as TestQueryFragment } from '../TestQueryFragment.bs';
import { act } from 'react-dom/test-utils';
import { QueryMock } from 'graphql-query-test-mock';
import {
  render,
  fireEvent,
  cleanup,
  waitForElement
} from '@testing-library/react';
import { makeEnvironment } from '../../../RelayEnv.bs';
import { make as EnvironmentProvider } from '../../../EnvironmentProvider.bs';

global.fetch = require('node-fetch');

let queryMock;

beforeEach(() => {
  queryMock = new QueryMock();
  queryMock.setup('http://localhost:4000');
});

afterEach(() => {
  queryMock.cleanup();
  queryMock.reset();
  cleanup();
});

describe('TestQueryFragment', () => {
  describe('query and fragment', () => {
    test('query and fragment', async () => {
      const resolveQuery = queryMock.mockQueryWithControlledResolution({
        name: 'TestQueryFragmentQuery',
        data: {
          books: [
            {
              id: 'book-1',
              title: 'First Book',
              author: 'First Author'
            },
            {
              id: 'book-2',
              title: 'Second Book',
              author: 'Second Author'
            }
          ]
        }
      });
      let r;

      act(() => {
        r = render(
          <EnvironmentProvider environment={makeEnvironment()}>
            <TestQueryFragment />
          </EnvironmentProvider>
        );
      });

      await waitForElement(() => r.getByText('Loading...'));

      resolveQuery();

      await waitForElement(() => r.getByText('First Book'));
      await waitForElement(() => r.getByText('First Author'));
    });

    test('commitLocalUpdate', async () => {
      queryMock.mockQuery({
        name: 'TestQueryFragmentQuery',
        data: {
          books: [
            {
              id: 'book-1',
              title: 'First Book',
              author: 'First Author'
            }
          ]
        }
      });

      let r;

      act(() => {
        r = render(
          <EnvironmentProvider environment={makeEnvironment()}>
            <TestQueryFragment />
          </EnvironmentProvider>
        );
      });

      await waitForElement(() => r.getByText('First Book'));

      act(() => {
        fireEvent.click(r.getByText('Update First Book locally'));
      });

      expect(r.getByText('First Book New Title')).toBeTruthy();
    });
  });
});
