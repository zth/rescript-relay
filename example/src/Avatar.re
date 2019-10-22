module Fragment = [%relay.fragment
  {|
  fragment Avatar_user on User {
    avatarUrl
    fullName
  }
|}
];

[@react.component]
let make = (~user as userRef) => {
  let user = Fragment.use(userRef);

  <>
    {switch (user##avatarUrl |> Js.Nullable.toOption) {
     | Some(avatarUrl) => <img src=avatarUrl className="mr-2" alt="image" />
     | None => React.null
     }}
    {React.string(user##fullName)}
  </>;
};