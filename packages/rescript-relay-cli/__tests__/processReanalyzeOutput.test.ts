import fs from "fs";
import path from "path";
import { processReanalyzeOutput } from "../cliUtils";

const testData = fs.readFileSync(
  path.resolve(path.join(__dirname, "testData.txt")),
  { encoding: "utf-8" }
);

describe("Process output from Reanalyze", () => {
  it("should detect all relevant unused fields", () => {
    expect(processReanalyzeOutput(testData)).toEqual({
      "Assignee_typ_graphql.res": {
        type: "fragment",
        graphqlName: "Assignee_typ",
        unusedFieldPaths: ["WorkingGroup.id"],
      },
      "RecentTicketsRefetchQuery_graphql.res": {
        type: "query",
        graphqlName: "RecentTicketsRefetchQuery",
        unusedFieldPaths: ["fragmentRefs"],
      },
      "RecentTickets_query_graphql.res": {
        type: "fragment",
        graphqlName: "RecentTickets_query",
        unusedFieldPaths: [
          "ticketsConnection.pageInfo",
          "ticketsConnection_pageInfo.endCursor",
          "ticketsConnection_pageInfo.hasNextPage",
        ],
      },
      "SingleTicketWorkingGroupRefetchQuery_graphql.res": {
        type: "query",
        graphqlName: "SingleTicketWorkingGroupRefetchQuery",
        unusedFieldPaths: ["node.fragmentRefs", "node"],
      },
      "SingleTicketWorkingGroup_workingGroup_graphql.res": {
        type: "fragment",
        graphqlName: "SingleTicketWorkingGroup_workingGroup",
        unusedFieldPaths: ["membersConnection_edges_node.fragmentRefs"],
      },
      "SingleTicket_ticket_graphql.res": {
        type: "fragment",
        graphqlName: "SingleTicket_ticket",
        unusedFieldPaths: ["assignee_User.id"],
      },
      "SingleTicket_unusedFragment_graphql.res": {
        type: "fragment",
        graphqlName: "SingleTicket_unusedFragment",
        unusedFieldPaths: ["subject", "lastUpdated", "trackingId"],
      },
      "TicketStatusBadge_ticket_graphql.res": {
        type: "fragment",
        graphqlName: "TicketStatusBadge_ticket",
        unusedFieldPaths: ["assignee_User.fullName", "dbId", "assignee"],
      },
    });
  });
});
