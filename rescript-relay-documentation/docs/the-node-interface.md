---
id: the-node-interface
title: The Node Interface
sidebar_label: The Node Interface
---

#### Recommended background reading

-

## Working with the Node Interface

When working on Relay, it might be more common to use the root node query to gather more information about an individual
node from your graph. You might also want to extend this node to other components using fragments.

```rescript
/* UserProfile.res */
module Query = %relay(`
  query UserProfileQuery($id: ID!) {
    node(id: $id) {
      ... on User {
        id
        name
        email
        ...ProfileSettings
      }
      __typename
    }
  }
`)

@react.component
let make = (~id: string) => {
  let queryData = Query.use(
    ~variables={
      id: id,
    }
  )

  {switch queryData.node {
  | Some(user) =>
    <ProfileSettings query={user.fragmentRefs} />
  | None => React.null
  }}
}

/* ProfileSettings.res */
module ProfileSettingsFragment = %relay(`
  fragment ProfileSettings on User {
    id
    name
    profile {
      bio
      image
    }
  }
`)

@react.component
let make = (~query) => {
  let user = ProfileSettingsFragment.use(query)

  <div>
    {user.profile.bio->React.string}
  </div>
}
```

When using a root node query with fragments this returns an `option<response_node>` so you will need to `switch` on that
node to access the `fragmentRefs`.

```rescript
module Query = %relay(`
  query UserProfileQuery($id: ID!) {
    node(id: $id) {
      ... on User {
        id
        name
        email
        ...ProfileSettings
        ...ProfilePreview
      }
      __typename
    }
  }
`)

@react.component
let make = (~id: string) => {
  let queryData = Query.use(
    ~variables={
      id: id,
    }
  )

  {switch queryData.node {
  | Some(#ProfileSettings(user)) =>
    <ProfileSettings query={user.fragmentRefs} />
  | Some(#ProfilePreview(user)) =>
    <ProfilePreview query={user.fragmentRefs} />
  | None => React.null
  }}
}
```
