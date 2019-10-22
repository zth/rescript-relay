# ReasonRelay example

This is an example of how most concepts in ReasonRelay work. You can run it by doing the following:

### Run server

The examples use `graphql-client-example-server`, install and run like this:

```
npm install -g graphql-client-example-server && graphql-client-example-server
```

### Run client

This workflow will be improved soon, but right now you'll need to start 3 separate processes:

1. The Relay compiler
   `yarn relay --watch`

2. BuckleScript
   `yarn bsb -make-world -w`

3. Webpack
   `yarn start`

...and finally, there's no web server, so open up `index.html` in your favorite browser, right from the file system.
