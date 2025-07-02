# Field Handlers

Field handlers allow you to customize how Relay stores and retrieves specific fields in the cache. They provide a way to transform, validate, or process field values before they are stored or when they are retrieved from the Relay store.

## Overview

Field handlers are functions that intercept field values during store operations, allowing you to:

- Transform data before storage (e.g., normalize timestamps, format strings)
- Implement custom caching logic for specific fields
- Add computed properties or derived values
- Handle special data types that need custom serialization
- Implement field-level validation or sanitization

## Basic Setup

### Registering Field Handlers

```rescript
// Environment setup with field handlers
let createEnvironmentWithHandlers = () => {
  let environment = RescriptRelay.Environment.make(
    ~network=networkConfig,
    ~store=RescriptRelay.Store.make(RescriptRelay.RecordSource.make()),
    ()
  )
  
  // Register field handlers
  registerTimestampHandlers(environment)
  registerCurrencyHandlers(environment)
  registerImageHandlers(environment)
  
  environment
}
```

### Basic Field Handler

```rescript
// Simple timestamp formatter
let timestampHandler = (fieldValue, _args) => {
  switch fieldValue {
  | Some(timestamp) when Js.typeof(timestamp) === "string" => 
    // Convert ISO string to formatted date
    let date = Js.Date.fromString(timestamp)
    Some(Js.Date.toLocaleDateString(date))
  | Some(timestamp) when Js.typeof(timestamp) === "number" => 
    // Convert Unix timestamp to formatted date
    let date = Js.Date.fromFloat(timestamp *. 1000.0)
    Some(Js.Date.toLocaleDateString(date))
  | value => value // Pass through unchanged
  }
}

// Register the handler
let registerTimestampHandlers = (environment) => {
  RescriptRelay.Environment.addFieldHandler(
    environment,
    ~fieldName="createdAt",
    ~handler=timestampHandler
  )
  
  RescriptRelay.Environment.addFieldHandler(
    environment,
    ~fieldName="updatedAt", 
    ~handler=timestampHandler
  )
  
  RescriptRelay.Environment.addFieldHandler(
    environment,
    ~fieldName="publishedAt",
    ~handler=timestampHandler
  )
}
```

## Common Field Handler Patterns

### 1. Data Transformation Handlers

#### Currency Formatting

```rescript
type currencyInfo = {
  code: string,
  symbol: string,
  decimals: int,
}

let getCurrencyInfo = (code) => {
  switch code {
  | "USD" => {code: "USD", symbol: "$", decimals: 2}
  | "EUR" => {code: "EUR", symbol: "€", decimals: 2}
  | "JPY" => {code: "JPY", symbol: "¥", decimals: 0}
  | _ => {code: "USD", symbol: "$", decimals: 2} // Default
  }
}

let currencyHandler = (fieldValue, args) => {
  switch (fieldValue, args->Js.Dict.get("currency")) {
  | (Some(amount), Some(currencyCode)) => 
    let currency = getCurrencyInfo(currencyCode)
    let formattedAmount = amount
      ->Float.toFixedWithPrecision(~digits=currency.decimals)
    Some(currency.symbol ++ formattedAmount)
  | (Some(amount), None) => 
    // Default to USD formatting
    Some("$" ++ Float.toFixedWithPrecision(amount, ~digits=2))
  | (None, _) => None
  }
}

let registerCurrencyHandlers = (environment) => {
  ["price", "amount", "total", "subtotal", "tax"]->Array.forEach(fieldName => {
    RescriptRelay.Environment.addFieldHandler(
      environment,
      ~fieldName,
      ~handler=currencyHandler
    )
  })
}
```

#### Text Processing

```rescript
let textProcessingHandler = (fieldValue, args) => {
  switch fieldValue {
  | Some(text) when Js.typeof(text) === "string" => 
    let processedText = text
      ->String.trim()
      ->String.replaceByRe(%re("/\s+/g"), " ") // Normalize whitespace
      ->String.replaceByRe(%re("/<script.*?<\/script>/gi"), "") // Remove scripts
    
    // Apply transformations based on args
    let finalText = switch args->Js.Dict.get("transform") {
    | Some("uppercase") => String.toUpperCase(processedText)
    | Some("lowercase") => String.toLowerCase(processedText)
    | Some("capitalize") => capitalizeWords(processedText)
    | _ => processedText
    }
    
    Some(finalText)
  | value => value
  }
}
```

