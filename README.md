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
let make = (~user) => {
  let userData = UserFragment.use(user);

  <img
    className="avatar"
    src={userData.avatarUrl}
    alt={userData.firstName ++ " " userData.lastName}
  />;
};
```

Fragments can include other fragments. This allows you to break your UI into encapsulated components defining their own data demands.

You pass data for fragments around by unwrapping it from the object where it was spread. `Avatar_user` is spread right on the fragment, so we use `UserFragment.unwrapFragments_fragment()` to extract the fragment
data and pass it to the `<Avatar />` component. The `<Avatar />` component then takes that and uses it
to get its data.

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
let make = (~user) => {
  let userData = UserFragment.use(user);

  <div>
    <Avatar user={userData->UserFragment.unwrapFragment_fragment} />
    <h1> {React.string(userData.firstName ++ " " ++ userData.lastName)} </h1>
    <div>
      <p>
        {React.string(
           userData.firstName
           ++ " has "
           ++ userData.friendCount->string_of_int
           ++ " friends.",
         )}
      </p>
    </div>
  </div>;
};
```

Finally, you make a query using `[%relay.query]` and include the fragments needed to render the entire tree of components.

```reason
/* Dashboard.re */
module Query = [%relay.query
  {|
  query DashboardQuery {
    me {
      ...UserProfile_user
    }
  }
|}
];

[@react.component]
let make = () => {
  let queryData = Query.use(~variables=(), ());

  <div> <UserProfile user={queryData.me->Query.unwrapFragment_me} /> </div>;
};
```

## Getting started

Check out the [documentation (work in progress) here](https://reason-relay-documentation.zth.now.sh/docs/start-here).

## Examples

- TodoMVC implemented in ReasonRelay: https://github.com/zth/relay-examples/tree/master/todo-reason
- A general example showcasing most available features: https://github.com/zth/reason-relay/tree/master/example
