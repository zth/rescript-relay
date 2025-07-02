# Persisted Queries

Persisted queries allow you to send query IDs instead of full query strings to your GraphQL server, reducing bundle size, improving security, and enabling better caching strategies.

## Overview

With persisted queries, instead of sending the full GraphQL query text:

```graphql
query UserQuery($userId: ID!) {
  user(id: $userId) {
    id
    name
    email
  }
}
```

You send a query ID:

```json
{
  "id": "abc123def456",
  "variables": {"userId": "user-123"}
}
```

This provides several benefits:
- **Reduced Bundle Size**: Query strings aren't included in your client bundle
- **Better Security**: Query text isn't exposed to the client
- **Improved Caching**: Servers can cache by query ID more efficiently
- **Query Allowlisting**: Only pre-approved queries can be executed

## Setup and Configuration

### 1. Build-time Query Extraction

Configure your build process to extract queries and generate IDs:

```json
// package.json
{
  "scripts": {
    "relay": "relay-compiler --persist-output ./persisted-queries.json",
    "build": "npm run relay && npm run build-app"
  }
}
```

```json
// relay.config.js
module.exports = {
  src: "./src",
  schema: "./schema.graphql",
  persistConfig: {
    file: "./persisted-queries.json",
    algorithm: "SHA256"
  }
}
```

### 2. Environment Configuration

Configure your Relay environment to use persisted queries:

```rescript
// Environment.res
let createEnvironment = () => {
  let network = RescriptRelay.Network.makePromiseBased(
    ~fetchFunction=(operation, variables, _cacheConfig) => {
      let endpoint = "https://api.example.com/graphql"
      
      // Check if operation has a persisted query ID
      let body = switch operation.persistedQueryId {
      | Some(id) => 
        // Send persisted query ID
        Js.Dict.fromArray([
          ("id", Js.Json.string(id)),
          ("variables", variables)
        ])
      | None =>
        // Fallback to full query (development mode)
        Js.Dict.fromArray([
          ("query", Js.Json.string(operation.text)),
          ("variables", variables)
        ])
      }
      
      Fetch.fetchWithInit(endpoint, {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: body->Js.Json.object_->Js.Json.stringify
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
```

## Implementation Strategies

### 1. Automatic Persisted Queries (APQ)

APQ allows fallback to full queries when IDs aren't recognized:

```rescript
let createAPQEnvironment = () => {
  let network = RescriptRelay.Network.makePromiseBased(
    ~fetchFunction=(operation, variables, _cacheConfig) => {
      let endpoint = "https://api.example.com/graphql"
      
      // Try persisted query first
      let tryPersistedQuery = () => {
        switch operation.persistedQueryId {
        | Some(id) => 
          let body = {
            "id": id,
            "variables": variables
          }
          
          Fetch.fetchWithInit(endpoint, {
            method: "POST", 
            headers: {"Content-Type": "application/json"},
            body: Js.Json.stringify(body)
          })
          ->Promise.then(response => {
            if (Fetch.Response.status(response) === 200) {
              Fetch.Response.json(response)
            } else {
              // Fallback to full query if persisted query not found
              let fullQueryBody = {
                "query": operation.text,
                "variables": variables
              }
              
              Fetch.fetchWithInit(endpoint, {
                method: "POST",
                headers: {"Content-Type": "application/json"},
                body: Js.Json.stringify(fullQueryBody)
              })
              ->Promise.then(Fetch.Response.json)
            }
          })
        | None =>
          // No persisted ID, send full query
          let body = {
            "query": operation.text,
            "variables": variables
          }
          
          Fetch.fetchWithInit(endpoint, {
            method: "POST",
            headers: {"Content-Type": "application/json"}, 
            body: Js.Json.stringify(body)
          })
          ->Promise.then(Fetch.Response.json)
        }
      }
      
      tryPersistedQuery()
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

### 2. Environment-Specific Configuration

Different configurations for different environments:

```rescript
// EnvironmentConfig.res
type persistedQueryConfig = {
  enabled: bool,
  fallbackToFullQuery: bool,
  endpoint: string,
}

