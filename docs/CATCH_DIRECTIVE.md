# The @catch Directive

The `@catch` directive allows you to handle GraphQL errors at the field level, providing more granular error handling than traditional query-level error handling.

## Overview

When you apply `@catch` to a field, instead of the entire query failing when that field encounters an error, the field will return a `Result` type that you can pattern match on. This enables graceful degradation and better user experiences.

## Basic Usage

```rescript
module UserQuery = %relay(`
  query UserQuery($userId: ID!) {
    user(id: $userId) {
      id
      name
      email @catch
      avatar @catch
      phoneNumber @catch
    }
  }
`)

@react.component
let make = (~userId) => {
  let data = UserQuery.use(~variables={userId}, ())
  
  switch data.user {
  | Some(user) =>
    <div>
      <h1>{React.string(user.name)}</h1>
      
      {/* Handle email field that might error */}
      {switch user.email {
      | Ok(email) => 
        <p className="email">
          {React.string("Email: " ++ email)}
        </p>
      | Error(error) => 
        <p className="email-error">
          {React.string("Email unavailable: " ++ error.message)}
        </p>
      }}
      
      {/* Handle avatar with graceful fallback */}
      {switch user.avatar {
      | Ok(avatarUrl) => 
        <img src=avatarUrl alt="User avatar" className="avatar" />
      | Error(_) => 
        <div className="avatar-placeholder">
          {React.string(String.get(user.name, 0)->String.make(1))}
        </div>
      }}
      
      {/* Optional field display */}
      {switch user.phoneNumber {
      | Ok(phone) => 
        <p>{React.string("Phone: " ++ phone)}</p>
      | Error(_) => React.null
      }}
    </div>
  | None => <div>{React.string("User not found")}</div>
  }
}
```

## Error Information

The `Error` case contains detailed information about what went wrong:

```rescript
{switch user.email {
| Ok(email) => <span>{React.string(email)}</span>
| Error(error) => 
  <div className="error-details">
    <p>{React.string("Error: " ++ error.message)}</p>
    <p>{React.string("Code: " ++ error.code)}</p>
    {/* Log for debugging in development */}
    {Js.log(error); React.null}
  </div>
}}
```

## Advanced Patterns

### Connection Error Handling

Handle errors in lists and connections:

```rescript
module UserPostsQuery = %relay(`
  query UserPostsQuery($userId: ID!) {
    user(id: $userId) {
      id
      name
      posts @catch {
        edges {
          node {
            id
            title
            content
          }
        }
      }
      followers @catch {
        totalCount
      }
    }
  }
`)

@react.component
let make = (~userId) => {
  let data = UserPostsQuery.use(~variables={userId}, ())
  
  switch data.user {
  | Some(user) =>
    <div>
      <h1>{React.string(user.name)}</h1>
      
      {/* Handle posts connection errors */}
      {switch user.posts {
      | Ok(posts) => 
        <div className="posts-section">
          <h2>{React.string("Posts")}</h2>
          {posts.edges
          ->Array.map(edge => 
            <article key={edge.node.id} className="post">
              <h3>{React.string(edge.node.title)}</h3>
              <p>{React.string(edge.node.content)}</p>
            </article>
          )
          ->React.array}
        </div>
      | Error(_) => 
        <div className="posts-error">
          <h2>{React.string("Posts")}</h2>
          <p>{React.string("Unable to load posts at this time")}</p>
          <button onClick={_ => Window.location.reload()}>
            {React.string("Retry")}
          </button>
        </div>
      }}
      
      {/* Handle follower count errors */}
      {switch user.followers {
      | Ok(followers) => 
        <p>{React.string(
          "Followers: " ++ Int.toString(followers.totalCount)
        )}</p>
      | Error(_) => 
        <p>{React.string("Follower count unavailable")}</p>
      }}
    </div>
  | None => <div>{React.string("User not found")}</div>
  }
}
```

### Nested Fragment Error Handling

```rescript
module UserFragment = %relay(`
  fragment UserFragment_user on User {
    id
    name
    profile @catch {
      bio
      website
      location
    }
  }
`)

@react.component
let make = (~user) => {
  let userData = UserFragment.use(user)
  
  <div className="user-card">
    <h3>{React.string(userData.name)}</h3>
    
    {switch userData.profile {
    | Ok(profile) => 
      <div className="profile-details">
        {switch profile.bio {
        | Some(bio) => <p className="bio">{React.string(bio)}</p>
        | None => React.null
        }}
        {switch profile.website {
        | Some(website) => 
          <a href=website target="_blank">
            {React.string("Visit Website")}
          </a>
        | None => React.null
        }}
        {switch profile.location {
        | Some(location) => 
          <p className="location">{React.string(location)}</p>
        | None => React.null
        }}
      </div>
    | Error(_) => 
      <p className="profile-unavailable">
        {React.string("Profile details unavailable")}
      </p>
    }}
  </div>
}
```

## Use Cases

### 1. Permission-Based Field Access

When users might not have access to certain fields:

```rescript
module ProfileQuery = %relay(`
  query ProfileQuery($userId: ID!) {
    user(id: $userId) {
      id
      name
      email @catch          # Might be private
      phoneNumber @catch    # Might require special permissions
      salary @catch         # Likely restricted
      socialSecurity @catch # Definitely restricted
    }
  }
`)
```

