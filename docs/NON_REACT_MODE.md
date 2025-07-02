# Non-React Mode

RescriptRelay can be used outside of React components for data fetching in server-side environments, Node.js applications, and other non-UI contexts.

## Overview

Non-React mode allows you to use RescriptRelay's powerful GraphQL capabilities without being tied to React components. This is particularly useful for:

- Server-side rendering (SSR)
- API endpoints and serverless functions
- Background data processing
- Node.js scripts and automation
- Testing environments

## Basic Setup

### Environment Configuration

First, create a Relay environment for non-React usage:

```rescript
// RelayEnvironment.res
let createServerEnvironment = () => {
  let network = RescriptRelay.Network.makePromiseBased(
    ~fetchFunction=(operation, variables, _cacheConfig) => {
      let endpoint = "https://api.example.com/graphql"
      
      Fetch.fetchWithInit(endpoint, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " ++ getAuthToken(),
        },
        body: {
          "query": operation.text,
          "variables": variables,
        }->Js.Json.object_->Js.Json.stringify,
      })
      ->Promise.then(Fetch.Response.json)
    },
    ()
  )
  
  RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(RescriptRelay.RecordSource.make()),
    ()
  )
}

// Global environment instance
let environment = createServerEnvironment()
```

### Basic Data Fetching

Use `Environment.fetchQuery` for direct data fetching:

```rescript
module UserQuery = %relay(`
  query UserQuery($userId: ID!) {
    user(id: $userId) {
      id
      name
      email
      profile {
        bio
        avatar
      }
    }
  }
`)

let fetchUserData = async (userId) => {
  try {
    let result = await RescriptRelay.Environment.fetchQuery(
      environment,
      UserQuery.query,
      {userId: userId}
    )
    Ok(result)
  } catch {
  | error => Error(error)
  }
}

// Usage
let processUser = async (userId) => {
  switch await fetchUserData(userId) {
  | Ok(data) => 
    switch data.user {
    | Some(user) => 
      Console.log("Processing user: " ++ user.name)
      // Process user data
      Some(user)
    | None => 
      Console.log("User not found")
      None
    }
  | Error(error) => 
    Console.error("Failed to fetch user:")
    Console.error(error)
    None
  }
}
```

## Server-Side Rendering (SSR)

### Preloading Data for SSR

```rescript
// SSRUtils.res
let preloadPageData = async (pageProps) => {
  let environment = createServerEnvironment()
  
  // Preload multiple queries concurrently
  let userDataPromise = switch pageProps.userId {
  | Some(userId) => 
    Some(RescriptRelay.Environment.fetchQuery(
      environment,
      UserQuery.query,
      {userId}
    ))
  | None => None
  }
  
  let postsDataPromise = RescriptRelay.Environment.fetchQuery(
    environment,
    PostsQuery.query,
    {first: 10, after: None}
  )
  
  // Wait for all data to load
  let userData = switch userDataPromise {
  | Some(promise) => Some(await promise)
  | None => None
  }
  
  let postsData = await postsDataPromise
  
  // Return serialized store state
  {
    "userData": userData,
    "postsData": postsData,
    "relayRecords": environment
      ->RescriptRelay.Environment.getStore
      ->RescriptRelay.Store.getSource
      ->RescriptRelay.RecordSource.toJSON,
  }
}

// In your SSR handler (e.g., Next.js getServerSideProps)
let getServerSideProps = async (context) => {
  let pageData = await preloadPageData({
    userId: context.params->Js.Dict.get("userId")
  })
  
  {
    "props": pageData
  }
}
```

### Hydrating Client-Side

```rescript
// ClientEnvironment.res
let createClientEnvironment = (~initialRecords=?, ()) => {
  let network = RescriptRelay.Network.makePromiseBased(
    ~fetchFunction=(operation, variables, _cacheConfig) => {
      // Client-side fetch logic
      fetchGraphQL(operation, variables)
    },
    ()
  )
  
  let store = switch initialRecords {
  | Some(records) => 
    let source = RescriptRelay.RecordSource.fromJSON(records)
    RescriptRelay.Store.make(source)
  | None => 
    RescriptRelay.Store.make(RescriptRelay.RecordSource.make())
  }
  
  RescriptRelay.Environment.make(~network, ~store, ())
}

// Hydrate with SSR data
let hydrateEnvironment = (ssrData) => {
  createClientEnvironment(~initialRecords=ssrData.relayRecords, ())
}
```

## Node.js Integration

### API Route Handler

```rescript
// api/users/[userId].res
let handler = async (req, res) => {
  let userId = req.params->Js.Dict.get("userId")
  
  switch userId {
  | Some(id) =>
    switch await fetchUserData(id) {
    | Ok(data) => 
      res->Express.Response.json(data)
    | Error(_) => 
      res->Express.Response.status(500)->Express.Response.json({
        "error": "Failed to fetch user data"
      })
    }
  | None =>
    res->Express.Response.status(400)->Express.Response.json({
      "error": "User ID required"
    })
  }
}
```

