---
id: migrating-to-v3
title: Migrating to Version 3
sidebar_label: Migrating to v3
---

Version 3 of RescriptRelay sets the foundation for the next several years of RescriptRelay development. With ReScript v11 bringing large improvements of JS interop in ReScript, RescriptRelay v3+ is built on a leaner, faster and more optimized foundation, leveraging the new capabilities in ReScript v11.

It does however contain some fairly large changes. This guide is intended to help you migrate as easily as possible, going step-by-step, so that you can migrate in smaller steps rather than having to make all changes at once.

## Migration

> [Here's a commit upgrading the example to v3](https://github.com/zth/rescript-relay/commit/3e55b841610db3767616468ada190f2b29bb2f5b). It doesn't cover all changes, but gives a good impression of what has changed.

Even though care has been taken to provide an as incremental migration path as possible, you're still recommended to do migration all in one go (not in one commit, but migrating everything before you ship to production).

Also, remember that below is a _general guide_. You might hit issues you'll need to migrate that aren't detailed here, and that's expected. This should cover the majority of cases though.

Prerequisites:

- Make sure you're using Relay v15 until you're asked to upgrade to v16 in this guide. If you're already on v16, downgrade as you're going through this guide. This will ensure you'll be able to compile and run your app properly between each migration step.
- Make sure you're on ReScript v11. Everything in v3 has been designed with ReScript v11 in mind.

## Step 1

> Also see the relevant section in the [CHANGELOG](https://github.com/zth/rescript-relay/blob/master/CHANGELOG.md#000-version-3-89bccc22).

The first step changes:

- Enums to be proper variants instead of polymorphic variants
- Removes the "top level node field transform"

First, install the v3 alpha version that has only these changes, clean and recompile:

```bash
yarn install rescript-relay@0.0.0-version-3-89bccc22 &&
yarn rescript-relay-compiler &&
yarn rescript clean &&
yarn rescript build
```

You'll now get a bunch of type errors. This is how you migrate:

### Enums as proper variants

Remove the leading `#` of your polymorphic enum names, and adjust the initial character of the enum name to be uppercase if needed:

```rescript
 <div>
  {React.string(
    switch preset {
    // color2
    | #LAST_7_DAYS => `${prefix}senaste 7 dagarna`
    // color2
    | #LAST_28_DAYS => `${prefix}senaste 28 dagarna`
    // color2
    | #LAST_90_DAYS => `${prefix}senaste 90 dagarna`
    // color2
    | #LIFETIME => `${prefix}allt`
    // change-line
    | LAST_7_DAYS => `${prefix}senaste 7 dagarna`
    // change-line
    | LAST_28_DAYS => `${prefix}senaste 28 dagarna`
    // change-line
    | LAST_90_DAYS => `${prefix}senaste 90 dagarna`
    // change-line
    | LIFETIME => `${prefix}allt`
    },
  )}
</div>
```

Since inference works differently with proper variants compared to polymorphic variants, you'll occasionally find that the compiler can't identify your enum automatically anymore. Solve this by annotating the enum value. All enum variant definitions are located inside of `RelaySchemaAssets_graphql.res`:

```rescript
@react.component
// color2
let make = (~role) => {
// change-line
let make = (~role: option<RelaySchemaAssets_graphql.enum_UserOrganizationRole>) => {
  switch role {
    // color2
  | Some(#admin) => <Badge text="Admin" color=Badge.Purple />
  // color2
  | Some(#observer) => <Badge text="Observer" color=Badge.Gray />
  // change-line
  | Some(Admin) => <Badge text="Admin" color=Badge.Purple />
  // change-line
  | Some(Observer) => <Badge text="Observer" color=Badge.Gray />
  | _ => React.null
  }
}
```

### Top level node field transform

In RescriptRelay < 3, any top level node field query would be automatically collapsed so you wouldn't have to explicitly switch on the node union member. This was a convenience that costed more in complexity than it was worth, and has been removed in v3.

Migrating away from it is as easy as explicitly switching on the union member:

```rescript
module Query = %relay(`
  query SingleFacebookCampaignQuery(
    $campaignId: ID!
  ) {
    node(id: $campaignId) {
      ... on FacebookCampaign {
        ...SingleFacebookCampaignDisplay_campaign
      }
    }
  }
`)

@react.component
let make = (~queryRef) => {
  let data = Query.usePreloaded(~queryRef)

  switch data.node {
    // color2
  | None => <FourOhFour.OrganizationNotFound />
  // color2
  | Some(facebookCampaign) =>
  // change-line
  | Some(#FacebookCampaign(facebookCampaign)) =>
    <SingleFacebookCampaignDisplay
      campaign={facebookCampaign.fragmentRefs}
    />
  // change-line
  | _ => <FourOhFour.OrganizationNotFound />
  }
}
```

## Step 2

> Also see the relevant section in the [CHANGELOG](https://github.com/zth/rescript-relay/blob/master/CHANGELOG.md#000-version-3-aeebeaab).

The second step changes:

- All object maker functions are removed

First, install the v3 alpha version that has only these changes, clean and recompile:

```bash
yarn install rescript-relay@0.0.0-version-3-aeebeaab &&
yarn rescript-relay-compiler &&
yarn rescript build
```

Migrating is just about removing all object maker function usage and using regular records instead:

```rescript
let doLogin = React.useCallback(() => {
    let _ = login(
      // color2
      ~variables=LoginMutation.makeVariables(~username=state.username, ~password=state.password),
      // change-line
      ~variables={username: state.username, password: state.password},
      ~updater=(store, _) => {
        store->RescriptRelay.RecordSourceSelectorProxy.invalidateStore
      },
```

In version 3, records used in input positions (like for `variables`) use optional record fields. Therefore you might occasionally need to use `?` to pass optional values where you didn't need to use `?` before:

```rescript
  ~variables={
    // color2
    organizationsConstraint: filter,
    // change-line
    organizationsConstraint: ?filter,
  },
```

## Step 3

> Also see the relevant section in the [CHANGELOG](https://github.com/zth/rescript-relay/blob/master/CHANGELOG.md#000-version-3-3504d777).

The third step changes:

- All trailing units are removed in all functions

Install the v3 alpha version that has only these changes, clean and recompile:

```bash
yarn install rescript-relay@0.0.0-version-3-3504d777 &&
yarn rescript-relay-compiler &&
yarn rescript build
```

Migrating is straight forward (although can take a while) and is about removing trailing units from everything related to RescriptRelay. Here are a few examples:

```rescript
let _: RescriptRelay.Disposable.t = refetch(
  // color2
  ~variables=makeRefetchVariables(~from, ~to, ~period, ()),
  // color2
  (),
  // change-line
  ~variables=makeRefetchVariables(~from, ~to, ~period),
)
```

```rescript
let network = RescriptRelay.Network.makeObservableBased(
  ~observableFunction=NetworkUtils.fetchQuery,
  ~subscriptionFunction=NetworkUtils.subscribeFn,
  // color2
  (),
)
```

## Step 4

> Also see the relevant section in the [CHANGELOG](https://github.com/zth/rescript-relay/blob/master/CHANGELOG.md#000-version-3-8b552902).

The fourth step changes:

- All unions are now proper variants instead of polymorphic variants
- Variant payloads are now inline records

Install the v3 alpha version that has only these changes, clean and recompile:

```bash
yarn install rescript-relay@0.0.0-version-3-8b552902 &&
yarn rescript-relay-compiler &&
yarn rescript build
```

Migrating to this is similar to migrating the enum changes - remove any leading `#` and capitalize the first character of the union member name if needed:

```rescript
switch data.node {
  // color2
  | Some(#GoogleAdsCampaign(googleAdsCampaign)) =>
  // change-line
  | Some(GoogleAdsCampaign(googleAdsCampaign)) =>
    <SingleGoogleCampaignDisplay
      campaign={googleAdsCampaign.fragmentRefs}
    />
```

In addition to this you might occasionally need to explicitly pattern match the payload of the variants given that they're now inline records. The compiler will tell you when you need to do that.

## Step 5

> Also see the relevant section in the [CHANGELOG](https://github.com/zth/rescript-relay/blob/master/CHANGELOG.md#300-alpha5).

We're almost there! Now we can upgrade to an actual `alpha` version of RescriptRelay, and upgrade Relay to v16:

```bash
yarn install rescript-relay@3.0.0 relay-runtime@17 react-relay@17
```

If you have custom scalars set up and mapped, you'll need to change the `customScalars` prop name to `customScalarTypes` in your `relay.config.js`:

```js title="relay.config.js"
module.exports = {
  src: "./src",
  schema: "./schema.graphql",
  artifactDirectory: "./src/__generated__",
// color2
  customScalars: {
// change-line
  customScalarTypes: {
    Datetime: "string",
    Color: "Color.t",
  },
};
```

Now you should be able to build:

```bash
yarn rescript-relay-compiler &&
yarn rescript build
```

There, you should be all set and ready for version 3!

## Wrapping up

We wish you good luck in migrating to v3, and we promise it'll be worth it! This is a best-effort guide, so please don't be afraid to open issues [on the issue tracker](https://github.com/zth/rescript-relay/issues). We'll update this guide accordingly.

Also make sure to [join our Discord](https://discord.gg/wzj4EN8XDc) to chat with other users of RescriptRelay.
