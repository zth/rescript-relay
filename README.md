# rescript-relay

Use Relay with ReScript/ReasonML.

[**Join our Discord**](https://discord.gg/wzj4EN8XDc)

## Getting started

> Are you using version `>= 0.13.0` and ReScript syntax with VSCode? Make sure you install our [decicated VSCode extension](https://marketplace.visualstudio.com/items?itemName=GabrielNordeborn.vscode-rescript-relay). Note: It only works with ReScript syntax.

Check out the [documentation](https://rescript-relay-documentation.vercel.app).

Also, check out the [changelog](CHANGELOG.md) - things will continue change some between versions (including breaking changes, although we'll try and keep them to a minimum) as we iterate and reach a stable version.

## What it looks like

Your components define what data they need through `%relay()`.

```rescript
/* Avatar.res */
module UserFragment = %relay(
  `
  fragment Avatar_user on User {
    firstName
    lastName
    avatarUrl
  }
`
)

@react.component
let make = (~user) => {
  let userData = UserFragment.use(user)

  <img
    className="avatar"
    src=userData.avatarUrl
    alt={
      userData.firstName ++ " "
      userData.lastName
    }
  />
}

```

Fragments can include other fragments. This allows you to break your UI into encapsulated components defining their own data demands.

Hooks to use your fragments are autogenerated for you. The hook needs a _fragment reference_ from the GraphQL object where it was spread. Any object with one or more fragments spread on it will have a `fragmentRefs` prop on it, `someObj.fragmentRefs`. Pass that to the fragment hook.

`Avatar_user` is spread right on the fragment, so we pass `userData.fragmentRefs` to the `<Avatar />` component since we know it'll contain the fragment ref for `Avatar_user` that `<Avatar />` needs. The `<Avatar />` component then uses that to get its data.

```rescript
/* UserProfile.res */
module UserFragment = %relay(
  `
  fragment UserProfile_user on User {
    firstName
    lastName
    friendCount
    ...Avatar_user
  }
`
)

@react.component
let make = (~user) => {
  let userData = UserFragment.use(user)

  <div>
    <Avatar user=userData.fragmentRefs />
    <h1> {React.string(userData.firstName ++ (" " ++ userData.lastName))} </h1>
    <div>
      <p>
        {React.string(
          userData.firstName ++ (" has " ++ (userData.friendCount->string_of_int ++ " friends.")),
        )}
      </p>
    </div>
  </div>
}
```

Finally, you make a query using `%relay()` and include the fragments needed to render the entire tree of components.

```rescript
/* Dashboard.res */
module Query = %relay(`
  query DashboardQuery {
    me {
      ...UserProfile_user
    }
  }
`)

@react.component
let make = () => {
  let queryData = Query.use(~variables=(), ())

  <div> <UserProfile user=queryData.me.fragmentRefs /> </div>
}

```

## Examples

- [An experimental example showcasing most available features](examples/experimental)

- [A stable example showcasing most available features](examples/stable)
