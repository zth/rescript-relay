module Query = [%relay.query
  {|
  query MainQuery {
    siteStatistics {
      ...TopCardsDisplayer_siteStatistics
    }
    ...RecentTickets_query
    ...TodoList_query
  }
|}
];

[@react.component]
let make = () => {
  let query = Query.use(~variables=(), ());

  <div className="main-panel">
    <div className="content-wrapper">
      <Header />
      <TopCardsDisplayer siteStatistics=query##siteStatistics />
      <div className="row">
        <div className="col-8 grid-margin"> <RecentTickets query /> </div>
        <div className="col-4 grid-margin"> <TodoList query /> </div>
      </div>
    </div>
  </div>;
};