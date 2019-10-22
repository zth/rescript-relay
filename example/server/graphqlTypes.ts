import {
  GraphQLObjectType,
  GraphQLString,
  GraphQLNonNull,
  GraphQLFloat,
  GraphQLInt,
  GraphQLBoolean,
  GraphQLEnumType
} from "graphql";

import {
  fromGlobalId,
  globalIdField,
  nodeDefinitions,
  connectionDefinitions
} from "graphql-relay";

import { users } from "./db";

// @ts-ignore
export let { nodeInterface, nodeField } = nodeDefinitions(
  (globalId: string) => {
    let { type, id } = fromGlobalId(globalId);
    // @ts-ignore
    let source = data[type];

    if (source) {
      return source.find(
        (item: { id: number }) => item.id === parseInt(id, 10)
      );
    }

    return null;
  },
  // @ts-ignore
  (obj: { type: string }) => {
    switch (obj.type) {
      case "User":
        return userType;
      case "SiteStatistics":
        return siteStatisticsType;
      case "Ticket":
        return ticketType;
      case "TodoItem":
        return todoItemType;
    }
  }
);

export let userType: GraphQLObjectType = new GraphQLObjectType({
  name: "User",
  fields: () => ({
    id: globalIdField(),
    avatarUrl: { type: GraphQLString },
    fullName: { type: new GraphQLNonNull(GraphQLString) }
  }),
  interfaces: [nodeInterface]
});

export let siteStatisticsType: GraphQLObjectType = new GraphQLObjectType({
  name: "SiteStatistics",
  fields: () => ({
    id: globalIdField(),
    weeklySales: { type: new GraphQLNonNull(GraphQLFloat) },
    weeklyOrders: { type: new GraphQLNonNull(GraphQLInt) },
    currentVisitorsOnline: { type: new GraphQLNonNull(GraphQLInt) }
  }),
  interfaces: [nodeInterface]
});

export let ticketStatusEnum = new GraphQLEnumType({
  name: "TicketStatus",
  values: {
    Done: { value: "Done" },
    Progress: { value: "Progress" },
    OnHold: { value: "OnHold" },
    Rejected: { value: "Rejected" }
  }
});

export let ticketType: GraphQLObjectType = new GraphQLObjectType({
  name: "Ticket",
  fields: () => ({
    id: globalIdField(),
    assignee: {
      type: userType,
      resolve: obj =>
        obj.assigneeId != null ? users.find(u => u.id === obj.assigneeId) : null
    },
    status: { type: new GraphQLNonNull(ticketStatusEnum) },
    subject: { type: new GraphQLNonNull(GraphQLString) },
    lastUpdated: {
      type: new GraphQLNonNull(GraphQLString)
    },
    trackingId: { type: new GraphQLNonNull(GraphQLString) }
  }),
  interfaces: [nodeInterface]
});

export let ticketConnection = connectionDefinitions({ nodeType: ticketType });

export let todoItemType: GraphQLObjectType = new GraphQLObjectType({
  name: "TodoItem",
  fields: () => ({
    id: globalIdField(),
    completed: { type: GraphQLBoolean },
    text: { type: new GraphQLNonNull(GraphQLString) }
  }),
  interfaces: [nodeInterface]
});

export let todoConnection = connectionDefinitions({ nodeType: todoItemType });