### 2. Data Validation Handlers

```rescript
let emailValidationHandler = (fieldValue, _args) => {
  switch fieldValue {
  | Some(email) when Js.typeof(email) === "string" => 
    let emailRegex = %re("/^[^\s@]+@[^\s@]+\.[^\s@]+$/")
    if (Js.Re.test_(emailRegex, email)) {
      Some(String.toLowerCase(email)) // Normalize to lowercase
    } else {
      Console.warn("Invalid email format: " ++ email)
      None // Invalid email, store as null
    }
  | value => value
  }
}

let urlValidationHandler = (fieldValue, _args) => {
  switch fieldValue {
  | Some(url) when Js.typeof(url) === "string" => 
    try {
      let _ = URL.make(url) // Validate URL format
      // Ensure HTTPS for external URLs
      if (String.startsWith(url, "http://")) {
        Some(String.replace(url, "http://", "https://"))
      } else {
        Some(url)
      }
    } catch {
    | _ => 
      Console.warn("Invalid URL format: " ++ url)
      None
    }
  | value => value
  }
}
```

### 3. Computed Field Handlers

```rescript
// Handler that computes derived values
let userDisplayNameHandler = (fieldValue, args) => {
  switch (
    args->Js.Dict.get("firstName"),
    args->Js.Dict.get("lastName"),
    args->Js.Dict.get("username")
  ) {
  | (Some(firstName), Some(lastName), _) => 
    Some(firstName ++ " " ++ lastName)
  | (Some(firstName), None, _) => 
    Some(firstName)
  | (None, Some(lastName), _) => 
    Some(lastName)
  | (None, None, Some(username)) => 
    Some("@" ++ username)
  | _ => 
    Some("Anonymous User")
  }
}

// Handler for computed timestamps
let relativeTimeHandler = (fieldValue, _args) => {
  switch fieldValue {
  | Some(timestamp) => 
    let now = Js.Date.now()
    let date = Js.Date.fromString(timestamp)
    let diff = now -. Js.Date.getTime(date)
    
    let relativeTime = if (diff < 60000.0) {
      "just now"
    } else if (diff < 3600000.0) {
      let minutes = Math.floor(diff /. 60000.0)
      `${Float.toString(minutes)} minutes ago`
    } else if (diff < 86400000.0) {
      let hours = Math.floor(diff /. 3600000.0)
      `${Float.toString(hours)} hours ago`
    } else {
      let days = Math.floor(diff /. 86400000.0)
      `${Float.toString(days)} days ago`
    }
    
    Some(relativeTime)
  | None => None
  }
}
```

### 4. Collection Handlers

```rescript
// Handler for sorting arrays
let sortedListHandler = (fieldValue, args) => {
  switch fieldValue {
  | Some(items) when Js.Array.isArray(items) => 
    let sortedItems = switch args->Js.Dict.get("sortBy") {
    | Some("name") => 
      items->Array.sort((a, b) => String.compare(a.name, b.name))
    | Some("date") => 
      items->Array.sort((a, b) => 
        Float.compare(
          Js.Date.fromString(a.createdAt)->Js.Date.getTime,
          Js.Date.fromString(b.createdAt)->Js.Date.getTime
        )
      )
    | Some("priority") => 
      items->Array.sort((a, b) => Int.compare(b.priority, a.priority))
    | _ => items
    }
    Some(sortedItems)
  | value => value
  }
}

// Handler for filtering arrays
let filteredListHandler = (fieldValue, args) => {
  switch fieldValue {
  | Some(items) when Js.Array.isArray(items) => 
    let filteredItems = switch args->Js.Dict.get("filter") {
    | Some("active") => 
      items->Array.filter(item => item.status === "active")
    | Some("published") => 
      items->Array.filter(item => item.published === true)
    | Some("recent") => 
      let weekAgo = Js.Date.now() -. (7.0 *. 24.0 *. 60.0 *. 60.0 *. 1000.0)
      items->Array.filter(item => 
        Js.Date.fromString(item.createdAt)->Js.Date.getTime > weekAgo
      )
    | _ => items
    }
    Some(filteredItems)
  | value => value
  }
}
```

