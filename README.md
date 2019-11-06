# reason-relay

Use Relay with ReasonML.

## What it looks like

Your components define what data they need through `[%relay.fragment]`.

```reason
/* Avatar.re */
module UserFragment = [%relay.fragment
  {|
  fragment Avatar_user on User {
    firstName
    lastName
    avatarUrl
  }
|}
];

[@react.component]
let make = (~user as userRef) => {
  let user = UserFragment.use(userRef);

  <img
    className="avatar"
    src={
      user##avatarUrl;
    }
    alt={
          user##firstName ++ " ";
          user##lastName;
        }
  />;
};
```

Fragments can include other fragments. This allows you to break your UI into encapsulated components defining their own data demands.

```reason
/* UserProfile.re */
module UserFragment = [%relay.fragment
  {|
  fragment UserProfile_user on User {
    firstName
    lastName
    friendCount
    ...Avatar_user
  }
|}
];

[@react.component]
let make = (~user as userRef) => {
  let user = UserFragment.use(userRef);

  <div>
    <Avatar user />
    <h1> {React.string(user##firstName ++ " " ++ user##lastName)} </h1>
    <div>
      <p>
        {React.string(
           user##firstName
           ++ " has "
           ++ string_of_int(user##friendCount)
           ++ " friends.",
         )}
      </p>
    </div>
  </div>;
};
```

Finally, you make a query using `[%relay.query]` to get the data needed to render the entire tree of components.

```reason
/* Dashboard.re */
module Query = [%relay.query
  {|
  query DashboardQuery {
    me {
      ...UserProfile_user # UserProfile_user includes the data demands of <Avatar /> in addition to its own data demands
    }
  }
|}
];

[@react.component]
let make = () => {
  let queryData = Query.use(~variables=(), ());

  <div> <UserProfile user={queryData##me} /> </div>;
};
```

## Getting started

Check out the [documentation (work in progress) here](https://reason-relay-documentation.zth.now.sh/docs/start-here).

## Examples

- TodoMVC implemented in ReasonRelay: https://github.com/zth/relay-examples/tree/master/todo-reason
- A general example showcasing most available features: https://github.com/zth/reason-relay/tree/master/example
