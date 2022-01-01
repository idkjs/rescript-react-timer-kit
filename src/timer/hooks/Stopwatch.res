let useStopwatch = (autoStart, offsetTimestamp) => {
  let (passedSeconds, setPassedSeconds) = React.useState(_ =>
    Time.getSecondsFromExpiry(offsetTimestamp, ~shouldRound=true, ())
  )
  let (prevTime, setPrevTime) = React.useState(_ => Date.now())
  let (seconds, setSeconds) = React.useState(_ =>
    passedSeconds +. Time.getSecondsFromPrevTime(prevTime, ~shouldRound=true, ())
  )
  let (isRunning, setIsRunning) = React.useState(_ => autoStart)

  Hooks.useInterval(() => {
    setSeconds(_ => passedSeconds +. Time.getSecondsFromPrevTime(prevTime, ~shouldRound=true, ()))
  }, isRunning ? 1000 : 0)

  let start = () => {
    let newPrevTime = Date.now()
    setPrevTime(_ => newPrevTime)
    setIsRunning(_ => true)
    setSeconds(_ =>
      passedSeconds +. Time.getSecondsFromPrevTime(newPrevTime, ~shouldRound=true, ())
    )
  }

  let pause = () => {
    setPassedSeconds(_ => seconds)
    setIsRunning(_ => false)
  }

  let reset = (~reset: Types.reset) => {
    let {offsetTimestamp, autoStart} = reset
    let offset = switch offsetTimestamp {
    | Some(offset) => Some(offset)
    | _ => None
    }

    let newAutoStart = switch autoStart {
    | Some(newAutoStart) => newAutoStart
    | None => true
    }
    let unwrap = (value: option<'a>): 'a => Belt.Option.getExn(value)
    let newPassedSeconds = Time.getSecondsFromExpiry(offset->unwrap, ~shouldRound=true, ())
    let newPrevTime = Date.now()
    setPrevTime(_ => newPrevTime)
    setPassedSeconds(_ => newPassedSeconds)
    setIsRunning(_ => newAutoStart)
    setSeconds(_ =>
      newPassedSeconds +. Time.getSecondsFromPrevTime(newPrevTime, ~shouldRound=true, ())
    )
  }

  (Time.getTimeFromSeconds(seconds), start, pause, reset, isRunning)
}