## Advanced Field Handler Techniques

### 1. Context-Aware Handlers

```rescript
// Handler that uses context from the environment
let userPermissionHandler = (fieldValue, args) => {
  let currentUser = getCurrentUser()
  let targetUserId = args->Js.Dict.get("userId")
  
  switch (fieldValue, currentUser, targetUserId) {
  | (Some(data), Some(user), Some(userId)) => 
    // Only show sensitive data to the user themselves or admins
    if (user.id === userId || user.role === "admin") {
      Some(data)
    } else {
      None // Hide sensitive data
    }
  | (value, _, _) => value
  }
}

// Dynamic handler based on user preferences
let localizationHandler = (fieldValue, args) => {
  let userLocale = getUserLocale()
  let timezone = getUserTimezone()
  
  switch fieldValue {
  | Some(timestamp) => 
    let date = Js.Date.fromString(timestamp)
    let localizedDate = date
      ->Js.Date.toLocaleDateString(userLocale)
      ->formatForTimezone(timezone)
    Some(localizedDate)
  | None => None
  }
}
```

### 2. Caching Handlers

```rescript
// Handler with built-in caching
let expensiveComputationHandler = {
  let cache = ref(Map.empty)
  
  (fieldValue, args) => {
    switch fieldValue {
    | Some(inputData) => 
      let cacheKey = Js.Json.stringify(inputData)
      
      switch cache.contents->Map.get(cacheKey) {
      | Some(cachedResult) => Some(cachedResult)
      | None => 
        // Perform expensive computation
        let result = performExpensiveComputation(inputData)
        cache := cache.contents->Map.set(cacheKey, result)
        Some(result)
      }
    | None => None
    }
  }
}

// Handler with TTL cache
let ttlCacheHandler = {
  let cache = ref(Map.empty)
  let ttl = 300000.0 // 5 minutes
  
  (fieldValue, args) => {
    switch fieldValue {
    | Some(data) => 
      let cacheKey = args->Js.Dict.get("key")->Option.getWithDefault("default")
      let now = Js.Date.now()
      
      switch cache.contents->Map.get(cacheKey) {
      | Some({data: cachedData, timestamp}) when now -. timestamp < ttl => 
        Some(cachedData)
      | _ => 
        let processedData = processData(data)
        cache := cache.contents->Map.set(cacheKey, {
          data: processedData,
          timestamp: now
        })
        Some(processedData)
      }
    | None => None
    }
  }
}
```

### 3. Async Field Handlers

```rescript
// Handler for lazy loading additional data
let lazyLoadHandler = (fieldValue, args) => {
  switch (fieldValue, args->Js.Dict.get("shouldLoad")) {
  | (Some(placeholder), Some("true")) => 
    // Trigger async load (implementation depends on your setup)
    loadAdditionalData(args->Js.Dict.get("resourceId"))
    ->Promise.then(data => {
      // Update cache with loaded data
      updateFieldInCache(args, data)
    })
    ->ignore
    
    Some(placeholder) // Return placeholder while loading
  | (value, _) => value
  }
}
```

## Connection Field Handlers

Special handlers for Relay connections:

