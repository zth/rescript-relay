# Cache Invalidation with invalidateRecordsByIds

Cache invalidation is crucial for maintaining data consistency in your application. The `invalidateRecordsByIds` function allows you to selectively invalidate specific records in the Relay cache, triggering refetches for components that depend on that data.

## Overview

When you invalidate records, Relay will:
1. Mark the specified records as stale
2. Trigger refetches for any active queries that depend on those records
3. Update components that are subscribed to the invalidated data

This is particularly useful after mutations, background updates, or when you know certain data has become outdated.

## Basic Usage

```rescript
// Basic invalidation after a mutation
module UpdateUserMutation = %relay(`
  mutation UpdateUserMutation($userId: ID!, $input: UpdateUserInput!) {
    updateUser(userId: $userId, input: $input) {
      user {
        id
        name
        email
        profile {
          bio
          avatar
        }
      }
    }
  }
`)

let updateUser = async (userId, userData) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  try {
    let result = await UpdateUserMutation.commitMutation(
      ~environment,
      ~variables={userId, input: userData}
    )
    
    // Invalidate the user record to ensure fresh data
    RescriptRelay.Environment.invalidateRecordsByIds(
      environment,
      [userId]
    )
    
    Ok(result)
  } catch {
  | error => Error(error)
  }
}
```

## Strategic Invalidation Patterns

### 1. Single Record Invalidation

Invalidate a specific record after updating it:

```rescript
let updateProduct = async (productId, productData) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  let result = await UpdateProductMutation.commitMutation(
    ~environment,
    ~variables={productId, productData}
  )
  
  // Invalidate just this product
  RescriptRelay.Environment.invalidateRecordsByIds(
    environment,
    [productId]
  )
  
  result
}
```

### 2. Related Records Invalidation

Invalidate multiple related records:

```rescript
let addPostToUser = async (userId, postData) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  let result = await CreatePostMutation.commitMutation(
    ~environment,
    ~variables={userId, postData}
  )
  
  // Invalidate user and any post lists
  let relatedIds = [
    userId,                           // The user record
    "posts_" ++ userId,              // User's posts connection
    "recent_posts",                  // Global recent posts
    "featured_posts",                // Featured posts if applicable
  ]
  
  RescriptRelay.Environment.invalidateRecordsByIds(
    environment,
    relatedIds
  )
  
  result
}
```

### 3. Connection Invalidation

Invalidate connections when their contents change:

```rescript
module PostsQuery = %relay(`
  query PostsQuery($userId: ID!, $first: Int, $after: String) {
    user(id: $userId) {
      posts(first: $first, after: $after) @connection(key: "UserPosts_posts") {
        edges {
          node {
            id
            title
            content
          }
        }
      }
    }
  }
`)

let deletePost = async (postId, userId) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  await DeletePostMutation.commitMutation(
    ~environment,
    ~variables={postId}
  )
  
  // Invalidate the connection to trigger a refetch
  RescriptRelay.Environment.invalidateRecordsByIds(
    environment,
    [
      postId,                                    // The deleted post
      "client:root:user(" ++ userId ++ ")",     // User record
      "client:root:user(" ++ userId ++ "):posts", // Posts connection
    ]
  )
}
```

## Advanced Invalidation Strategies

### 1. Conditional Invalidation

Only invalidate when certain conditions are met:

```rescript
let updateUserProfile = async (userId, profileData, ~invalidateCache=true, ()) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  let result = await UpdateUserMutation.commitMutation(
    ~environment,
    ~variables={userId, profileData}
  )
  
  // Only invalidate if requested (useful for optimistic updates)
  if (invalidateCache) {
    let idsToInvalidate = [userId]
    
    // Add additional IDs based on what changed
    let additionalIds = switch profileData {
    | {avatar: Some(_)} => ["user_avatars_cache"]  // Avatar changed
    | {bio: Some(_)} => ["user_profiles_cache"]    // Bio changed
    | _ => []
    }
    
    RescriptRelay.Environment.invalidateRecordsByIds(
      environment,
      Array.concat(idsToInvalidate, additionalIds)
    )
  }
  
  result
}
```

### 2. Batch Invalidation

Invalidate multiple records efficiently:

```rescript
let bulkUpdateUsers = async (userUpdates) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  // Perform all mutations
  let results = await Promise.all(
    userUpdates->Array.map(({userId, data}) => 
      UpdateUserMutation.commitMutation(
        ~environment,
        ~variables={userId, input: data}
      )
    )
  )
  
  // Collect all affected IDs
  let affectedIds = userUpdates->Array.map(({userId}) => userId)
  let connectionIds = [
    "users_list",
    "active_users",
    "recent_users",
  ]
  
  // Single invalidation call for all affected records
  RescriptRelay.Environment.invalidateRecordsByIds(
    environment,
    Array.concat(affectedIds, connectionIds)
  )
  
  results
}
```

### 3. Time-based Invalidation

Invalidate records after a certain time period:

