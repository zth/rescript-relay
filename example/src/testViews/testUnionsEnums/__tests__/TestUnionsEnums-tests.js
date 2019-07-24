import * as React from 'react';
import { make as TestUnionsEnums } from '../TestUnionsEnums.bs';
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

describe('TestUnionsEnums', () => {
  test('enums', async () => {
    queryMock.mockQuery({
      name: 'TestUnionsEnumsQuery',
      variables: { bookStatus: 'Discontinued', shelfId: '123' },
      data: {
        books: [
          {
            id: 'book-1',
            title: 'First Book',
            status: 'Discontinued'
          },
          {
            id: 'book-2',
            title: 'Second Book',
            status: 'Published'
          }
        ],
        fromShelf: null
      }
    });
    let r;

    act(() => {
      r = render(
        <EnvironmentProvider environment={makeEnvironment()}>
          <TestUnionsEnums />
        </EnvironmentProvider>
      );
    });

    await waitForElement(() => r.getByText('Not used anymore'));
    await waitForElement(() => r.getByText('Here!'));
  });

  test('union', async () => {
    queryMock.mockQuery({
      name: 'TestUnionsEnumsQuery',
      variables: { bookStatus: 'Discontinued', shelfId: '123' },
      data: {
        books: [],
        fromShelf: [
          {
            __typename: 'BookCollection',
            id: 'BookCollection-1',
            books: [
              {
                id: 'book-1',
                title: 'First Book',
                status: 'Discontinued'
              }
            ]
          },
          {
            __typename: 'Book',
            id: 'book-1',
            title: 'First Book',
            status: 'Discontinued'
          }
        ]
      }
    });

    let r;

    act(() => {
      r = render(
        <EnvironmentProvider environment={makeEnvironment()}>
          <TestUnionsEnums />
        </EnvironmentProvider>
      );
    });

    await waitForElement(() => r.getByText('Book: First Book'));
    await waitForElement(() => r.getByText('Collection size: 1'));
  });
});
