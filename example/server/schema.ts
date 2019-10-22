import { GraphQLSchema, GraphQLObjectType, GraphQLNonNull } from "graphql";

import { connectionArgs, connectionFromArray } from "graphql-relay";

import { siteStatistics, tickets, todoItems } from "./db";

import {
  siteStatisticsType,
  ticketStatusEnum,
  ticketConnection,
  todoConnection,
  nodeField
} from "./graphqlTypes";

import { mutationType } from "./mutations";

let queryType = new GraphQLObjectType({
  name: "Query",
  fields: () => ({
    node: nodeField,
    siteStatistics: {
      type: new GraphQLNonNull(siteStatisticsType),
      resolve: () => siteStatistics
    },
    tickets: {
      type: new GraphQLNonNull(ticketConnection.connectionType),
      args: { status: { type: ticketStatusEnum }, ...connectionArgs },
      resolve(root, args, obj) {
        return connectionFromArray(
          tickets.filter(ticket =>
            args.status ? ticket.status === args.status : true
          ),
          args
        );
      }
    },
    todos: {
      type: new GraphQLNonNull(todoConnection.connectionType),
      args: connectionArgs,
      resolve(root, args, obj) {
        return connectionFromArray(todoItems, args);
      }
    }
  })
});

export let schema = new GraphQLSchema({
  query: queryType,
  mutation: mutationType
});