```rescript
// Handler for connection metadata
let connectionMetadataHandler = (fieldValue, args) => {
  switch fieldValue {
  | Some(connection) => 
    let enhancedConnection = {
      ...connection,
      metadata: {
        totalCount: connection.edges->Array.length,
        hasData: Array.length(connection.edges) > 0,
        lastUpdated: Js.Date.now(),
        filterApplied: args->Js.Dict.get("filter")->Option.isSome,
      }
    }
    Some(enhancedConnection)
  | None => None
  }
}

// Handler for connection sorting and filtering
let connectionProcessingHandler = (fieldValue, args) => {
  switch fieldValue {
  | Some(connection) => 
    let processedEdges = connection.edges
    
    // Apply filtering
    let filteredEdges = switch args->Js.Dict.get("filter") {
    | Some(filterValue) => 
      processedEdges->Array.filter(edge => 
        matchesFilter(edge.node, filterValue)
      )
    | None => processedEdges
    }
    
    // Apply sorting
    let sortedEdges = switch args->Js.Dict.get("sortBy") {
    | Some(sortField) => 
      filteredEdges->Array.sort((a, b) => 
        compareFields(a.node, b.node, sortField)
      )
    | None => filteredEdges
    }
    
    Some({
      ...connection,
      edges: sortedEdges
    })
  | None => None
  }
}
```

## Performance Considerations

### 1. Handler Optimization

```rescript
// Memoized handler to avoid recomputation
let memoizedHandler = {
  let lastInput = ref(None)
  let lastOutput = ref(None)
  
  (fieldValue, args) => {
    let currentInput = (fieldValue, args)
    
    switch (lastInput.contents, lastOutput.contents) {
    | (Some(prevInput), Some(prevOutput)) when prevInput === currentInput => 
      prevOutput
    | _ => 
      let result = expensiveTransformation(fieldValue, args)
      lastInput := Some(currentInput)
      lastOutput := Some(result)
      result
    }
  }
}

// Selective handler that only processes when needed
let conditionalHandler = (fieldValue, args) => {
  // Only process if specific conditions are met
  let shouldProcess = switch args->Js.Dict.get("process") {
  | Some("true") => true
  | _ => false
  }
  
  if (shouldProcess) {
    performProcessing(fieldValue, args)
  } else {
    fieldValue // Pass through unchanged
  }
}
```

### 2. Error Handling in Handlers

```rescript
let safeHandler = (fieldValue, args) => {
  try {
    riskyTransformation(fieldValue, args)
  } catch {
  | Js.Exn.Error(error) => 
    Console.warn("Field handler error:", error)
    fieldValue // Return original value on error
  | _ => 
    Console.warn("Unknown field handler error")
    fieldValue
  }
}

let validatingHandler = (fieldValue, args) => {
  switch fieldValue {
  | Some(data) => 
    if (isValidData(data)) {
      Some(transformData(data, args))
    } else {
      Console.warn("Invalid data in field handler")
      None
    }
  | None => None
  }
}
```

## Testing Field Handlers

```rescript
// Unit testing field handlers
let testTimestampHandler = () => {
  // Test with ISO string
  let result1 = timestampHandler(Some("2023-01-01T12:00:00Z"), Js.Dict.empty())
  expect(result1)->toEqual(Some("1/1/2023"))
  
  // Test with Unix timestamp
  let result2 = timestampHandler(Some(1672574400.0), Js.Dict.empty())
  expect(result2)->toEqual(Some("1/1/2023"))
  
  // Test with null value
  let result3 = timestampHandler(None, Js.Dict.empty())
  expect(result3)->toEqual(None)
}

// Integration testing with mock environment
let testHandlerIntegration = () => {
  let testEnvironment = createTestEnvironment()
  registerTimestampHandlers(testEnvironment)
  
  // Commit data and verify handler was applied
  let data = {"createdAt": "2023-01-01T12:00:00Z"}
  let stored = storeData(testEnvironment, data)
  
  expect(stored.createdAt)->toEqual("1/1/2023")
}
```

## Best Practices

1. **Keep Handlers Pure**: Avoid side effects in field handlers when possible
2. **Handle Edge Cases**: Always account for null/undefined values
3. **Performance**: Use memoization for expensive computations
4. **Error Handling**: Gracefully handle errors and invalid data
5. **Testing**: Thoroughly test handlers with various input scenarios
6. **Documentation**: Document handler behavior and expectations
7. **Versioning**: Consider backward compatibility when updating handlers

Field handlers provide powerful customization capabilities for your Relay cache, enabling you to implement sophisticated data processing, validation, and transformation logic while maintaining type safety and performance.