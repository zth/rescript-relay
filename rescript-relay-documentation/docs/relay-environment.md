---
id: relay-environment
title: Relay Environment
sidebar_label: Relay Environment
---

This section of the docs is quite lacking. However, most of the information you need is available in the [official Relay documentation](https://relay.dev/docs/guided-tour/rendering/environment/).

## Missing field handlers

> Start by reading [this section of the Relay docs](https://relay.dev/docs/guided-tour/reusing-cached-data/filling-in-missing-data/).

> API reference for missing field handlers is [available here](api-reference#missingfieldhandler)

You can teach Relay about relations in your schema in order to increase cache hits. In general, there should be no need to use this for most projects. But, occasionally there will be good reason to do so.

The section below details how missing field handlers work in `RescriptRelay`. Please start by reading the Relay documentation linked above to have a good understanding of how this works in Relay in general.

### Creating missing field handlers

You create a missing field handler by using the appropriate make-method from the module [`RescriptRelay.MissingFieldHandler`](api-reference#missingfieldhandler). These are:

1. [`makeScalarMissingFieldHandler`](api-reference#missingfieldhandlermakescalarmissingfieldhandler) for creating a missing field handler for scalar values (like a `name` on a `User`).
2. [`makeLinkedMissingFieldHandler`](api-reference#missingfieldhandlermakelinkedmissingfieldhandler) for creating a missing field handler for a single linked record (like a `Pet` on the field `favoritePet` on a `User`).

3. [`makePluralLinkedMissingFieldHandler`](api-reference#missingfieldhandlermakeplurallinkedmissingfieldhandler) for creating a missing field handler for lists of linked records (like a list of `Pet` on the field `allPets` on a `User`).

#### Examples

Coming soon.