### Background Processing

```rescript
// DataSync.res
module SyncQuery = %relay(`
  query SyncQuery($lastSyncTime: DateTime) {
    updates(since: $lastSyncTime) {
      id
      type
      data
      timestamp
    }
  }
`)

let syncData = async () => {
  let lastSync = await getLastSyncTime()
  
  switch await RescriptRelay.Environment.fetchQuery(
    environment,
    SyncQuery.query,
    {lastSyncTime: lastSync}
  ) {
  | data => 
    let updates = data.updates
    Console.log(`Processing ${Array.length(updates)} updates`)
    
    // Process each update
    for update in updates {
      await processUpdate(update)
    }
    
    // Update sync timestamp
    await setLastSyncTime(Js.Date.now())
    
  | exception error =>
    Console.error("Sync failed:")
    Console.error(error)
  }
}

// Run sync every 5 minutes
let startSyncScheduler = () => {
  let interval = Js.Global.setInterval(() => {
    syncData()->ignore
  }, 5 * 60 * 1000) // 5 minutes
  
  // Return cleanup function
  () => Js.Global.clearInterval(interval)
}
```

### Database Integration

```rescript
// UserService.res
module CreateUserMutation = %relay(`
  mutation UserServiceCreateUserMutation($input: CreateUserInput!) {
    createUser(input: $input) {
      user {
        id
        name
        email
      }
      errors {
        field
        message
      }
    }
  }
`)

let createUser = async (userData) => {
  try {
    let result = await RescriptRelay.Environment.commitMutation(
      environment,
      CreateUserMutation.mutation,
      {input: userData}
    )
    
    switch result.createUser.errors {
    | [] => 
      // Store in local database
      await Database.insertUser(result.createUser.user)
      Ok(result.createUser.user)
    | errors => 
      Error(errors)
    }
  } catch {
  | error => Error([{field: "general", message: "Network error"}])
  }
}

let updateUserProfile = async (userId, profileData) => {
  // Update via GraphQL
  let graphqlResult = await RescriptRelay.Environment.commitMutation(
    environment,
    UpdateUserMutation.mutation,
    {userId, profileData}
  )
  
  // Sync with local database
  await Database.updateUser(userId, profileData)
  
  // Invalidate cache
  RescriptRelay.Environment.invalidateRecordsByIds(
    environment,
    [userId]
  )
  
  graphqlResult
}
```

## Testing

### Unit Testing

```rescript
// __tests__/UserService_test.res
open Jest
open Expect

// Mock environment for testing
let createTestEnvironment = () => {
  let network = RescriptRelay.Network.makePromiseBased(
    ~fetchFunction=(operation, variables, _) => {
      // Mock responses based on operation
      switch operation.name {
      | "UserQuery" => 
        Promise.resolve({
          "user": {
            "id": variables->Js.Dict.get("userId"),
            "name": "Test User",
            "email": "test@example.com"
          }
        })
      | _ => Promise.reject(Js.Exn.raiseError("Unmocked operation"))
      }
    },
    ()
  )
  
  RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(RescriptRelay.RecordSource.make()),
    ()
  )
}

describe("UserService", () => {
  test("fetchUserData returns user data", async () => {
    // Override global environment for test
    let originalEnv = environment
    environment := createTestEnvironment()
    
    let result = await fetchUserData("123")
    
    expect(result)->toEqual(Ok({
      user: Some({
        id: "123",
        name: "Test User",
        email: "test@example.com"
      })
    }))
    
    // Restore original environment
    environment := originalEnv
  })
})
```

### Integration Testing

```rescript
// __tests__/API_test.res
let testWithRealAPI = async () => {
  let testEnvironment = createServerEnvironment()
  
  // Test real API calls
  let result = await RescriptRelay.Environment.fetchQuery(
    testEnvironment,
    UserQuery.query,
    {userId: "test-user-id"}
  )
  
  Console.log("API Response:")
  Console.log(result)
}

// Run integration tests
if (Node.Process.env->Js.Dict.get("NODE_ENV") === Some("test")) {
  testWithRealAPI()->ignore
}
```

## Error Handling

### Comprehensive Error Handling

```rescript
type fetchError = 
  | NetworkError(string)
  | GraphQLError(array<string>)
  | ValidationError(string)
  | UnknownError

let handleFetchError = (error) => {
  switch error {
  | NetworkError(msg) => 
    Console.error("Network error: " ++ msg)
    // Maybe retry with exponential backoff
    
  | GraphQLError(errors) => 
    Console.error("GraphQL errors:")
    errors->Array.forEach(Console.error)
    // Handle specific GraphQL errors
    
  | ValidationError(msg) => 
    Console.error("Validation error: " ++ msg)
    // Don't retry validation errors
    
  | UnknownError => 
    Console.error("Unknown error occurred")
    // Log for investigation
  }
}

let safeFetchUserData = async (userId) => {
  try {
    let result = await RescriptRelay.Environment.fetchQuery(
      environment,
      UserQuery.query,
      {userId}
    )
    Ok(result)
  } catch {
  | Js.Exn.Error(obj) => 
    let message = obj->Js.Exn.message->Option.getWithDefault("Unknown error")
    if (String.includes(message, "network")) {
      Error(NetworkError(message))
    } else {
      Error(UnknownError)
    }
  | _ => Error(UnknownError)
  }
}
```

