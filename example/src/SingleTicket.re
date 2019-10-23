module TicketFragment = [%relay.fragment
  {|
  fragment SingleTicket_ticket on Ticket {
    assignee {
      __typename

      ... on User {
        ...Avatar_user
      }

      ... on WorkingGroup {
        ...SingleTicketWorkingGroup_workingGroup
      }
    }
    id
    subject
    lastUpdated
    trackingId
    ...TicketStatusBadge_ticket
  }
|}
];

[@react.component]
let make = (~ticket as ticketRef) => {
  let ticket = TicketFragment.use(ticketRef);

  <tr>
    <td>
      {switch (ticket##assignee |> Js.Nullable.toOption) {
       | Some(assignee) =>
         switch (assignee |> TicketFragment.Union_response_assignee.unwrap) {
         | `User(user) => <Avatar user />
         | `WorkingGroup(workingGroup) =>
           <React.Suspense fallback={<Loading />}>
             <SingleTicketWorkingGroup workingGroup />
           </React.Suspense>
         | `UnmappedUnionMember => <span> {React.string("-")} </span>
         }
       | None => <em> {React.string("Unassigned")} </em>
       }}
    </td>
    <td> {React.string(ticket##subject)} </td>
    <td> <TicketStatusBadge ticket /> </td>
    <td>
      {React.string(
         Belt.Option.getWithDefault(
           ticket##lastUpdated |> Js.Nullable.toOption,
           "-",
         ),
       )}
    </td>
    <td> {React.string(ticket##trackingId)} </td>
  </tr>;
};