import * as React from 'react';
import { make as TestMutations } from '../TestMutations.bs';
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

describe('TestMutations', () => {
  test('commitMutation', async () => {
    queryMock.mockQuery({
      name: 'TestMutationsAddBookMutation',
      data: {
        addBook: {
          book: {
            id: 'book-3',
            title: 'New book',
            author: 'Some author',
            status: 'Published'
          }
        }
      },
      variables: {
        input: {
          title: 'New book',
          author: 'Some author'
        }
      }
    });

    queryMock.mockQuery({
      name: 'TestMutationsQuery',
      data: {
        books: [
          {
            id: 'book-1',
            title: 'Some book',
            author: 'Some author',
            status: 'Published'
          }
        ]
      }
    });

    let r;

    act(() => {
      r = render(
        <EnvironmentProvider environment={makeEnvironment()}>
          <TestMutations />
        </EnvironmentProvider>
      );
    });

    await waitForElement(() => r.getByText('Some book'));

    act(() => {
      fireEvent.click(r.getByText('Add book by Commit mutation'));
    });

    await waitForElement(() => r.getByText('New book'));
  });

  test('optimistic updates and hook', async () => {
    queryMock.mockQuery({
      name: 'TestMutationsQuery',
      data: {
        books: [
          {
            id: 'book-1',
            title: 'Some book',
            author: 'Some author',
            status: 'Published'
          }
        ]
      }
    });

    let r;

    act(() => {
      r = render(
        <EnvironmentProvider environment={makeEnvironment()}>
          <TestMutations />
        </EnvironmentProvider>
      );
    });

    await waitForElement(() => r.getByText('Some book'));

    const resolveQuery = queryMock.mockQueryWithControlledResolution({
      name: 'TestMutationsUpdateBookMutation',
      data: {
        updateBook: {
          book: {
            id: 'book-1',
            title: 'Some book',
            author: 'New author',
            status: 'Published'
          }
        }
      },
      variables: {
        input: {
          id: 'book-1',
          title: 'Some book',
          author: 'New author',
          status: 'Published'
        }
      }
    });


      fireEvent.click(r.getByText('Update Some book optimistic'));


    await waitForElement(() => r.getByText('New author'));
    await waitForElement(() => r.getByText('Doing mutation...'));

    resolveQuery();
  });
});
