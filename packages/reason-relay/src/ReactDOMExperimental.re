include ReactDOM.Experimental;

[@bs.module "react-dom"]
external unstable_createRoot: Dom.element => root = "unstable_createRoot";

[@bs.module "react-dom"]
external unstable_createBlockingRoot: Dom.element => root = "unstable_createBlockingRoot";