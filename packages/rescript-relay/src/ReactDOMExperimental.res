include ReactDOM.Experimental

@module("react-dom")
external unstable_createRoot: Dom.element => root = "unstable_createRoot"

@module("react-dom")
external unstable_createBlockingRoot: Dom.element => root = "unstable_createBlockingRoot"
