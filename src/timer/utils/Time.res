
let globalTime = (~time) => {
  let seconds = time->Date.getSeconds
  let minutes = time->Date.getMinutes
  let hours = time->Date.getHours
  (seconds, minutes, hours)
}

let divideWithModuloToInt = (a, b) => mod(int_of_float(a), int_of_float(b))
let divideWithModulo = (a, b) => mod(int_of_float(a), int_of_float(b)) |> float

type timeFromSeconds = {
  seconds: int,
  minutes: int,
  hours: int,
  days: int,
}

let getTimeFromSeconds: float => timeFromSeconds = secs => {
  let totalSeconds = Math.ceil(secs)
  let days = int_of_float(Math.floor(totalSeconds /. 60. *. 60. *. 24.))

  let hours = int_of_float(Math.floor(divideWithModulo(totalSeconds, 60. *. 60. /. (60. *. 60.))))
  let minutes = int_of_float(Math.floor(Float.mod(totalSeconds, 60. *. 60. /. 60.)))
  let seconds = int_of_float(Math.floor(Float.mod(totalSeconds, 60.)))
  {seconds: seconds, minutes: minutes, hours: hours, days: days}
}

// https://forum.rescript-lang.org/t/the-design-decision-behind-option-a-in-the-function-definition-seems-strange/1559
// https://github.com/yawaramin/bucklescript-bindings-cookbook/blob/master/ReScript.md#mkdirsrcmain-recursive-true--options-object-argument
let getSecondsFromExpiry = (expiry: Date.t, ~shouldRound=?, ()) => {
  let now = Date.make() |> Date.getTime

  let milliSecondsDistance = Date.getTime(expiry) -. now
  let _val = () => milliSecondsDistance /. 1000.
  let shouldRound = switch shouldRound {
  | Some(true) => true
  | _ => false
  }

  milliSecondsDistance > 0.
    ? shouldRound
        ? {
            Math.round(_val())
          }
        : _val()
    : 0.
}

let getSecondsFromTimeNow = () => {
  let date = Date.make()
  let time = Date.make() |> Date.valueOf
  let offset = Date.getTimezoneOffset(date) * 60 |> float
  //   let currentTimestamp = now
  //   let currentTimestamp = now |> Date.getTime
  let result = time /. 1000. -. offset
  result
}

let getFormattedTimeFromSeconds = (totalSeconds, ~format=?, ()) => {
  let {seconds, minutes, hours, _}: timeFromSeconds = getTimeFromSeconds(totalSeconds)
  let ampm = #Empty
  switch format {
  | Some(format) =>
    if format == "12-hour" {
      let ampm = hours >= 12 ? #PM : #AM
      let hours = divideWithModulo(hours->Int.toFloat, 12.)
      (seconds, minutes, hours->Float.toInt, ampm)
    } else {
      (seconds, minutes, hours, ampm)
    }
  | None => (seconds, minutes, hours, ampm)
  }
}
let getSecondsFromPrevTime = (prevTime, ~shouldRound=?, ()) => {
  let now = Date.make() |> Date.getTime
  let milliSecondsDistance = now -. prevTime
  let shouldRound = switch shouldRound {
  | Some(true) => true
  | _ => false
  }
  let _val = () => milliSecondsDistance /. 1000.

  milliSecondsDistance > 0.
    ? shouldRound
        ? {
            Math.round(_val())
          }
        : _val()
    : 0.
}
