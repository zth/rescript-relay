module TicketFragment = [%relay.fragment
  {|
  fragment SingleTicket_ticket on Ticket {
    assignee {
      ...Avatar_user
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
       | Some(user) => <Avatar user />
       | None => <em> {React.string("Unassigned")} </em>
       }}
    </td>
    <td> {React.string(ticket##subject)} </td>
    <td> <TicketStatusBadge ticket /> </td>
    <td> {React.string(ticket##lastUpdated)} </td>
    <td> {React.string(ticket##trackingId)} </td>
  </tr>;
};