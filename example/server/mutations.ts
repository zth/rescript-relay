import { mutationWithClientMutationId, fromGlobalId } from "graphql-relay";
import {
  GraphQLObjectType,
  GraphQLBoolean,
  GraphQLString,
  GraphQLNonNull,
  GraphQLID
} from "graphql";
import { todoItemType } from "./graphqlTypes";
import { todoItems } from "./db";
import { TodoItem } from "./types";

let addTodoItemMutation = mutationWithClientMutationId({
  name: "AddTodoItem",
  inputFields: () => ({
    text: {
      type: new GraphQLNonNull(GraphQLString)
    }
  }),
  outputFields: () => ({
    addedTodoItem: {
      type: todoItemType
    }
  }),
  mutateAndGetPayload: ({ text }) => {
    let lastTodoItem = todoItems.slice().pop();
    let nextIndex = lastTodoItem ? lastTodoItem.id + 1 : 1;

    let newTodo: TodoItem = {
      id: nextIndex,
      type: "TodoItem",
      text: text,
      completed: false
    };

    todoItems.push(newTodo);

    return {
      addedTodoItem: newTodo
    };
  }
});

let updateTodoItemMutation = mutationWithClientMutationId({
  name: "UpdateTodoItem",
  inputFields: () => ({
    id: {
      type: new GraphQLNonNull(GraphQLID)
    },
    text: {
      type: new GraphQLNonNull(GraphQLString)
    },
    completed: {
      type: new GraphQLNonNull(GraphQLBoolean)
    }
  }),
  outputFields: () => ({
    updatedTodoItem: {
      type: todoItemType
    }
  }),
  mutateAndGetPayload: ({ text, completed, id }) => {
    let { type, id: todoItemId } = fromGlobalId(id);
    let targetTodoItem = todoItems.find(t => t.id === parseInt(todoItemId, 10));

    if (!targetTodoItem || type !== "TodoItem") {
      return {
        updatedTodoItem: null
      };
    }

    targetTodoItem.text = text;
    targetTodoItem.completed = completed;

    return {
      updatedTodoItem: targetTodoItem
    };
  }
});

let deleteTodoItemMutation = mutationWithClientMutationId({
  name: "DeleteTodoItem",
  inputFields: () => ({
    id: {
      type: new GraphQLNonNull(GraphQLID)
    }
  }),
  outputFields: () => ({
    deletedTodoItemId: {
      type: GraphQLID
    }
  }),
  mutateAndGetPayload: ({ id }) => {
    let { type, id: todoItemId } = fromGlobalId(id);
    let targetTodoItemIndex = todoItems.findIndex(
      t => t.id === parseInt(todoItemId, 10)
    );

    if (targetTodoItemIndex === -1 || type !== "TodoItem") {
      return {
        deleteTodoItemId: null
      };
    }

    todoItems.splice(targetTodoItemIndex, 1);

    return {
      deletedTodoItemId: id
    };
  }
});

export let mutationType = new GraphQLObjectType({
  name: "Mutation",
  fields: () => ({
    addTodoItem: addTodoItemMutation,
    updateTodoItem: updateTodoItemMutation,
    deleteTodoItem: deleteTodoItemMutation
  })
});
