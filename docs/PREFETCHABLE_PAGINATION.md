# usePrefetchableForwardPagination

The `usePrefetchableForwardPagination` hook provides advanced pagination capabilities with built-in prefetching to improve user experience by reducing loading times for subsequent pages.

## Overview

This hook combines the functionality of standard pagination with intelligent prefetching, allowing you to load the next page in the background before the user requests it. This results in near-instantaneous page transitions and a smoother user experience.

## Basic Usage

```rescript
module ProductsQuery = %relay(`
  query ProductsQuery($first: Int, $after: String) {
    products(first: $first, after: $after) @connection(key: "ProductsList_products") {
      edges {
        node {
          id
          name
          price
          description
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
  let {data, loadNext, hasNext, isLoadingNext, prefetchNext, refetch} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(ProductsQuery),
      ~variables={first: 10, after: None},
    )

  <div className="products-container">
    <h1>{React.string("Products")}</h1>
    
    <div className="products-grid">
      {data.products.edges
      ->Array.map(edge => 
        <div key={edge.node.id} className="product-card">
          <h3>{React.string(edge.node.name)}</h3>
          <p className="price">
            {React.string("$" ++ Float.toString(edge.node.price))}
          </p>
          <p className="description">
            {React.string(edge.node.description)}
          </p>
        </div>
      )
      ->React.array}
    </div>
    
    {hasNext 
      ? <button 
          className="load-more-btn"
          onClick={_ => loadNext(~count=10, ())} 
          disabled={isLoadingNext}
        >
          {React.string(isLoadingNext ? "Loading..." : "Load More")}
        </button>
      : <p className="end-message">
          {React.string("You've reached the end!")}
        </p>
    }
  </div>
}
```

## Hook Return Values

The hook returns an object with the following properties:

- `data`: The current query data including all loaded pages
- `loadNext`: Function to load the next page
- `hasNext`: Boolean indicating if there are more pages available
- `isLoadingNext`: Boolean indicating if the next page is currently loading
- `prefetchNext`: Function to prefetch the next page without displaying it
- `refetch`: Function to refetch the entire query from the beginning

## Advanced Prefetching Strategies

### 1. Hover-based Prefetching

Prefetch the next page when the user hovers over the "Load More" button:

```rescript
@react.component
let make = () => {
  let {data, loadNext, hasNext, isLoadingNext, prefetchNext} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(ProductsQuery),
      ~variables={first: 10, after: None},
    )

  <div>
    {/* Product grid */}
    <div className="products-grid">
      {data.products.edges
      ->Array.map(edge => 
        <ProductCard key={edge.node.id} product={edge.node} />
      )
      ->React.array}
    </div>
    
    {hasNext 
      ? <button 
          className="load-more-btn"
          onClick={_ => loadNext(~count=10, ())}
          onMouseEnter={_ => prefetchNext(~count=10, ())}
          disabled={isLoadingNext}
        >
          {React.string(isLoadingNext ? "Loading..." : "Load More")}
        </button>
      : React.null
    }
  </div>
}
```

### 2. Scroll-based Prefetching

Prefetch when the user scrolls close to the bottom:

```rescript
@react.component
let make = () => {
  let {data, loadNext, hasNext, prefetchNext} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(ProductsQuery),
      ~variables={first: 10, after: None},
    )
  
  let (hasPrefeched, setHasPrefetched) = React.useState(() => false)
  
  React.useEffect(() => {
    let handleScroll = () => {
      let scrollPosition = Dom.window->Dom.Window.scrollY
      let documentHeight = Dom.document
        ->Dom.Document.documentElement
        ->Dom.Element.scrollHeight
      let windowHeight = Dom.window->Dom.Window.innerHeight
      
      // Prefetch when 80% scrolled and haven't prefetched yet
      if (
        scrollPosition +. windowHeight > documentHeight *. 0.8 && 
        hasNext && 
        !hasPrefeched
      ) {
        prefetchNext(~count=10, ())
        setHasPrefetched(_ => true)
      }
    }
    
    Dom.window->Dom.Window.addEventListener("scroll", handleScroll)
    Some(() => Dom.window->Dom.Window.removeEventListener("scroll", handleScroll))
  }, [hasNext, hasPrefeched])
  
  // Reset prefetch flag when new page loads
  React.useEffect(() => {
    setHasPrefetched(_ => false)
  }, [Array.length(data.products.edges)])

  <div>
    {/* Products display */}
    <div className="products-grid">
      {data.products.edges
      ->Array.map(edge => 
        <ProductCard key={edge.node.id} product={edge.node} />
      )
      ->React.array}
    </div>
    
    {hasNext 
      ? <button onClick={_ => loadNext(~count=10, ())}>
          {React.string("Load More")}
        </button>
      : React.null
    }
  </div>
}
```

### 3. Intersection Observer Prefetching

Use Intersection Observer for more efficient scroll detection:

```rescript
@react.component
let make = () => {
  let {data, loadNext, hasNext, prefetchNext} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(ProductsQuery),
      ~variables={first: 10, after: None},
    )
  
  let sentinelRef = React.useRef(Js.Nullable.null)
  
  React.useEffect(() => {
    let current = sentinelRef.current->Js.Nullable.toOption
    
    switch current {
    | Some(element) =>
      let observer = IntersectionObserver.make((entries, _) => {
        entries->Array.forEach(entry => {
          if (entry->IntersectionObserver.Entry.isIntersecting && hasNext) {
            prefetchNext(~count=10, ())
          }
        })
      }, {threshold: 0.1})
      
      observer->IntersectionObserver.observe(element)
      Some(() => observer->IntersectionObserver.disconnect())
    | None => None
    }
  }, [hasNext])

  <div>
    <div className="products-grid">
      {data.products.edges
      ->Array.map(edge => 
        <ProductCard key={edge.node.id} product={edge.node} />
      )
      ->React.array}
    </div>
    
    {/* Invisible sentinel element */}
    <div ref={ReactDOM.Ref.domRef(sentinelRef)} className="scroll-sentinel" />
    
    {hasNext 
      ? <button onClick={_ => loadNext(~count=10, ())}>
          {React.string("Load More")}
        </button>
      : React.null
    }
  </div>
}
```

## Error Handling

Handle errors gracefully in pagination:

```rescript
module ProductsQuery = %relay(`
  query ProductsQuery($first: Int, $after: String) {
    products(first: $first, after: $after) @connection(key: "ProductsList_products") {
      edges {
        node {
          id
          name
          price @catch
          image @catch
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
  let {data, loadNext, hasNext, isLoadingNext, refetch} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(ProductsQuery),
      ~variables={first: 10, after: None},
    )
  
  let (loadError, setLoadError) = React.useState(() => None)
  
  let handleLoadNext = () => {
    setLoadError(_ => None)
    try {
      loadNext(~count=10, ())
    } catch {
    | error => setLoadError(_ => Some(error))
    }
  }

  <div>
    <div className="products-grid">
      {data.products.edges
      ->Array.map(edge => 
        <div key={edge.node.id} className="product-card">
          <h3>{React.string(edge.node.name)}</h3>
          
          {switch edge.node.price {
          | Ok(price) => 
            <p className="price">
              {React.string("$" ++ Float.toString(price))}
            </p>
          | Error(_) => 
            <p className="price-error">
              {React.string("Price unavailable")}
            </p>
          }}
          
          {switch edge.node.image {
          | Ok(imageUrl) => 
            <img src=imageUrl alt={edge.node.name} />
          | Error(_) => 
            <div className="image-placeholder">
              {React.string("No image")}
            </div>
          }}
        </div>
      )
      ->React.array}
    </div>
    
    {switch loadError {
    | Some(_) => 
      <div className="error-banner">
        <p>{React.string("Failed to load more products")}</p>
        <button onClick={_ => handleLoadNext()}>
          {React.string("Try Again")}
        </button>
        <button onClick={_ => refetch()}>
          {React.string("Refresh All")}
        </button>
      </div>
    | None => React.null
    }}
    
    {hasNext 
      ? <button 
          onClick={_ => handleLoadNext()}
          disabled={isLoadingNext}
        >
          {React.string(isLoadingNext ? "Loading..." : "Load More")}
        </button>
      : React.null
    }
  </div>
}
```

## Performance Optimization

### 1. Variable Page Sizes

Adjust page size based on network conditions or user behavior:

```rescript
@react.component
let make = () => {
  let (pageSize, setPageSize) = React.useState(() => 10)
  
  let {data, loadNext, hasNext, isLoadingNext} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(ProductsQuery),
      ~variables={first: pageSize, after: None},
    )
  
  // Adjust page size based on connection speed
  React.useEffect(() => {
    let connection = Navigator.connection
    switch connection {
    | Some(conn) when conn.effectiveType === "slow-2g" => setPageSize(_ => 5)
    | Some(conn) when conn.effectiveType === "4g" => setPageSize(_ => 20)
    | _ => setPageSize(_ => 10)
    }
  }, [])

  <div>
    {/* Products display */}
    <div className="products-grid">
      {data.products.edges
      ->Array.map(edge => 
        <ProductCard key={edge.node.id} product={edge.node} />
      )
      ->React.array}
    </div>
    
    <div className="pagination-controls">
      <label>
        {React.string("Items per page: ")}
        <select 
          value={Int.toString(pageSize)} 
          onChange={e => {
            let newSize = ReactEvent.Form.target(e)["value"]->Int.fromString
            switch newSize {
            | Some(size) => setPageSize(_ => size)
            | None => ()
            }
          }}
        >
          <option value="5">{React.string("5")}</option>
          <option value="10">{React.string("10")}</option>
          <option value="20">{React.string("20")}</option>
          <option value="50">{React.string("50")}</option>
        </select>
      </label>
      
      {hasNext 
        ? <button onClick={_ => loadNext(~count=pageSize, ())}>
            {React.string(isLoadingNext ? "Loading..." : "Load More")}
          </button>
        : React.null
      }
    </div>
  </div>
}
```

### 2. Memory Management

Implement virtual scrolling for large lists:

```rescript
// Component with virtual scrolling for performance
@react.component
let make = () => {
  let {data, loadNext, hasNext, prefetchNext} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(ProductsQuery),
      ~variables={first: 20, after: None},
    )
  
  let virtualizedListRef = React.useRef(Js.Nullable.null)
  
  // Prefetch when near the end of virtual list
  let handleItemsRendered = (~visibleStartIndex, ~visibleStopIndex, ()) => {
    let totalItems = Array.length(data.products.edges)
    if (visibleStopIndex >= totalItems - 5 && hasNext) {
      prefetchNext(~count=20, ())
    }
  }

  <VirtualizedList
    ref={ReactDOM.Ref.domRef(virtualizedListRef)}
    items={data.products.edges}
    itemHeight=200
    containerHeight=800
    renderItem={item => <ProductCard product={item.node} />}
    onItemsRendered=handleItemsRendered
    endReached={() => {
      if (hasNext) {
        loadNext(~count=20, ())
      }
    }}
  />
}
```

## Integration with Filtering and Sorting

Combine pagination with filters and sorting:

```rescript
module ProductsQuery = %relay(`
  query ProductsQuery(
    $first: Int, 
    $after: String, 
    $filter: ProductFilter, 
    $sortBy: ProductSort
  ) {
    products(
      first: $first, 
      after: $after, 
      filter: $filter, 
      sortBy: $sortBy
    ) @connection(key: "ProductsList_products") {
      edges {
        node {
          id
          name
          price
          category
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
  let (filter, setFilter) = React.useState(() => None)
  let (sortBy, setSortBy) = React.useState(() => `PRICE_ASC)
  
  let {data, loadNext, hasNext, refetch} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(ProductsQuery),
      ~variables={first: 10, after: None, filter, sortBy},
    )
  
  // Refetch when filters change
  React.useEffect(() => {
    refetch()
  }, [filter, sortBy])

  <div>
    <div className="controls">
      <select 
        value={sortBy->sortByToString} 
        onChange={e => {
          let value = ReactEvent.Form.target(e)["value"]
          setSortBy(_ => sortByFromString(value))
        }}
      >
        <option value="PRICE_ASC">{React.string("Price: Low to High")}</option>
        <option value="PRICE_DESC">{React.string("Price: High to Low")}</option>
        <option value="NAME_ASC">{React.string("Name: A to Z")}</option>
      </select>
      
      <input
        type_="text"
        placeholder="Filter by name..."
        onChange={e => {
          let value = ReactEvent.Form.target(e)["value"]
          setFilter(_ => String.length(value) > 0 ? Some({name: value}) : None)
        }}
      />
    </div>
    
    <div className="products-grid">
      {data.products.edges
      ->Array.map(edge => 
        <ProductCard key={edge.node.id} product={edge.node} />
      )
      ->React.array}
    </div>
    
    {hasNext 
      ? <button onClick={_ => loadNext(~count=10, ())}>
          {React.string("Load More")}
        </button>
      : React.null
    }
  </div>
}
```

## Best Practices

### 1. Prefetch Strategically

Don't prefetch too aggressively to avoid unnecessary network requests:

```rescript
// Good: Prefetch based on user intent
<button 
  onMouseEnter={_ => prefetchNext(~count=10, ())}
  onClick={_ => loadNext(~count=10, ())}
>
  Load More
</button>

// Bad: Prefetch immediately on component mount
React.useEffect(() => {
  prefetchNext(~count=10, ()) // Too aggressive
}, [])
```

### 2. Handle Loading States

Provide clear feedback during loading:

```rescript
<div className="pagination-status">
  {isLoadingNext 
    ? <div className="loading-spinner">
        <Spinner />
        <span>{React.string("Loading more products...")}</span>
      </div>
    : hasNext
    ? <button onClick={_ => loadNext(~count=10, ())}>
        {React.string("Load More")}
      </button>
    : <p className="end-message">
        {React.string("All products loaded")}
      </p>
  }
</div>
```

### 3. Optimize for Mobile

Consider mobile-specific UX patterns:

```rescript
@react.component
let make = () => {
  let {data, loadNext, hasNext, isLoadingNext} = 
    RescriptRelay.usePrefetchableForwardPagination(
      ~query=module(ProductsQuery),
      ~variables={first: 10, after: None},
    )
  
  let isMobile = useMediaQuery("(max-width: 768px)")

  <div>
    <div className={isMobile ? "products-list" : "products-grid"}>
      {data.products.edges
      ->Array.map(edge => 
        <ProductCard 
          key={edge.node.id} 
          product={edge.node} 
          compact=isMobile
        />
      )
      ->React.array}
    </div>
    
    {/* On mobile, use infinite scroll; on desktop, use button */}
    {isMobile 
      ? <InfiniteScrollTrigger 
          onIntersect={() => {
            if (hasNext && !isLoadingNext) {
              loadNext(~count=10, ())
            }
          }}
        />
      : hasNext 
      ? <button onClick={_ => loadNext(~count=10, ())}>
          {React.string("Load More")}
        </button>
      : React.null
    }
  </div>
}
```

## Troubleshooting

### Common Issues

1. **Connection Key Conflicts**: Ensure your `@connection` key is unique
2. **Variable Changes**: Remember that changing variables will reset pagination
3. **Network Errors**: Always handle network failures gracefully
4. **Memory Leaks**: Clean up event listeners and observers

### Debug Mode

Enable debug logging to troubleshoot pagination issues:

```rescript
let {data, loadNext, hasNext, prefetchNext} = 
  RescriptRelay.usePrefetchableForwardPagination(
    ~query=module(ProductsQuery),
    ~variables={first: 10, after: None},
    ~debugMode=true, // Enable debug logging
  )
```

The `usePrefetchableForwardPagination` hook is a powerful tool for creating smooth, performant pagination experiences that feel instantaneous to users.