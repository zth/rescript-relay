# TODO
Here's a list of things left to fix/bind/do.

## Bindings
### Subscriptions
Nothing has been bound for subscriptions yet, and it'll require adding some new stuff. I don't use subscriptions in any of the projects I made this for, but I'll gladly add them if there's a need for them.

### Environment
Extend bindings for the environment. https://github.com/facebook/relay/blob/45eeb2d7f8e23be495bd3a07be03763d5e43724f/packages/relay-runtime/store/RelayModernEnvironment.js#L57

### Network
[ ] Fetch fn returning observables
[ ] Better/more idiomatic bindings for the fetch function

### Hooks
[ ] useRefetch (wait for official Relay API)
[ ] usePagination (wait for official Relay API)

## Docs
[ ] Fully document all interfaces (use `bs-odoc`or similar to generate the interface documentation?)