module DeferredTest = %relay.deferredComponent(TestDeferredComponent.make)

@@jsxConfig({version: 3})
let jsx = <DeferredTest name="Name" />
