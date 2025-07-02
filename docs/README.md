# RescriptRelay Documentation

This directory contains comprehensive documentation for advanced RescriptRelay features and patterns, addressing key areas that were missing from the official documentation.

## Quick Reference

| Topic | Description | GitHub Issue |
|-------|-------------|--------------|
| [Recipes](./RECIPES.md) | Common patterns and real-world examples | [#560](https://github.com/zth/rescript-relay/issues/560) |
| [Prefetchable Pagination](./PREFETCHABLE_PAGINATION.md) | Advanced pagination with prefetching | [#552](https://github.com/zth/rescript-relay/issues/552) |
| [@catch Directive](./CATCH_DIRECTIVE.md) | Field-level error handling | [#550](https://github.com/zth/rescript-relay/issues/550) |
| [Non-React Mode](./NON_REACT_MODE.md) | Server-side and Node.js usage | [#548](https://github.com/zth/rescript-relay/issues/548) |
| [Cache Invalidation](./CACHE_INVALIDATION.md) | Smart cache management strategies | [#528](https://github.com/zth/rescript-relay/issues/528) |
| [Field Handlers](./FIELD_HANDLERS.md) | Custom field processing and transformation | [#526](https://github.com/zth/rescript-relay/issues/526) |
| [Persisted Queries](./PERSISTED_QUERIES.md) | Query optimization and security | [#524](https://github.com/zth/rescript-relay/issues/524) |

## Getting Started

If you're new to RescriptRelay, start with the [official documentation](https://rescript-relay-documentation.vercel.app/docs/getting-started). Then explore these guides based on your needs:

### For Error Handling
- **Start with**: [@catch Directive](./CATCH_DIRECTIVE.md) for field-level error handling
- **Then see**: Error handling patterns in [Recipes](./RECIPES.md#error-handling-patterns)

### For Performance
- **Start with**: [Prefetchable Pagination](./PREFETCHABLE_PAGINATION.md) for smooth user experiences
- **Then explore**: [Cache Invalidation](./CACHE_INVALIDATION.md) and [Persisted Queries](./PERSISTED_QUERIES.md)
- **Advanced**: Performance patterns in [Recipes](./RECIPES.md#performance-optimization)

### For Server-Side Usage
- **Start with**: [Non-React Mode](./NON_REACT_MODE.md) for server-side rendering and API endpoints
- **Then see**: Testing patterns in [Recipes](./RECIPES.md#testing-patterns)

### For Advanced Customization
- **Start with**: [Field Handlers](./FIELD_HANDLERS.md) for custom data processing
- **Then explore**: Cache management in [Recipes](./RECIPES.md#cache-management)

## Key Features Covered

### Error Handling
- **@catch Directive**: Handle GraphQL errors at the field level
- **Graceful Degradation**: Show meaningful fallbacks when data is unavailable
- **Error Boundaries**: Global error handling strategies
- **Retry Logic**: Automatic retry mechanisms for transient failures

### Pagination
- **usePrefetchableForwardPagination**: Advanced pagination with prefetching
- **Infinite Scroll**: Smooth infinite scrolling implementations
- **Search & Filtering**: Combine pagination with dynamic filtering
- **Performance**: Optimized loading strategies

### Cache Management
- **Smart Invalidation**: Strategic cache invalidation patterns
- **Debounced Updates**: Batch invalidation for better performance
- **Connection Management**: Handle Relay connections efficiently
- **Cache Warming**: Preload critical data

### Real-time Features
- **WebSocket Integration**: Real-time updates with cache synchronization
- **Optimistic Updates**: Immediate UI feedback with rollback capabilities
- **Live Data**: Keep data fresh with minimal network overhead

### Advanced Patterns
- **Field Handlers**: Transform and validate data at the cache level
- **Persisted Queries**: Optimize bundle size and improve security
- **Non-React Usage**: Use RescriptRelay in server-side environments
- **Authentication**: Protected routes and role-based access

## Common Use Cases

### E-commerce Applications
```rescript
// Product listing with smart pagination
// See: PREFETCHABLE_PAGINATION.md
let {data, loadNext, prefetchNext} = usePrefetchableForwardPagination(...)

// Price formatting with field handlers  
// See: FIELD_HANDLERS.md
let currencyHandler = (value, args) => formatCurrency(value, args)

// Optimistic cart updates
// See: RECIPES.md#real-time-updates
OptimisticUpdates.addToCart(productId, quantity)
```

### Social Media Platforms
```rescript
// Graceful error handling for privacy
// See: CATCH_DIRECTIVE.md
user.email @catch // Returns Result<string, error>

// Real-time notifications
// See: RECIPES.md#real-time-updates
RealtimeUpdates.handleNewMessage({chatId, senderId})

// Infinite scroll feed
// See: RECIPES.md#pagination-patterns
<InfiniteScrollFeed />
```

### Dashboard Applications
```rescript
// Server-side data preloading
// See: NON_REACT_MODE.md
let preloadDashboardData = async () => {
  await Environment.fetchQuery(environment, DashboardQuery.query, variables)
}

// Smart cache invalidation
// See: CACHE_INVALIDATION.md
CacheManager.invalidateUserData(userId)

// Form handling with mutations
// See: RECIPES.md#form-handling
<UserProfileForm />
```

## Performance Best Practices

1. **Use Prefetching Strategically**
   - Prefetch on hover for "Load More" buttons
   - Use Intersection Observer for scroll-based prefetching
   - Don't prefetch too aggressively to avoid unnecessary requests

2. **Implement Smart Cache Invalidation**
   - Only invalidate what has actually changed
   - Use debounced invalidation for rapid updates
   - Group related invalidations together

3. **Leverage Field Handlers**
   - Transform data once at the cache level
   - Implement computed fields for derived values
   - Use memoization for expensive computations

4. **Optimize with Persisted Queries**
   - Reduce bundle size by removing query strings
   - Improve security with query allowlisting
   - Enable better server-side caching

## Security Considerations

### Field-Level Security
```rescript
// Use @catch for permission-based fields
user.socialSecurity @catch // May return Error for unauthorized access
```

### Query Security
```rescript
// Implement query allowlisting with persisted queries
let secureEnvironment = createEnvironmentWithPersistedQueries(allowedQueries)
```

### Data Validation
```rescript
// Validate data with field handlers
let emailValidationHandler = (value) => 
  isValidEmail(value) ? Some(value) : None
```

## Testing Strategies

### Unit Testing
```rescript
// Test field handlers in isolation
let testCurrencyHandler = () => {
  let result = currencyHandler(Some(100.0), {"currency": "USD"})
  expect(result)->toEqual(Some("$100.00"))
}
```

### Integration Testing
```rescript
// Test components with mock environments
let {getByText} = TestUtils.renderWithRelay(
  <UserProfile userId="1" />,
  ~mockResolvers,
  ()
)
```

### End-to-End Testing
```rescript
// Test real-world scenarios
let testCompleteUserFlow = async () => {
  await createUser()
  await loginUser()
  await updateProfile()
  await logoutUser()
}
```

## Migration Guide

### From Basic Relay Usage
1. **Add Error Handling**: Start with `@catch` directive for optional fields
2. **Improve Pagination**: Replace basic pagination with `usePrefetchableForwardPagination`
3. **Add Cache Management**: Implement strategic invalidation after mutations

### From Other GraphQL Clients
1. **Understand Fragments**: Learn fragment-based data fetching
2. **Leverage Cache**: Use Relay's normalized cache effectively
3. **Adopt Patterns**: Implement the patterns from this documentation

## Contributing

When contributing to RescriptRelay documentation:

1. **Follow Patterns**: Use the established patterns from these docs
2. **Provide Examples**: Include practical, copy-paste examples
3. **Consider Performance**: Always mention performance implications
4. **Test Thoroughly**: Ensure examples work in real applications

## Additional Resources

- [Official RescriptRelay Documentation](https://rescript-relay-documentation.vercel.app/)
- [Relay Documentation](https://relay.dev/)
- [ReScript Documentation](https://rescript-lang.org/)
- [GraphQL Specification](https://graphql.org/)

## Support

For questions and issues:
- [GitHub Issues](https://github.com/zth/rescript-relay/issues)
- [Discord Community](https://discord.gg/rescript)

---

This documentation represents community-driven efforts to fill gaps in the official RescriptRelay documentation. Each guide provides practical, production-ready patterns that have been used in real-world applications.