let getConfig = () => {
  switch Node.Process.env->Js.Dict.get("NODE_ENV") {
  | Some("production") => {
      enabled: true,
      fallbackToFullQuery: false, // Strict mode in production
      endpoint: "https://api.production.com/graphql"
    }
  | Some("staging") => {
      enabled: true, 
      fallbackToFullQuery: true, // Allow fallback in staging
      endpoint: "https://api.staging.com/graphql"
    }
  | _ => {
      enabled: false, // Disabled in development
      fallbackToFullQuery: true,
      endpoint: "http://localhost:4000/graphql"
    }
  }
}

let createConfiguredEnvironment = () => {
  let config = getConfig()
  
  let network = RescriptRelay.Network.makePromiseBased(
    ~fetchFunction=(operation, variables, _cacheConfig) => {
      let body = if (config.enabled) {
        switch operation.persistedQueryId {
        | Some(id) => 
          Some({
            "id": id,
            "variables": variables
          })
        | None when config.fallbackToFullQuery => 
          Some({
            "query": operation.text,
            "variables": variables
          })
        | None => 
          None // Error: no persisted ID and fallback disabled
        }
      } else {
        // Persisted queries disabled, always use full query
        Some({
          "query": operation.text,
          "variables": variables
        })
      }
      
      switch body {
      | Some(requestBody) => 
        Fetch.fetchWithInit(config.endpoint, {
          method: "POST",
          headers: {"Content-Type": "application/json"},
          body: Js.Json.stringify(requestBody)
        })
        ->Promise.then(Fetch.Response.json)
      | None => 
        Promise.reject(Js.Exn.raiseError("No persisted query ID and fallback disabled"))
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
```

## Server-Side Implementation

### 1. Query Store

Store persisted queries on your server:

```rescript
// Server-side (Node.js example)
let persistedQueries = ref(Map.empty)

let loadPersistedQueries = () => {
  // Load from JSON file generated during build
  let queries = Node.Fs.readFileSync("./persisted-queries.json", "utf8")
  let parsed = Js.Json.parseExn(queries)
  
  // Convert to Map for fast lookup
  parsed
  ->Js.Dict.entries
  ->Array.forEach(((id, query)) => {
    persistedQueries := persistedQueries.contents->Map.set(id, query)
  })
}

let getPersistedQuery = (id) => {
  persistedQueries.contents->Map.get(id)
}
```

### 2. GraphQL Handler

Handle both persisted and regular queries:

```rescript
let graphqlHandler = (req, res) => {
  let body = req.body
  
  let query = switch (body->Js.Dict.get("id"), body->Js.Dict.get("query")) {
  | (Some(id), _) => 
    // Persisted query
    switch getPersistedQuery(id) {
    | Some(persistedQuery) => Ok(persistedQuery)
    | None => Error("Persisted query not found")
    }
  | (None, Some(queryText)) => 
    // Regular query
    Ok(queryText)
  | (None, None) => 
    Error("No query or persisted query ID provided")
  }
  
  switch query {
  | Ok(queryText) => 
    let variables = body->Js.Dict.get("variables")->Option.getWithDefault(Js.Json.null)
    executeGraphQL(queryText, variables)
    ->Promise.then(result => {
      res->Express.Response.json(result)
    })
    ->ignore
  | Error(message) => 
    res->Express.Response.status(400)->Express.Response.json({
      "error": message
    })
  }
}
```

## Build Process Integration

### 1. Webpack Plugin

Integrate query extraction with your build process:

```javascript
// webpack.config.js
const RelayCompilerWebpackPlugin = require('relay-compiler-webpack-plugin');

module.exports = {
  // ... other config
  plugins: [
    new RelayCompilerWebpackPlugin({
      schema: path.resolve(__dirname, './schema.graphql'),
      src: path.resolve(__dirname, './src'),
      persistConfig: {
        file: path.resolve(__dirname, './build/persisted-queries.json'),
        algorithm: 'SHA256'
      }
    })
  ]
};
```

### 2. Custom Build Script

Create a custom script for query extraction:

```rescript
// scripts/extractQueries.res
let extractPersistedQueries = () => {
  let sourcePath = "./src"
  let outputPath = "./build/persisted-queries.json"
  
  // Find all .res files with relay queries
  let files = findFilesWithQueries(sourcePath)
  let queries = Map.empty
  
  files->Array.forEach(filePath => {
    let content = Node.Fs.readFileSync(filePath, "utf8")
    let extractedQueries = parseRelayQueries(content)
    
    extractedQueries->Array.forEach(query => {
      let id = generateQueryId(query.text)
      queries := queries->Map.set(id, query.text)
    })
  })
  
  // Write to output file
  let json = queries->Map.toArray->Js.Dict.fromArray->Js.Json.object_
  Node.Fs.writeFileSync(outputPath, Js.Json.stringify(json))
  
  Console.log(`Extracted ${Map.size(queries)} persisted queries to ${outputPath}`)
}

// Run if called directly
if (Node.Process.argv->Array.get(1)->Option.map(String.endsWith("extractQueries.js"))->Option.getWithDefault(false)) {
  extractPersistedQueries()
}
```

## Advanced Configuration

### 1. Query ID Generation

Custom query ID generation strategies:

```rescript
let generateQueryId = (queryText, ~algorithm="SHA256", ()) => {
  switch algorithm {
  | "SHA256" => 
    // Use crypto library to generate SHA256 hash
    Crypto.createHash("sha256")->Crypto.Hash.update(queryText)->Crypto.Hash.digest("hex")
  | "MD5" => 
    Crypto.createHash("md5")->Crypto.Hash.update(queryText)->Crypto.Hash.digest("hex")
  | "SIMPLE" => 
    // Simple hash for development
    let hash = ref(0)
    for i in 0 to String.length(queryText) - 1 {
      let char = String.charCodeAt(queryText, i)
      hash := hash.contents * 31 + char
    }
    Int.toString(hash.contents)
  | _ => 
    raise(Js.Exn.raiseError("Unsupported hash algorithm"))
  }
}
```

### 2. Conditional Persisted Queries

Enable persisted queries conditionally:

```rescript
let shouldUsePersistedQueries = (operation) => {
  // Only use persisted queries for certain operations
  let persistableOperations = [
    "UserQuery",
    "PostsQuery", 
    "ProductsQuery",
    // ... other frequently used queries
  ]
  
  // Don't persist development/debug queries
  let debugOperations = [
    "DevToolsQuery",
    "TestQuery",
  ]
  
  persistableOperations->Array.includes(operation.name) &&
  !debugOperations->Array.includes(operation.name)
}

let smartPersistedQueryNetwork = RescriptRelay.Network.makePromiseBased(
  ~fetchFunction=(operation, variables, _cacheConfig) => {
    let usePersistedQuery = shouldUsePersistedQueries(operation)
    
    let body = if (usePersistedQuery) {
      switch operation.persistedQueryId {
      | Some(id) => {"id": id, "variables": variables}
      | None => {"query": operation.text, "variables": variables}
      }
    } else {
      {"query": operation.text, "variables": variables}
    }
    
    fetchGraphQL(body)
  },
  ()
)
```

### 3. Query Versioning

Handle query versioning for long-running applications:

```rescript
type queryVersion = {
  id: string,
  version: int,
  query: string,
}

let versionedPersistedQueries = ref(Map.empty)

let registerQueryVersion = (id, version, queryText) => {
  let versionedId = id ++ "_v" ++ Int.toString(version)
  versionedPersistedQueries := versionedPersistedQueries.contents->Map.set(versionedId, {
    id,
    version,
    query: queryText
  })
}

let getQueryByVersion = (id, version) => {
  let versionedId = id ++ "_v" ++ Int.toString(version)
  versionedPersistedQueries.contents->Map.get(versionedId)
}
```

## Security Considerations

### 1. Query Allowlisting

Implement strict query allowlisting:

```rescript
let allowedQueries = ref(Set.empty)

let loadAllowedQueries = () => {
  // Load from secure configuration
  let allowed = getSecureConfig("allowed_queries")
  allowedQueries := Set.fromArray(allowed)
}

let isQueryAllowed = (queryId) => {
  allowedQueries.contents->Set.has(queryId)
}

let secureGraphQLHandler = (req, res) => {
  let body = req.body
  
  switch body->Js.Dict.get("id") {
  | Some(queryId) when isQueryAllowed(queryId) => 
    // Process allowed persisted query
    executePersistedQuery(queryId, body->Js.Dict.get("variables"))
  | Some(_) => 
    // Reject disallowed query
    res->Express.Response.status(403)->Express.Response.json({
      "error": "Query not allowed"
    })
  | None => 
    // Reject non-persisted queries in production
    res->Express.Response.status(400)->Express.Response.json({
      "error": "Only persisted queries allowed"
    })
  }
}
```

### 2. Rate Limiting by Query ID

Implement per-query rate limiting:

```rescript
let queryRateLimits = Map.fromArray([
  ("expensive_analytics_query", {limit: 10, window: 3600}), // 10 per hour
  ("user_search_query", {limit: 100, window: 60}),         // 100 per minute
  ("frequent_user_query", {limit: 1000, window: 60}),      // 1000 per minute
])

let checkRateLimit = (queryId, userId) => {
  switch queryRateLimits->Map.get(queryId) {
  | Some(limits) => 
    let key = queryId ++ "_" ++ userId
    checkUserRateLimit(key, limits.limit, limits.window)
  | None => 
    true // No specific limit, allow
  }
}
```

## Performance Optimization

### 1. Query Caching

Cache persisted queries aggressively:

```rescript
let queryCache = ref(Map.empty)
let queryCacheTTL = 3600.0 // 1 hour

let getCachedQuery = (queryId) => {
  switch queryCache.contents->Map.get(queryId) {
  | Some({query, timestamp}) => 
    let now = Js.Date.now()
    if (now -. timestamp < queryCacheTTL *. 1000.0) {
      Some(query)
    } else {
      // Expired, remove from cache
      queryCache := queryCache.contents->Map.remove(queryId)
      None
    }
  | None => None
  }
}

let setCachedQuery = (queryId, query) => {
  queryCache := queryCache.contents->Map.set(queryId, {
    query,
    timestamp: Js.Date.now()
  })
}
```

### 2. Lazy Query Loading

Load queries on demand:

```rescript
let lazyQueryLoader = {
  let loadedQueries = ref(Set.empty)
  
  let loadQuery = async (queryId) => {
    if (!loadedQueries.contents->Set.has(queryId)) {
      // Load query from remote source or database
      let query = await fetchQueryFromStore(queryId)
      persistedQueries := persistedQueries.contents->Map.set(queryId, query)
      loadedQueries := loadedQueries.contents->Set.add(queryId)
    }
  }
  
  loadQuery
}
```

## Monitoring and Analytics

### 1. Query Usage Tracking

Track which persisted queries are being used:

```rescript
let queryUsageStats = ref(Map.empty)

let trackQueryUsage = (queryId) => {
  let currentCount = queryUsageStats.contents->Map.get(queryId)->Option.getWithDefault(0)
  queryUsageStats := queryUsageStats.contents->Map.set(queryId, currentCount + 1)
}

let getUsageReport = () => {
  queryUsageStats.contents
  ->Map.toArray
  ->Array.sort(((_, a), (_, b)) => b - a) // Sort by usage count
  ->Array.slice(~start=0, ~end=10)       // Top 10
}
```

### 2. Performance Monitoring

Monitor persisted query performance:

```rescript
let queryPerformanceMetrics = ref(Map.empty)

let trackQueryPerformance = (queryId, duration) => {
  let metrics = queryPerformanceMetrics.contents->Map.get(queryId)->Option.getWithDefault({
    count: 0,
    totalDuration: 0.0,
    minDuration: Float.maxValue,
    maxDuration: 0.0,
  })
  
  let updatedMetrics = {
    count: metrics.count + 1,
    totalDuration: metrics.totalDuration +. duration,
    minDuration: Math.min(metrics.minDuration, duration),
    maxDuration: Math.max(metrics.maxDuration, duration),
  }
  
  queryPerformanceMetrics := queryPerformanceMetrics.contents->Map.set(queryId, updatedMetrics)
}
```

## Best Practices

1. **Generate Stable IDs**: Use deterministic hashing for consistent query IDs
2. **Version Control**: Keep persisted queries in version control
3. **Gradual Rollout**: Deploy persisted queries gradually to detect issues
4. **Monitoring**: Monitor query usage and performance metrics
5. **Security First**: Implement allowlisting in production environments
6. **Cache Efficiently**: Cache queries both client and server-side
7. **Fallback Strategy**: Always have a fallback plan for missing queries
8. **Documentation**: Document your persisted query strategy and deployment process

Persisted queries are a powerful optimization technique that can significantly improve your application's performance, security, and scalability when implemented correctly.