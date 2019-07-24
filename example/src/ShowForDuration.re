[@react.component]
let make = (~duration=200, ~children) => {
  let (show, setShow) = React.useState(() => false);

  React.useEffect1(
    () =>
      if (show) {
        let id = Js.Global.setTimeout(() => setShow(_ => false), duration);
        Some(() => Js.Global.clearTimeout(id));
      } else {
        None;
      },
    [|show|],
  );

  React.useEffect0(() => {
    setShow(_ => true);
    None;
  });

  show ? children : React.null;
};