```rescript
let scheduleInvalidation = (recordIds, delay) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  Js.Global.setTimeout(() => {
    RescriptRelay.Environment.invalidateRecordsByIds(
      environment,
      recordIds
    )
  }, delay)->ignore
}

let fetchUserWithTTL = async (userId, ~ttl=300000, ()) => { // 5 minutes
  let result = await fetchUserData(userId)
  
  // Schedule invalidation of this user's cache
  scheduleInvalidation([userId], ttl)
  
  result
}
```

## Cache Key Patterns

Understanding how to construct cache keys for invalidation:

### 1. Simple Record IDs

For basic records, use the ID directly:

```rescript
// User with ID "123"
["123"]

// Multiple records
["123", "456", "789"]
```

### 2. Connection Keys

For connections, use the pattern Relay generates:

```rescript
// User's posts connection
let userPostsKey = "client:root:user(" ++ userId ++ "):posts"

// Global posts with filters
let filteredPostsKey = "client:root:posts({\"category\":\"tech\"})"

// Paginated connections
let paginatedKey = "client:root:posts({\"first\":10,\"after\":\"cursor123\"})"
```

### 3. Fragment Keys

For fragments, use the parent record + fragment name:

```rescript
// User profile fragment
let profileFragmentKey = userId ++ ":UserProfile_user"

// Product details fragment  
let productDetailsKey = productId ++ ":ProductDetails_product"
```

## Integration with Mutations

### 1. Optimistic Updates with Invalidation

```rescript
module LikePostMutation = %relay(`
  mutation LikePostMutation($postId: ID!) {
    likePost(postId: $postId) {
      post {
        id
        likesCount
        isLikedByViewer
      }
    }
  }
`)

let likePost = (postId, currentLikesCount) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  LikePostMutation.commitMutation(
    ~environment,
    ~variables={postId},
    ~optimisticResponse={
      likePost: {
        post: {
          id: postId,
          likesCount: currentLikesCount + 1,
          isLikedByViewer: true,
        }
      }
    },
    ~onCompleted=(response, errors) => {
      switch errors {
      | Some(_) => 
        // On error, invalidate to get fresh data
        RescriptRelay.Environment.invalidateRecordsByIds(
          environment,
          [postId]
        )
      | None => 
        // Success - optimistic update was correct, no need to invalidate
        ()
      }
    },
    ()
  )
}
```

### 2. Complex Mutation Invalidation

```rescript
module TransferOwnershipMutation = %relay(`
  mutation TransferOwnershipMutation($projectId: ID!, $newOwnerId: ID!) {
    transferOwnership(projectId: $projectId, newOwnerId: $newOwnerId) {
      project {
        id
        owner {
          id
          name
        }
      }
      previousOwner {
        id
        ownedProjects {
          totalCount
        }
      }
      newOwner {
        id
        ownedProjects {
          totalCount
        }
      }
    }
  }
`)

let transferProjectOwnership = async (projectId, newOwnerId, currentOwnerId) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  let result = await TransferOwnershipMutation.commitMutation(
    ~environment,
    ~variables={projectId, newOwnerId}
  )
  
  // Invalidate multiple affected entities
  let idsToInvalidate = [
    projectId,                                    // The project itself
    currentOwnerId,                              // Previous owner
    newOwnerId,                                  // New owner
    "projects_list",                             // Global projects list
    "client:root:user(" ++ currentOwnerId ++ "):ownedProjects", // Previous owner's projects
    "client:root:user(" ++ newOwnerId ++ "):ownedProjects",     // New owner's projects
  ]
  
  RescriptRelay.Environment.invalidateRecordsByIds(
    environment,
    idsToInvalidate
  )
  
  result
}
```

## Performance Considerations

### 1. Minimize Invalidation Scope

Only invalidate what's necessary:

```rescript
// Good: Specific invalidation
let updateUserName = async (userId, newName) => {
  await updateUser(userId, {name: newName})
  
  // Only invalidate the user record
  RescriptRelay.Environment.invalidateRecordsByIds(
    environment,
    [userId]
  )
}

// Avoid: Over-invalidation
let updateUserNameBad = async (userId, newName) => {
  await updateUser(userId, {name: newName})
  
  // Too broad - invalidates all users
  RescriptRelay.Environment.invalidateRecordsByIds(
    environment,
    ["users_list", "all_profiles", "active_users", "recent_users"]
  )
}
```

### 2. Debounce Invalidation

For rapid updates, debounce invalidation calls:

```rescript
let invalidationQueue = ref([])
let invalidationTimer = ref(None)

let queueInvalidation = (recordIds) => {
  invalidationQueue := Array.concat(invalidationQueue.contents, recordIds)
  
  // Clear existing timer
  switch invalidationTimer.contents {
  | Some(timerId) => Js.Global.clearTimeout(timerId)
  | None => ()
  }
  
  // Set new timer
  let timerId = Js.Global.setTimeout(() => {
    let environment = RescriptRelay.Environment.getCurrentEnvironment()
    let uniqueIds = Array.from(Set.fromArray(invalidationQueue.contents))
    
    RescriptRelay.Environment.invalidateRecordsByIds(environment, uniqueIds)
    
    invalidationQueue := []
    invalidationTimer := None
  }, 100) // 100ms debounce
  
  invalidationTimer := Some(timerId)
}

// Usage
let rapidUpdate = (recordId, data) => {
  // Update the record
  updateRecord(recordId, data)
  
  // Queue invalidation instead of immediate invalidation
  queueInvalidation([recordId])
}
```

