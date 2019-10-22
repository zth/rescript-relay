[@react.component]
let make = () => {
  <div className="container-scroller">
    <div className="container-fluid page-body-wrapper">
      <React.Suspense
        maxDuration=1000 fallback={<div> {React.string("Loading...")} </div>}>
        <Main />
      </React.Suspense>
    </div>
  </div>;
};