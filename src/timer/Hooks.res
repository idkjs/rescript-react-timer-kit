
let useInterval = (callback: _ => unit, delay: int) => {
  let callbackRef = React.useRef(callback)
  React.useEffect1(() => {
    callbackRef.current = callback
    None
  }, [callback])
  React.useEffect1(() => {
    let tick = callbackRef.current
    let id = Js.Global.setInterval(tick, delay)
    Some(() => Js.Global.clearInterval(id))
  }, [delay])
}