### 3. Smart Invalidation Based on Usage

Track which records are actively being used:

```rescript
let activeSubscriptions = ref(Set.empty)

let trackRecordUsage = (recordId) => {
  activeSubscriptions := Set.add(activeSubscriptions.contents, recordId)
}

let untrackRecordUsage = (recordId) => {
  activeSubscriptions := Set.remove(activeSubscriptions.contents, recordId)
}

let smartInvalidation = (recordIds) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  // Only invalidate records that are actively being used
  let activeIds = recordIds->Array.filter(id => 
    Set.has(activeSubscriptions.contents, id)
  )
  
  if (Array.length(activeIds) > 0) {
    RescriptRelay.Environment.invalidateRecordsByIds(environment, activeIds)
  }
}
```

## Debugging Invalidation

### 1. Logging Invalidation

Add logging to track invalidation patterns:

```rescript
let logInvalidation = (recordIds, reason) => {
  if (Node.Process.env->Js.Dict.get("NODE_ENV") === Some("development")) {
    Console.log(`Invalidating ${Array.length(recordIds)} records: ${reason}`)
    Console.log("Record IDs:", recordIds)
  }
}

let invalidateWithLogging = (recordIds, reason) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  logInvalidation(recordIds, reason)
  
  RescriptRelay.Environment.invalidateRecordsByIds(environment, recordIds)
}

// Usage
invalidateWithLogging([userId], "User profile updated")
```

### 2. Invalidation Analytics

Track invalidation patterns for optimization:

```rescript
let invalidationStats = ref(Js.Dict.empty())

let trackInvalidation = (recordIds, reason) => {
  let stats = invalidationStats.contents
  
  recordIds->Array.forEach(id => {
    let currentCount = stats->Js.Dict.get(id)->Option.getWithDefault(0)
    stats->Js.Dict.set(id, currentCount + 1)
  })
  
  // Log frequently invalidated records
  if (Node.Process.env->Js.Dict.get("LOG_INVALIDATION_STATS") === Some("true")) {
    let sortedStats = stats
      ->Js.Dict.entries
      ->Array.sort(((_, a), (_, b)) => b - a)
      ->Array.slice(~start=0, ~end=10)
    
    Console.log("Top invalidated records:", sortedStats)
  }
}

let invalidateWithAnalytics = (recordIds, reason) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  trackInvalidation(recordIds, reason)
  RescriptRelay.Environment.invalidateRecordsByIds(environment, recordIds)
}
```

## Common Patterns

### 1. User Activity Invalidation

```rescript
let invalidateUserActivity = (userId) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  let activityRelatedIds = [
    userId,
    "user_feed_" ++ userId,
    "user_notifications_" ++ userId,
    "user_timeline_" ++ userId,
    "recent_activity",
  ]
  
  RescriptRelay.Environment.invalidateRecordsByIds(
    environment,
    activityRelatedIds
  )
}
```

### 2. Content Moderation Invalidation

```rescript
let handleContentModeration = (contentId, action) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  let idsToInvalidate = switch action {
  | `Approve => [
      contentId,
      "pending_content",
      "approved_content",
    ]
  | `Reject => [
      contentId,
      "pending_content", 
      "rejected_content",
    ]
  | `Flag => [
      contentId,
      "flagged_content",
    ]
  }
  
  RescriptRelay.Environment.invalidateRecordsByIds(
    environment,
    idsToInvalidate
  )
}
```

### 3. Real-time Update Invalidation

```rescript
// WebSocket or subscription update handler
let handleRealtimeUpdate = (update) => {
  let environment = RescriptRelay.Environment.getCurrentEnvironment()
  
  switch update {
  | {type: "USER_ONLINE", userId} => 
    RescriptRelay.Environment.invalidateRecordsByIds(
      environment,
      [userId, "online_users"]
    )
    
  | {type: "NEW_MESSAGE", chatId, senderId} => 
    RescriptRelay.Environment.invalidateRecordsByIds(
      environment,
      [chatId, senderId, "recent_chats"]
    )
    
  | {type: "NOTIFICATION", userId} => 
    RescriptRelay.Environment.invalidateRecordsByIds(
      environment,
      ["user_notifications_" ++ userId]
    )
  }
}
```

## Best Practices

1. **Be Specific**: Only invalidate records that have actually changed
2. **Group Related Changes**: Batch invalidations for related operations
3. **Consider Dependencies**: Think about what other data depends on changed records
4. **Monitor Performance**: Track invalidation frequency and impact
5. **Test Thoroughly**: Ensure invalidation doesn't cause excessive refetching
6. **Document Patterns**: Keep track of your invalidation strategies for maintainability

Cache invalidation with `invalidateRecordsByIds` is a powerful tool for maintaining data consistency while avoiding unnecessary network requests. Used strategically, it ensures your users always see fresh, accurate data.