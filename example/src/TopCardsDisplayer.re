module Fragment = [%relay.fragment
  {|
  fragment TopCardsDisplayer_siteStatistics on SiteStatistics {
    weeklySales
    weeklyOrders
    currentVisitorsOnline
  }
|}
];

[@react.component]
let make = (~siteStatistics as siteStatisticsRef) => {
  let siteStatistics = Fragment.use(siteStatisticsRef);

  <div className="row">
    <div className="col-md-4 stretch-card grid-margin">
      <EmphasizedCard
        title="Weekly Sales"
        subText={"$ " ++ Js.Float.toString(siteStatistics##weeklySales)}
        icon=EmphasizedCard.ChartLine
        variant=EmphasizedCard.Red
      />
    </div>
    <div className="col-md-4 stretch-card grid-margin">
      <EmphasizedCard
        title="Weekly Orders"
        subText={string_of_int(siteStatistics##weeklyOrders)}
        icon=EmphasizedCard.Bookmark
        variant=EmphasizedCard.Blue
      />
    </div>
    <div className="col-md-4 stretch-card grid-margin">
      <EmphasizedCard
        title="Current Visitors Online"
        subText={string_of_int(siteStatistics##currentVisitorsOnline)}
        icon=EmphasizedCard.Diamond
        variant=EmphasizedCard.Green
      />
    </div>
  </div>;
};