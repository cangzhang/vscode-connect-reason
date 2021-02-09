open Utils;

[@bs.get] external location: Dom.window => Dom.location = "location"
[@bs.get] external pathname: Dom.location => string = "pathname"

requireCSS("src/Home.css");

[@react.component]
let make = () => {
  React.useEffect0(() => {
    Js.log([%external window] |> location |> pathname);
    None;
  });

  <main className="t">
    <h1> {React.string("Connect")} </h1>
    <pre> {React.string("code: ")} </pre>
    <pre> {React.string("state: ")} </pre>
    <pre> {React.string("callbackUri: ")} </pre>
  </main>;
};
