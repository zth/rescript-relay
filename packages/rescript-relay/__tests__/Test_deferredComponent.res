module DeferredTest = %relay.deferredComponent(TestDeferredComponent.make)

let jsx = <DeferredTest name="Name" />
Js.log(jsx)
