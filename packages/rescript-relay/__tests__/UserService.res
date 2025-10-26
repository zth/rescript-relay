let subCounter = ref(0)
let subscribers = []

let subscribe = cb => {
  let count = subCounter.contents
  subCounter := count + 1
  subscribers->Array.push((count, cb))->ignore
  count
}

let unsubscribe = id => {
  switch subscribers->Array.findIndex(((itemId, _)) => itemId === id) {
  | -1 => ()
  | idx => subscribers->Array.splice(~start=idx, ~remove=1, ~insert=[])->ignore
  }
}

let wait = duration =>
  Promise.make((resolve, _) => {
    let _ = setTimeout(() => {
      resolve()
    }, duration)
  })

@unboxed
type userStatusValue = Fetching | Value(bool)

let userStatuses = Dict.make()

let readUserStatus = userId => userStatuses->Dict.get(userId)

let getUserStatus = async userId => {
  userStatuses->Dict.set(userId, Fetching)

  await wait(200)
  subscribers->Array.forEach(((_, cb)) => {
    cb()
  })
  userStatuses->Dict.set(userId, Value(true))
  true
}

let getUserStatus = userId => {
  switch userStatuses->Dict.get(userId) {
  | None =>
    getUserStatus(userId)->ignore
    Fetching

  | Some(v) => v
  }
}
