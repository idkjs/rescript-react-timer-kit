
let expiryTimestamp = expiryTimestamp => {
  let isValid = Date.getTime(expiryTimestamp) > 0.
  if !isValid {
    Console.warn2(
      "react-timer-hook: { useTimer } Invalid expiryTimestamp settings",
      expiryTimestamp,
    )
  }
  isValid
}
// let isFunction = (x: 'a) => {
//   x->typeof == `function;
// }
let onExpire = onExpire => {
  let isValid = switch onExpire {
  | Some(onExpire) =>
    let isValid = typeof(onExpire) == #function
    !isValid
      ? {
          Console.warn2(
            "react-timer-hook: { useTimer } Invalid onExpire settings function",
            onExpire,
          )->ignore
          false
        }
      : true
  | None => false
  }
  isValid
}
// let onExpire = onExpire => {
//   let isValid = onExpire && typeof(onExpire) == #function
//   if onExpire && !isValid {
//     Console.warn2("react-timer-hook: { useTimer } Invalid onExpire settings function", onExpire)
//   }
//   isValid
// }