### 2. Optional Service Integration

When external services might be down:

```rescript
module UserWithServicesQuery = %relay(`
  query UserWithServicesQuery($userId: ID!) {
    user(id: $userId) {
      id
      name
      analyticsData @catch    # External analytics service
      recommendations @catch # Recommendation engine
      notifications @catch   # Notification service
    }
  }
`)
```

### 3. Progressive Enhancement

Show basic info first, enhanced info when available:

```rescript
module ProductQuery = %relay(`
  query ProductQuery($productId: ID!) {
    product(id: $productId) {
      id
      name
      price
      description
      reviews @catch {       # Enhanced feature
        averageRating
        totalCount
      }
      relatedProducts @catch # Enhanced feature
      inventory @catch       # Might be restricted
    }
  }
`)

// Component shows basic product info always,
// enhanced features when available
```

## Error Handling Strategies

### 1. Graceful Fallbacks

Always provide meaningful alternatives:

```rescript
{switch user.avatar {
| Ok(avatar) => <img src=avatar alt="Profile" />
| Error(_) => <DefaultAvatarIcon />
}}

{switch product.reviews {
| Ok(reviews) => <ReviewSection reviews />
| Error(_) => <ComingSoonBadge text="Reviews coming soon" />
}}
```

### 2. Retry Mechanisms

Implement retry for transient errors:

```rescript
let (retryCount, setRetryCount) = React.useState(() => 0)

{switch user.data {
| Ok(data) => <DataDisplay data />
| Error(error) when retryCount < 3 => 
  <div>
    <p>{React.string("Loading failed. Retrying...")}</p>
    {React.useEffect(() => {
      let timer = setTimeout(() => {
        setRetryCount(count => count + 1)
        // Trigger refetch
      }, 1000)
      Some(() => clearTimeout(timer))
    }, [retryCount])}
  </div>
| Error(_) => 
  <ErrorMessage message="Unable to load data after multiple attempts" />
}}
```

### 3. Error Reporting

Log errors for monitoring:

```rescript
{switch user.criticalData {
| Ok(data) => <CriticalComponent data />
| Error(error) => 
  {
    // Report to error tracking service
    ErrorReporting.captureException(error, {
      userId: user.id,
      component: "CriticalComponent",
      field: "criticalData"
    })
    
    <ErrorFallback />
  }
}}
```

## Best Practices

### 1. Selective Usage

Don't overuse `@catch`. Only apply it to fields that:
- Might reasonably fail due to permissions
- Depend on external services
- Are optional/enhancement features
- Have good fallback alternatives

### 2. Meaningful Error Messages

Provide context-appropriate error handling:

```rescript
// Good: Context-aware messaging
{switch user.email {
| Ok(email) => <EmailDisplay email />
| Error(_) => <p>{React.string("Email hidden for privacy")}</p>
}}

// Better: Actionable messaging
{switch user.email {
| Ok(email) => <EmailDisplay email />
| Error(_) => 
  <div>
    <p>{React.string("Email not visible")}</p>
    <button onClick={requestEmailAccess}>
      {React.string("Request Access")}
    </button>
  </div>
}}
```

### 3. Consistent Error UI

Maintain consistent error states across your app:

```rescript
// Create reusable error components
module FieldError = {
  @react.component
  let make = (~message, ~retry=?, ()) => {
    <div className="field-error">
      <p>{React.string(message)}</p>
      {switch retry {
      | Some(retryFn) => 
        <button onClick={_ => retryFn()} className="retry-btn">
          {React.string("Try Again")}
        </button>
      | None => React.null
      }}
    </div>
  }
}

// Use consistently
{switch user.data {
| Ok(data) => <DataComponent data />
| Error(_) => <FieldError message="Data unavailable" retry={refetch} />
}}
```

## Limitations

1. **Nullable Fields Only**: `@catch` can only be applied to nullable fields
2. **Selection Set Requirements**: Cannot be used on fields that are part of required selection keys
3. **Error Detail Limitation**: Error information is limited to what the GraphQL server provides
4. **Performance Consideration**: Each `@catch` field adds slight overhead to query processing

## TypeScript Integration

When using TypeScript, the error types are properly typed:

```typescript
// Generated types include proper Result<T, GraphQLError> types
const { user } = UserQuery.use({ variables: { userId } });

if (user) {
  // user.email has type Result<string, GraphQLError>
  switch (user.email.tag) {
    case "Ok":
      return <span>{user.email.value}</span>;
    case "Error":
      return <span>Email unavailable: {user.email.value.message}</span>;
  }
}
```

## Migration from Try-Catch

If you're currently using query-level error handling, here's how to migrate:

```rescript
// Before: Query-level error handling
try {
  let data = UserQuery.use(~variables={userId}, ())
  // Render everything or nothing
} catch {
| error => <ErrorPage error />
}

// After: Field-level error handling
let data = UserQuery.use(~variables={userId}, ())
// Render what works, gracefully handle what doesn't
{switch data.user {
| Some(user) => 
  <div>
    <h1>{React.string(user.name)}</h1>
    {switch user.email {
    | Ok(email) => <EmailComponent email />
    | Error(_) => <EmailPlaceholder />
    }}
  </div>
| None => <UserNotFound />
}}
```

The `@catch` directive is a powerful tool for building resilient UIs that gracefully handle partial failures while maintaining a good user experience.