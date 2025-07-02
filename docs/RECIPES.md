# RescriptRelay Recipes

This document contains recipes and patterns for common use cases in RescriptRelay, providing practical examples and best practices for real-world applications.

## Table of Contents

- [Error Handling Patterns](#error-handling-patterns)
- [Pagination Patterns](#pagination-patterns)
- [Cache Management](#cache-management)
- [Real-time Updates](#real-time-updates)
- [Form Handling](#form-handling)
- [Authentication Patterns](#authentication-patterns)
- [Performance Optimization](#performance-optimization)
- [Testing Patterns](#testing-patterns)

## Error Handling Patterns

### 1. Graceful Degradation with @catch

```rescript
module UserProfileQuery = %relay(`
  query UserProfileQuery($userId: ID!) {
    user(id: $userId) {
      id
      name
      email @catch
      avatar @catch
      socialLinks @catch {
        platform
        url
      }
      posts @catch {
        totalCount
      }
    }
  }
`)

@react.component
let make = (~userId) => {
  let data = UserProfileQuery.use(~variables={userId}, ())
  
  switch data.user {
  | Some(user) =>
    <div className="user-profile">
      <h1>{React.string(user.name)}</h1>
      
      {/* Email with privacy fallback */}
      {switch user.email {
      | Ok(email) => 
        <p className="email">
          <Icon name="mail" />
          {React.string(email)}
        </p>
      | Error(_) => 
        <p className="email-private">
          <Icon name="lock" />
          {React.string("Email hidden for privacy")}
        </p>
      }}
      
      {/* Avatar with default fallback */}
      {switch user.avatar {
      | Ok(avatarUrl) => 
        <img src=avatarUrl alt="Profile" className="avatar" />
      | Error(_) => 
        <div className="avatar-default">
          {React.string(String.get(user.name, 0)->String.make(1))}
        </div>
      }}
      
      {/* Social links section */}
      <div className="social-section">
        <h3>{React.string("Social Links")}</h3>
        {switch user.socialLinks {
        | Ok(links) => 
          <div className="social-links">
            {links->Array.map(link => 
              <a key={link.platform} href={link.url} target="_blank">
                <Icon name={link.platform} />
                {React.string(link.platform)}
              </a>
            )->React.array}
          </div>
        | Error(_) => 
          <p className="social-unavailable">
            {React.string("Social links not available")}
          </p>
        }}
      </div>
      
      {/* Posts count */}
      <div className="posts-section">
        {switch user.posts {
        | Ok(posts) => 
          <p>{React.string(`${Int.toString(posts.totalCount)} posts`)}</p>
        | Error(_) => 
          <p>{React.string("Post count unavailable")}</p>
        }}
      </div>
    </div>
  | None => <UserNotFound />
  }
}
```

### 2. Global Error Boundary

```rescript
module ErrorBoundary = {
  type state = {hasError: bool, error: option<Js.Exn.t>}
  type action = SetError(Js.Exn.t) | ClearError
  
  let reducer = (state, action) => {
    switch action {
    | SetError(error) => {hasError: true, error: Some(error)}
    | ClearError => {hasError: false, error: None}
    }
  }
  
  @react.component
  let make = (~children, ~fallback=?) => {
    let (state, dispatch) = React.useReducer(reducer, {hasError: false, error: None})
    
    React.useEffect(() => {
      let handleError = (error) => {
        Console.error("GraphQL Error:", error)
        dispatch(SetError(error))
      }
      
      // Listen for unhandled GraphQL errors
      RescriptRelay.Environment.addEventListener("error", handleError)
      Some(() => RescriptRelay.Environment.removeEventListener("error", handleError))
    }, [])
    
    if (state.hasError) {
      switch fallback {
      | Some(fallbackComponent) => fallbackComponent
      | None => 
        <div className="error-boundary">
          <h2>{React.string("Something went wrong")}</h2>
          <button onClick={_ => dispatch(ClearError)}>
            {React.string("Try Again")}
          </button>
        </div>
      }
    } else {
      children
    }
  }
}
```

## Pagination Patterns

### 1. Infinite Scroll with Prefetching

```rescript
module PostsInfiniteQuery = %relay(`
  query PostsInfiniteQuery($first: Int, $after: String) {
    posts(first: $first, after: $after) @connection(key: "PostsInfinite_posts") {
      edges {
        node {
          id
          title
          excerpt
          author {
            name
            avatar
          }
          createdAt
        }
      }
      pageInfo {
        hasNextPage
        endCursor
      }
    }
  }
`)

@react.component
let make = () => {
  let {data, loadNext, hasNext, isLoadingNext, prefetchNext} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(PostsInfiniteQuery),
      ~variables={first: 10, after: None},
    )
  
  let sentinelRef = React.useRef(Js.Nullable.null)
  
  // Intersection Observer for infinite scroll
  React.useEffect(() => {
    let current = sentinelRef.current->Js.Nullable.toOption
    
    switch current {
    | Some(element) =>
      let observer = IntersectionObserver.make((entries, _) => {
        entries->Array.forEach(entry => {
          if (entry->IntersectionObserver.Entry.isIntersecting) {
            if (hasNext && !isLoadingNext) {
              loadNext(~count=10, ())
            }
          }
          
          // Prefetch when approaching the end
          if (entry->IntersectionObserver.Entry.intersectionRatio > 0.5 && hasNext) {
            prefetchNext(~count=10, ())
          }
        })
      }, {threshold: [0.1, 0.5, 1.0]})
      
      observer->IntersectionObserver.observe(element)
      Some(() => observer->IntersectionObserver.disconnect())
    | None => None
    }
  }, [hasNext, isLoadingNext])

  <div className="posts-container">
    <h1>{React.string("Latest Posts")}</h1>
    
    <div className="posts-list">
      {data.posts.edges
      ->Array.map(edge => 
        <article key={edge.node.id} className="post-card">
          <div className="post-header">
            <img 
              src={edge.node.author.avatar}
              alt={edge.node.author.name}
              className="author-avatar"
            />
            <div>
              <h3>{React.string(edge.node.title)}</h3>
              <p className="author">{React.string("By " ++ edge.node.author.name)}</p>
            </div>
          </div>
          <p className="excerpt">{React.string(edge.node.excerpt)}</p>
          <time className="date">
            {React.string(formatDate(edge.node.createdAt))}
          </time>
        </article>
      )
      ->React.array}
    </div>
    
    {/* Invisible sentinel for intersection observer */}
    <div ref={ReactDOM.Ref.domRef(sentinelRef)} className="scroll-sentinel" />
    
    {isLoadingNext && 
      <div className="loading-more">
        <Spinner />
        <span>{React.string("Loading more posts...")}</span>
      </div>
    }
    
    {!hasNext && Array.length(data.posts.edges) > 0 &&
      <p className="end-message">
        {React.string("You've reached the end!")}
      </p>
    }
  </div>
}
```

### 2. Paginated Table with Search

```rescript
module UsersTableQuery = %relay(`
  query UsersTableQuery(
    $first: Int, 
    $after: String, 
    $search: String,
    $sortBy: UserSort
  ) {
    users(
      first: $first, 
      after: $after, 
      search: $search,
      sortBy: $sortBy
    ) @connection(key: "UsersTable_users") {
      totalCount
      edges {
        node {
          id
          name
          email
          role
          createdAt
          isActive
        }
      }
      pageInfo {
        hasNextPage
        hasPreviousPage
        startCursor
        endCursor
      }
    }
  }
`)

@react.component
let make = () => {
  let (search, setSearch) = React.useState(() => "")
  let (sortBy, setSortBy) = React.useState(() => `NAME_ASC)
  let (debouncedSearch, setDebouncedSearch) = React.useState(() => "")
  
  // Debounce search input
  React.useEffect(() => {
    let timer = Js.Global.setTimeout(() => {
      setDebouncedSearch(_ => search)
    }, 300)
    
    Some(() => Js.Global.clearTimeout(timer))
  }, [search])
  
  let {data, loadNext, loadPrevious, hasNext, hasPrevious, refetch} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(UsersTableQuery),
      ~variables={
        first: 20, 
        after: None, 
        search: debouncedSearch,
        sortBy
      },
    )
  
  // Refetch when search or sort changes
  React.useEffect(() => {
    refetch()
  }, [debouncedSearch, sortBy])

  <div className="users-table-container">
    <div className="table-controls">
      <div className="search-box">
        <input
          type_="text"
          placeholder="Search users..."
          value={search}
          onChange={e => setSearch(_ => ReactEvent.Form.target(e)["value"])}
        />
        <Icon name="search" />
      </div>
      
      <select 
        value={sortByToString(sortBy)}
        onChange={e => {
          let value = ReactEvent.Form.target(e)["value"]
          setSortBy(_ => sortByFromString(value))
        }}
      >
        <option value="NAME_ASC">{React.string("Name A-Z")}</option>
        <option value="NAME_DESC">{React.string("Name Z-A")}</option>
        <option value="CREATED_DESC">{React.string("Newest First")}</option>
        <option value="CREATED_ASC">{React.string("Oldest First")}</option>
      </select>
    </div>
    
    <div className="table-info">
      <p>{React.string(`${Int.toString(data.users.totalCount)} total users`)}</p>
    </div>
    
    <table className="users-table">
      <thead>
        <tr>
          <th>{React.string("Name")}</th>
          <th>{React.string("Email")}</th>
          <th>{React.string("Role")}</th>
          <th>{React.string("Status")}</th>
          <th>{React.string("Joined")}</th>
          <th>{React.string("Actions")}</th>
        </tr>
      </thead>
      <tbody>
        {data.users.edges
        ->Array.map(edge => 
          <tr key={edge.node.id}>
            <td>{React.string(edge.node.name)}</td>
            <td>{React.string(edge.node.email)}</td>
            <td>
              <span className={`role role-${String.toLowerCase(edge.node.role)}`}>
                {React.string(edge.node.role)}
              </span>
            </td>
            <td>
              <span className={`status ${edge.node.isActive ? "active" : "inactive"}`}>
                {React.string(edge.node.isActive ? "Active" : "Inactive")}
              </span>
            </td>
            <td>{React.string(formatDate(edge.node.createdAt))}</td>
            <td>
              <button className="btn-edit">
                {React.string("Edit")}
              </button>
            </td>
          </tr>
        )
        ->React.array}
      </tbody>
    </table>
    
    <div className="pagination-controls">
      <button 
        disabled={!hasPrevious}
        onClick={_ => loadPrevious(~count=20, ())}
      >
        {React.string("Previous")}
      </button>
      
      <button 
        disabled={!hasNext}
        onClick={_ => loadNext(~count=20, ())}
      >
        {React.string("Next")}
      </button>
    </div>
  </div>
}
```

## Cache Management

### 1. Smart Cache Invalidation

```rescript
// CacheManager.res
module CacheManager = {
  type invalidationStrategy = 
    | Immediate
    | Debounced(int)
    | Scheduled(float)
  
  let invalidationQueue = ref([])
  let invalidationTimer = ref(None)
  
  let invalidateRecords = (recordIds, ~strategy=Immediate, ()) => {
    let environment = RescriptRelay.Environment.getCurrentEnvironment()
    
    switch strategy {
    | Immediate => 
      RescriptRelay.Environment.invalidateRecordsByIds(environment, recordIds)
      
    | Debounced(delay) => 
      invalidationQueue := Array.concat(invalidationQueue.contents, recordIds)
      
      // Clear existing timer
      switch invalidationTimer.contents {
      | Some(timerId) => Js.Global.clearTimeout(timerId)
      | None => ()
      }
      
      // Set new timer
      let timerId = Js.Global.setTimeout(() => {
        let uniqueIds = Array.from(Set.fromArray(invalidationQueue.contents))
        RescriptRelay.Environment.invalidateRecordsByIds(environment, uniqueIds)
        invalidationQueue := []
        invalidationTimer := None
      }, delay)
      
      invalidationTimer := Some(timerId)
      
    | Scheduled(timestamp) => 
      let delay = timestamp -. Js.Date.now()
      if (delay > 0.0) {
        Js.Global.setTimeout(() => {
          RescriptRelay.Environment.invalidateRecordsByIds(environment, recordIds)
        }, Float.toInt(delay))->ignore
      } else {
        RescriptRelay.Environment.invalidateRecordsByIds(environment, recordIds)
      }
    }
  }
  
  let invalidateUserData = (userId) => {
    let relatedIds = [
      userId,
      "user_posts_" ++ userId,
      "user_followers_" ++ userId,
      "user_following_" ++ userId,
      "user_notifications_" ++ userId,
    ]
    
    invalidateRecords(relatedIds, ~strategy=Debounced(100), ())
  }
  
  let invalidateContentData = (contentId, contentType) => {
    let baseIds = [contentId]
    let listIds = switch contentType {
    | "post" => ["recent_posts", "featured_posts", "trending_posts"]
    | "comment" => ["recent_comments"]
    | "product" => ["featured_products", "new_products"]
    | _ => []
    }
    
    invalidateRecords(Array.concat(baseIds, listIds), ())
  }
}
```

### 2. Cache Warming

```rescript
module CacheWarmer = {
  let warmUserProfile = async (userId) => {
    let environment = RescriptRelay.Environment.getCurrentEnvironment()
    
    // Prefetch user data and related information
    let userPromise = RescriptRelay.Environment.fetchQuery(
      environment,
      UserProfileQuery.query,
      {userId}
    )
    
    let postsPromise = RescriptRelay.Environment.fetchQuery(
      environment,
      UserPostsQuery.query,
      {userId, first: 5}
    )
    
    let followersPromise = RescriptRelay.Environment.fetchQuery(
      environment,
      UserFollowersQuery.query,
      {userId, first: 10}
    )
    
    try {
      let _ = await Promise.all([userPromise, postsPromise, followersPromise])
      Console.log("Cache warmed for user: " ++ userId)
    } catch {
    | error => Console.warn("Failed to warm cache for user: " ++ userId, error)
    }
  }
  
  let warmHomePage = async () => {
    let environment = RescriptRelay.Environment.getCurrentEnvironment()
    
    // Prefetch critical homepage data
    let promises = [
      RescriptRelay.Environment.fetchQuery(
        environment,
        FeaturedPostsQuery.query,
        {first: 5}
      ),
      RescriptRelay.Environment.fetchQuery(
        environment,
        TrendingTopicsQuery.query,
        {limit: 10}
      ),
      RescriptRelay.Environment.fetchQuery(
        environment,
        RecentActivityQuery.query,
        {first: 20}
      ),
    ]
    
    try {
      let _ = await Promise.all(promises)
      Console.log("Homepage cache warmed")
    } catch {
    | error => Console.warn("Failed to warm homepage cache", error)
    }
  }
}
```

## Real-time Updates

### 1. WebSocket Integration

```rescript
module RealtimeUpdates = {
  type updateType = 
    | UserOnline(string)
    | UserOffline(string)
    | NewMessage({chatId: string, senderId: string})
    | PostLiked({postId: string, userId: string})
    | CommentAdded({postId: string, commentId: string})
  
  let socket = ref(None)
  
  let connect = () => {
    let ws = WebSocket.make("wss://api.example.com/realtime")
    socket := Some(ws)
    
    ws->WebSocket.addEventListener("message", event => {
      let data = event.data->Js.Json.parseExn
      handleRealtimeUpdate(data)
    })
    
    ws->WebSocket.addEventListener("close", _ => {
      Console.log("WebSocket disconnected, attempting to reconnect...")
      Js.Global.setTimeout(() => connect(), 5000)->ignore
    })
  }
  
  let handleRealtimeUpdate = (data) => {
    let environment = RescriptRelay.Environment.getCurrentEnvironment()
    
    switch parseUpdateType(data) {
    | UserOnline(userId) => 
      // Update user status in cache
      RescriptRelay.Environment.commitUpdate(environment, store => {
        let userRecord = store->RescriptRelay.RecordSourceSelectorProxy.get(userId)
        switch userRecord {
        | Some(record) => 
          record->RescriptRelay.RecordProxy.setValue("isOnline", true)
        | None => ()
        }
      })
      
      // Invalidate online users list
      CacheManager.invalidateRecords(["online_users"], ())
      
    | NewMessage({chatId, senderId}) => 
      // Invalidate chat and update unread count
      CacheManager.invalidateRecords([
        chatId,
        "user_chats_" ++ getCurrentUserId(),
        "chat_messages_" ++ chatId
      ], ())
      
      // Show notification
      showNotification("New message received")
      
    | PostLiked({postId, userId}) => 
      // Optimistically update like count
      RescriptRelay.Environment.commitUpdate(environment, store => {
        let postRecord = store->RescriptRelay.RecordSourceSelectorProxy.get(postId)
        switch postRecord {
        | Some(record) => 
          let currentLikes = record->RescriptRelay.RecordProxy.getValue("likesCount")
          switch currentLikes {
          | Some(count) => 
            record->RescriptRelay.RecordProxy.setValue("likesCount", count + 1)
          | None => ()
          }
        | None => ()
        }
      })
      
    | _ => ()
    }
  }
  
  let disconnect = () => {
    switch socket.contents {
    | Some(ws) => 
      ws->WebSocket.close()
      socket := None
    | None => ()
    }
  }
}
```

### 2. Optimistic Updates with Rollback

```rescript
module OptimisticUpdates = {
  type optimisticUpdate<'t> = {
    id: string,
    originalData: 't,
    optimisticData: 't,
    rollbackFn: unit => unit,
  }
  
  let activeUpdates = ref(Map.empty)
  
  let createOptimisticUpdate = (id, originalData, optimisticData, rollbackFn) => {
    let update = {id, originalData, optimisticData, rollbackFn}
    activeUpdates := activeUpdates.contents->Map.set(id, update)
    update
  }
  
  let commitOptimisticUpdate = (updateId) => {
    activeUpdates := activeUpdates.contents->Map.remove(updateId)
  }
  
  let rollbackOptimisticUpdate = (updateId) => {
    switch activeUpdates.contents->Map.get(updateId) {
    | Some(update) => 
      update.rollbackFn()
      activeUpdates := activeUpdates.contents->Map.remove(updateId)
    | None => ()
    }
  }
  
  let likePost = (postId, currentLikesCount, isLiked) => {
    let environment = RescriptRelay.Environment.getCurrentEnvironment()
    let updateId = "like_post_" ++ postId
    
    // Create rollback function
    let rollback = () => {
      RescriptRelay.Environment.commitUpdate(environment, store => {
        let postRecord = store->RescriptRelay.RecordSourceSelectorProxy.get(postId)
        switch postRecord {
        | Some(record) => 
          record->RescriptRelay.RecordProxy.setValue("likesCount", currentLikesCount)
          record->RescriptRelay.RecordProxy.setValue("isLikedByViewer", isLiked)
        | None => ()
        }
      })
    }
    
    // Apply optimistic update
    RescriptRelay.Environment.commitUpdate(environment, store => {
      let postRecord = store->RescriptRelay.RecordSourceSelectorProxy.get(postId)
      switch postRecord {
      | Some(record) => 
        record->RescriptRelay.RecordProxy.setValue(
          "likesCount", 
          isLiked ? currentLikesCount - 1 : currentLikesCount + 1
        )
        record->RescriptRelay.RecordProxy.setValue("isLikedByViewer", !isLiked)
      | None => ()
      }
    })
    
    let optimisticUpdate = createOptimisticUpdate(
      updateId,
      {likesCount: currentLikesCount, isLiked},
      {likesCount: isLiked ? currentLikesCount - 1 : currentLikesCount + 1, isLiked: !isLiked},
      rollback
    )
    
    // Commit actual mutation
    LikePostMutation.commitMutation(
      ~environment,
      ~variables={postId},
      ~onCompleted=(response, errors) => {
        switch errors {
        | Some(_) => rollbackOptimisticUpdate(updateId)
        | None => commitOptimisticUpdate(updateId)
        }
      },
      ~onError=(_error) => {
        rollbackOptimisticUpdate(updateId)
      },
      ()
    )
  }
}
```

## Form Handling

### 1. Mutation-based Forms

```rescript
module UserProfileForm = {
  module UpdateUserMutation = %relay(`
    mutation UserProfileFormUpdateUserMutation($input: UpdateUserInput!) {
      updateUser(input: $input) {
        user {
          id
          name
          email
          bio
          avatar
        }
        errors {
          field
          message
        }
      }
    }
  `)
  
  type formData = {
    name: string,
    email: string,
    bio: string,
    avatar: option<string>,
  }
  
  type formErrors = Js.Dict.t<string>
  
  @react.component
  let make = (~userId, ~initialData) => {
    let (formData, setFormData) = React.useState(() => initialData)
    let (errors, setErrors) = React.useState(() => Js.Dict.empty())
    let (isSubmitting, setIsSubmitting) = React.useState(() => false)
    let (isDirty, setIsDirty) = React.useState(() => false)
    
    let updateField = (field, value) => {
      setFormData(prev => {
        switch field {
        | "name" => {...prev, name: value}
        | "email" => {...prev, email: value}
        | "bio" => {...prev, bio: value}
        | _ => prev
        }
      })
      setIsDirty(_ => true)
      
      // Clear field error when user starts typing
      if (errors->Js.Dict.get(field)->Option.isSome) {
        setErrors(prev => {
          let newErrors = Js.Dict.fromArray(prev->Js.Dict.entries)
          newErrors->Js.Dict.set(field, "")
          newErrors
        })
      }
    }
    
    let validateForm = () => {
      let newErrors = Js.Dict.empty()
      
      if (String.length(formData.name) === 0) {
        newErrors->Js.Dict.set("name", "Name is required")
      }
      
      if (String.length(formData.email) === 0) {
        newErrors->Js.Dict.set("email", "Email is required")
      } else if (!isValidEmail(formData.email)) {
        newErrors->Js.Dict.set("email", "Invalid email format")
      }
      
      if (String.length(formData.bio) > 500) {
        newErrors->Js.Dict.set("bio", "Bio must be less than 500 characters")
      }
      
      setErrors(_ => newErrors)
      Js.Dict.keys(newErrors)->Array.length === 0
    }
    
    let handleSubmit = (event) => {
      ReactEvent.Form.preventDefault(event)
      
      if (validateForm()) {
        setIsSubmitting(_ => true)
        
        UpdateUserMutation.commitMutation(
          ~environment=RescriptRelay.Environment.getCurrentEnvironment(),
          ~variables={
            input: {
              userId,
              name: formData.name,
              email: formData.email,
              bio: formData.bio,
              avatar: formData.avatar,
            }
          },
          ~onCompleted=(response, _errors) => {
            switch response.updateUser.errors {
            | [] => 
              setIsSubmitting(_ => false)
              setIsDirty(_ => false)
              showSuccessMessage("Profile updated successfully")
            | serverErrors => 
              let errorDict = Js.Dict.empty()
              serverErrors->Array.forEach(error => {
                errorDict->Js.Dict.set(error.field, error.message)
              })
              setErrors(_ => errorDict)
              setIsSubmitting(_ => false)
            }
          },
          ~onError=(error) => {
            setIsSubmitting(_ => false)
            showErrorMessage("Failed to update profile")
            Console.error(error)
          },
          ()
        )
      }
    }
    
    <form onSubmit={handleSubmit} className="profile-form">
      <div className="form-group">
        <label htmlFor="name">{React.string("Name")}</label>
        <input
          id="name"
          type_="text"
          value={formData.name}
          onChange={e => updateField("name", ReactEvent.Form.target(e)["value"])}
          className={errors->Js.Dict.get("name")->Option.isSome ? "error" : ""}
        />
        {switch errors->Js.Dict.get("name") {
        | Some(error) when String.length(error) > 0 => 
          <span className="error-message">{React.string(error)}</span>
        | _ => React.null
        }}
      </div>
      
      <div className="form-group">
        <label htmlFor="email">{React.string("Email")}</label>
        <input
          id="email"
          type_="email"
          value={formData.email}
          onChange={e => updateField("email", ReactEvent.Form.target(e)["value"])}
          className={errors->Js.Dict.get("email")->Option.isSome ? "error" : ""}
        />
        {switch errors->Js.Dict.get("email") {
        | Some(error) when String.length(error) > 0 => 
          <span className="error-message">{React.string(error)}</span>
        | _ => React.null
        }}
      </div>
      
      <div className="form-group">
        <label htmlFor="bio">{React.string("Bio")}</label>
        <textarea
          id="bio"
          value={formData.bio}
          onChange={e => updateField("bio", ReactEvent.Form.target(e)["value"])}
          placeholder="Tell us about yourself..."
          rows={4}
          className={errors->Js.Dict.get("bio")->Option.isSome ? "error" : ""}
        />
        <small className="char-count">
          {React.string(`${String.length(formData.bio)}/500`)}
        </small>
        {switch errors->Js.Dict.get("bio") {
        | Some(error) when String.length(error) > 0 => 
          <span className="error-message">{React.string(error)}</span>
        | _ => React.null
        }}
      </div>
      
      <div className="form-actions">
        <button 
          type_="submit" 
          disabled={isSubmitting || !isDirty}
          className="btn-primary"
        >
          {React.string(isSubmitting ? "Saving..." : "Save Changes")}
        </button>
        
        {isDirty && 
          <button 
            type_="button"
            onClick={_ => {
              setFormData(_ => initialData)
              setIsDirty(_ => false)
              setErrors(_ => Js.Dict.empty())
            }}
            className="btn-secondary"
          >
            {React.string("Cancel")}
          </button>
        }
      </div>
    </form>
  }
}
```

## Authentication Patterns

### 1. Protected Routes

```rescript
module AuthProvider = {
  type authState = {
    isAuthenticated: bool,
    user: option<user>,
    loading: bool,
  }
  
  type authAction = 
    | SetLoading(bool)
    | SetUser(option<user>)
    | Logout
  
  let authContext = React.createContext((
    {isAuthenticated: false, user: None, loading: true},
    (_: authAction) => ()
  ))
  
  let reducer = (state, action) => {
    switch action {
    | SetLoading(loading) => {...state, loading}
    | SetUser(user) => {
        isAuthenticated: user->Option.isSome,
        user,
        loading: false
      }
    | Logout => {
        isAuthenticated: false,
        user: None,
        loading: false
      }
    }
  }
  
  @react.component
  let make = (~children) => {
    let (state, dispatch) = React.useReducer(reducer, {
      isAuthenticated: false,
      user: None,
      loading: true
    })
    
    // Check authentication on mount
    React.useEffect(() => {
      let checkAuth = async () => {
        try {
          let token = getStoredToken()
          switch token {
          | Some(authToken) => 
            setAuthHeader(authToken)
            let user = await fetchCurrentUser()
            dispatch(SetUser(Some(user)))
          | None => 
            dispatch(SetUser(None))
          }
        } catch {
        | _ => dispatch(SetUser(None))
        }
      }
      
      checkAuth()->ignore
    }, [])
    
    let contextValue = (state, dispatch)
    
    <authContext.Provider value={contextValue}>
      {children}
    </authContext.Provider>
  }
  
  let useAuth = () => React.useContext(authContext)
}

module ProtectedRoute = {
  @react.component
  let make = (~children, ~fallback=?, ~requiredRole=?) => {
    let (authState, _) = AuthProvider.useAuth()
    
    if (authState.loading) {
      <div className="loading-spinner">
        <Spinner />
        <p>{React.string("Checking authentication...")}</p>
      </div>
    } else if (!authState.isAuthenticated) {
      switch fallback {
      | Some(fallbackComponent) => fallbackComponent
      | None => <LoginForm />
      }
    } else {
      switch (requiredRole, authState.user) {
      | (Some(role), Some(user)) when hasRole(user, role) => children
      | (Some(_), _) => <AccessDenied />
      | (None, _) => children
      }
    }
  }
}
```

## Performance Optimization

### 1. Query Batching

```rescript
module QueryBatcher = {
  type batchedQuery = {
    query: RescriptRelay.Query.t,
    variables: Js.Json.t,
    resolve: Js.Json.t => unit,
    reject: Js.Exn.t => unit,
  }
  
  let queryQueue = ref([])
  let batchTimer = ref(None)
  let batchDelay = 10 // milliseconds
  
  let addToBatch = (query, variables) => {
    Promise.make((~resolve, ~reject) => {
      let batchedQuery = {query, variables, resolve, reject}
      queryQueue := Array.concat(queryQueue.contents, [batchedQuery])
      
      // Schedule batch execution if not already scheduled
      switch batchTimer.contents {
      | None => 
        let timerId = Js.Global.setTimeout(() => {
          executeBatch()
          batchTimer := None
        }, batchDelay)
        batchTimer := Some(timerId)
      | Some(_) => () // Already scheduled
      }
    })
  }
  
  let executeBatch = () => {
    let currentBatch = queryQueue.contents
    queryQueue := []
    
    if (Array.length(currentBatch) > 0) {
      let environment = RescriptRelay.Environment.getCurrentEnvironment()
      
      // Group queries by operation name for potential optimization
      let groupedQueries = currentBatch->Array.groupBy(q => q.query.name)
      
      groupedQueries->Map.forEach((queries, _operationName) => {
        // For now, execute each query individually
        // In a real implementation, you might batch identical queries
        queries->Array.forEach(batchedQuery => {
          RescriptRelay.Environment.fetchQuery(
            environment,
            batchedQuery.query,
            batchedQuery.variables
          )
          ->Promise.then(result => {
            batchedQuery.resolve(result)
            Promise.resolve()
          })
          ->Promise.catch(error => {
            batchedQuery.reject(error)
            Promise.resolve()
          })
          ->ignore
        })
      })
    }
  }
}
```

### 2. Component-level Caching

```rescript
module CachedComponent = {
  let componentCache = ref(Map.empty)
  let cacheSize = 100 // Maximum number of cached components
  
  let getCacheKey = (componentName, props) => {
    componentName ++ "_" ++ Js.Json.stringify(props)
  }
  
  let getCachedComponent = (componentName, props) => {
    let key = getCacheKey(componentName, props)
    componentCache.contents->Map.get(key)
  }
  
  let setCachedComponent = (componentName, props, element) => {
    let key = getCacheKey(componentName, props)
    
    // Implement LRU eviction if cache is full
    if (Map.size(componentCache.contents) >= cacheSize) {
      let oldestKey = componentCache.contents->Map.keys->Array.get(0)
      switch oldestKey {
      | Some(key) => 
        componentCache := componentCache.contents->Map.remove(key)
      | None => ()
      }
    }
    
    componentCache := componentCache.contents->Map.set(key, element)
  }
  
  @react.component
  let make = (~componentName, ~props, ~children) => {
    switch getCachedComponent(componentName, props) {
    | Some(cachedElement) => cachedElement
    | None => 
      let element = children()
      setCachedComponent(componentName, props, element)
      element
    }
  }
}
```

## Testing Patterns

### 1. Mock Environment for Testing

```rescript
module TestUtils = {
  let createMockEnvironment = (~mockResolvers=Map.empty, ()) => {
    let network = RescriptRelay.Network.makePromiseBased(
      ~fetchFunction=(operation, variables, _cacheConfig) => {
        switch mockResolvers->Map.get(operation.name) {
        | Some(resolver) => Promise.resolve(resolver(variables))
        | None => Promise.reject(Js.Exn.raiseError("Unmocked operation: " ++ operation.name))
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
  
  let renderWithRelay = (component, ~mockResolvers=Map.empty, ()) => {
    let environment = createMockEnvironment(~mockResolvers, ())
    
    ReactTestingLibrary.render(
      <RescriptRelay.Context.Provider environment>
        {component}
      </RescriptRelay.Context.Provider>
    )
  }
}

// Example test
let testUserProfile = () => {
  open Jest
  open Expect
  
  let mockResolvers = Map.fromArray([
    ("UserProfileQuery", (variables) => {
      {
        "user": {
          "id": variables->Js.Dict.get("userId")->Option.getWithDefault("1"),
          "name": "Test User",
          "email": "test@example.com",
          "avatar": "https://example.com/avatar.jpg"
        }
      }
    })
  ])
  
  test("renders user profile", () => {
    let {getByText} = TestUtils.renderWithRelay(
      <UserProfile userId="1" />,
      ~mockResolvers,
      ()
    )
    
    expect(getByText("Test User"))->toBeTruthy()
    expect(getByText("test@example.com"))->toBeTruthy()
  })
}
```

These recipes provide practical, real-world patterns for building robust applications with RescriptRelay. Each pattern can be adapted and extended based on your specific requirements and use cases.