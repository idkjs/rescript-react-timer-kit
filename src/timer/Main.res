open Types
@react.component
let make = () => {
  let {hours, minutes, seconds, _} = UseTime.useTime(~format=None, ())
  <div>
    <h2> {React.string("UseTime Demo")} </h2>
    <div>
      <h2> {React.string("hours")} </h2>
      <h2> {React.int(hours)} </h2>
      <h2> {React.string("minutes")} </h2>
      <h2> {React.int(minutes)} </h2>
      <h2> {React.string("seconds")} </h2>
      <h2> {React.int(seconds)} </h2>
    //   <h2> {React.string(ampm)} </h2>
    </div>
  </div>
}
