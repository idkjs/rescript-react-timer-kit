// type expiryTimestamp = {seconds: int, minutes: int, hours: int, days: int, isRunning: bool}
@obj
type timerSettings = {
  autoStart: option<bool>,
  expiryTimestamp: Date.t,
  onExpire: option<unit => unit>,
}

@obj
type restart = {
  newExpiryTimestamp: Date.t,
  autoStart: option<bool>,
}
// @obj
// type restart2 = (~newExpiryTimestamp: Date.t,
//   ~autoStart: option<bool>) => stopWatchResult
@obj
type timerResult = {
  seconds: int,
  minutes: int,
  hours: int,
  days: int,
  isRunning: bool,
  start: unit => unit,
  pause: unit => unit,
  resume: unit => unit,
  restart: restart => unit,
}

@obj
type stopWatchSettings = {
  autoStart: option<bool>,
  offsetTimestamp: option<Date.t>,
}

@obj
type reset = {
  offsetTimestamp: option<Date.t>,
  autoStart: option<bool>,
}
@obj
type stopWatchResult = {
  seconds: int,
  minutes: int,
  hours: int,
  days: int,
  isRunning: bool,
  start: unit => unit,
  pause: unit => unit,
  reset: reset => unit,
}

@obj
type useStopWatch = (~settings: option<stopWatchSettings>) => stopWatchResult

@obj
type timeSettings = {format: option<string>}

// type ampm = [#AM | #PM | #Empty]
@obj
type timeResult = {
  seconds: int,
  minutes: int,
  hours: int,
  ampm: [#AM | #PM | #Empty],
}

type useTime = (~format: option<string>, unit) => timeResult
// export function useTime(settings?: TimeSettings): TimeResult
