// Copied from the router, just to enable testing.
type preloadComponentAsset = {
  @as("__$rescriptChunkName__") chunk: string,
  load: unit => unit,
}

@live
type preloadAsset =
  | Component(preloadComponentAsset)
  | Image({url: string})
  | Style({url: string})
