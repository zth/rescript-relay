let subCounter = ref(0)
let subscribers = []

let subscribe = cb => {
  let count = subCounter.contents
  subCounter := count + 1
  subscribers->Js.Array2.push((count, cb))->ignore
  count
}

let unsubscribe = id => {
  switch subscribers->Js.Array2.findIndex(((itemId, _)) => itemId === id) {
  | -1 => ()
  | idx => subscribers->Js.Array2.spliceInPlace(~add=[], ~pos=idx, ~remove=1)->ignore
  }
}

let wait = duration =>
  Js.Promise2.make((~resolve, ~reject as _) => {
    let _ = Js.Global.setTimeout(() => {
      resolve()
    }, duration)
  })

@unboxed
type userStatusValue = Fetching | Value(bool)

let userStatuses = Js.Dict.empty()

let readUserStatus = userId => userStatuses->Js.Dict.get(userId)

let getUserStatus = async userId => {
  userStatuses->Js.Dict.set(userId, Fetching)

  await wait(200)
  subscribers->Js.Array2.forEach(((_, cb)) => {
    cb()
  })
  userStatuses->Js.Dict.set(userId, Value(true))
  true
}

let getUserStatus = userId => {
  switch userStatuses->Js.Dict.get(userId) {
  | None =>
    getUserStatus(userId)->ignore
    Fetching

  | Some(v) => v
  }
}