### Retry Logic

```rescript
let rec fetchWithRetry = async (query, variables, ~retries=3, ()) => {
  try {
    await RescriptRelay.Environment.fetchQuery(environment, query, variables)
  } catch {
  | error when retries > 0 => 
    Console.log(`Retrying... ${retries} attempts left`)
    await Js.Global.setTimeout(() => (), 1000) // Wait 1 second
    await fetchWithRetry(query, variables, ~retries=retries - 1, ())
  | error => 
    raise(error)
  }
}
```

## Performance Considerations

### Connection Pooling

```rescript
// For high-throughput scenarios, use connection pooling
let createPooledEnvironment = () => {
  let network = RescriptRelay.Network.makePromiseBased(
    ~fetchFunction=(operation, variables, _cacheConfig) => {
      // Use HTTP agent with keep-alive
      let options = {
        "method": "POST",
        "headers": {
          "Content-Type": "application/json",
          "Connection": "keep-alive",
        },
        "body": Js.Json.stringify({
          "query": operation.text,
          "variables": variables,
        }),
        "agent": httpAgent, // Reuse connections
      }
      
      fetch(endpoint, options)->Promise.then(response => response.json())
    },
    ()
  )
  
  RescriptRelay.Environment.make(
    ~network,
    ~store=RescriptRelay.Store.make(RescriptRelay.RecordSource.make()),
    ()
  )
}
```

### Caching Strategy

```rescript
// Implement custom caching for server environments
let cacheStore = Js.Dict.empty()

let getCachedQuery = (queryKey) => {
  cacheStore->Js.Dict.get(queryKey)
}

let setCachedQuery = (queryKey, data, ttl) => {
  let expiresAt = Js.Date.now() +. ttl
  cacheStore->Js.Dict.set(queryKey, {data, expiresAt})
}

let fetchWithCache = async (query, variables, ~ttl=60000.0, ()) => {
  let queryKey = query.name ++ "_" ++ Js.Json.stringify(variables)
  
  switch getCachedQuery(queryKey) {
  | Some(cached) when cached.expiresAt > Js.Date.now() => 
    cached.data
  | _ => 
    let data = await RescriptRelay.Environment.fetchQuery(
      environment, 
      query, 
      variables
    )
    setCachedQuery(queryKey, data, ttl)
    data
  }
}
```

## Best Practices

### 1. Environment Management

```rescript
// Create separate environments for different contexts
let environments = {
  development: lazy(createServerEnvironment(~endpoint="http://localhost:4000/graphql")),
  production: lazy(createServerEnvironment(~endpoint="https://api.production.com/graphql")),
  test: lazy(createTestEnvironment()),
}

let getCurrentEnvironment = () => {
  switch Node.Process.env->Js.Dict.get("NODE_ENV") {
  | Some("production") => Lazy.force(environments.production)
  | Some("test") => Lazy.force(environments.test)
  | _ => Lazy.force(environments.development)
  }
}
```

### 2. Resource Cleanup

```rescript
// Properly clean up resources
let cleanup = () => {
  // Clear any intervals/timeouts
  clearSyncScheduler()
  
  // Dispose of environment resources
  RescriptRelay.Environment.dispose(environment)
  
  // Clear caches
  Js.Dict.clear(cacheStore)
}

// Handle process termination
Node.Process.on("SIGTERM", () => {
  Console.log("Cleaning up...")
  cleanup()
  Node.Process.exit(0)
})
```

### 3. Monitoring and Logging

```rescript
// Add comprehensive logging
let logQuery = (operation, variables, duration) => {
  if (Node.Process.env->Js.Dict.get("LOG_QUERIES") === Some("true")) {
    Console.log(`Query: ${operation.name}`)
    Console.log(`Variables: ${Js.Json.stringify(variables)}`)
    Console.log(`Duration: ${Float.toString(duration)}ms`)
  }
}

let timedFetch = async (query, variables) => {
  let start = Js.Date.now()
  try {
    let result = await RescriptRelay.Environment.fetchQuery(
      environment,
      query,
      variables
    )
    let duration = Js.Date.now() -. start
    logQuery(query, variables, duration)
    result
  } catch {
  | error => 
    let duration = Js.Date.now() -. start
    Console.error(`Query failed after ${Float.toString(duration)}ms`)
    raise(error)
  }
}
```

Non-React mode opens up powerful possibilities for using RescriptRelay in server-side applications, enabling you to leverage the same type-safe GraphQL patterns across your entire stack.