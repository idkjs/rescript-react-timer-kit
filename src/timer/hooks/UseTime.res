let useTime: Types.useTime = (~format, ()) => {
  let (seconds, setSeconds) = React.useState(_ => Time.getSecondsFromTimeNow())

  Hooks.useInterval(() => setSeconds(_ => Time.getSecondsFromTimeNow()), 1000)

  let formattedTime = Time.getFormattedTimeFromSeconds(seconds, ~format?, ())
  open Types

  let (hours, minutes, seconds, ampm) = formattedTime

  {hours: hours, minutes: minutes, seconds: seconds, ampm: ampm}
}
