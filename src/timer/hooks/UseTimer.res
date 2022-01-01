
let defaultDelay = 1000.

let getDelayFromExpiryTimestamp = (expiryTimestamp: Date.t) => {
  let isExpiryTimestamp = Validate.expiryTimestamp(expiryTimestamp)

  switch !isExpiryTimestamp {
  | true => 0.
  | false =>
    let seconds = Time.getSecondsFromExpiry(expiryTimestamp, ~shouldRound=true, ())
    let extraMilliSeconds = Math.floor((seconds -. Math.floor(seconds)) *. 1000.)
    extraMilliSeconds > 0. ? extraMilliSeconds : defaultDelay
  }
}

let useTimer = (expiry, onExpire: option<unit => unit>, autoStart) => {
  let (expiryTimestamp, setExpiryTimestamp) = React.useState(_ => expiry)
  let (seconds, setSeconds) = React.useState(_ => Time.getSecondsFromExpiry(expiry, ()))
  let (isRunning, setIsRunning) = React.useState(_ => autoStart)
  let (didStart, setDidStart) = React.useState(_ => autoStart)
  let (delay, setDelay) = React.useState(_ => getDelayFromExpiryTimestamp(expiryTimestamp))

  let handleExpire = () => {
    Validate.onExpire(onExpire)
      ? {
          switch onExpire {
          | Some(onExpire) => onExpire()
          | None => ()
          }
        }
      : ()
    setIsRunning(_ => false)
    setDelay(_) |> ignore
  }

  let pause = () => {
    setIsRunning(_ => false)
  }

  let restart = (newExpiryTimestamp, newAutoStart) => {
    setDelay(_ => getDelayFromExpiryTimestamp(newExpiryTimestamp))
    setDidStart(_ => newAutoStart)
    setIsRunning(_ => newAutoStart)
    setExpiryTimestamp(_ => newExpiryTimestamp)
    let secs = Time.getSecondsFromExpiry(newExpiryTimestamp, ~shouldRound=false, ())
    setSeconds(_ => secs)
  }

  let resume = () => {
    let time = Date.make()
    let milliseconds = Date.getMilliseconds(time)
    Date.setMilliseconds(time, milliseconds + int_of_float(seconds) * 1000)
    restart(time, true)
  }

  let start = () => {
    didStart ? setIsRunning(_ => true) : resume()
  }

  Hooks.useInterval(() => {
    if delay !== defaultDelay {
      setDelay(_ => defaultDelay)
    }
    let secondsValue = Time.getSecondsFromExpiry(expiryTimestamp, ())
    setSeconds(_ => secondsValue)
    if secondsValue <= 0. {
      handleExpire()
    }
  }, isRunning ? int_of_float(delay) : 0)
  (Time.getTimeFromSeconds(seconds), start, pause, resume, restart, isRunning)
}

let useTime = format => {
  let (seconds, setSeconds) = React.useState(_ => Time.getSecondsFromTimeNow())

  Hooks.useInterval(() => {setSeconds(_ => Time.getSecondsFromTimeNow())}, 1000)
  Time.getFormattedTimeFromSeconds(seconds, format)
}
