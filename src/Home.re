open Utils;

[@bs.get] external location: Dom.window => Dom.location = "location";
[@bs.get] external pathname: Dom.location => string = "pathname";
[@bs.get] external search: Dom.location => string = "search";

requireCSS("src/Home.css");

[@react.component]
let make = () => {
  React.useEffect0(() => {
    let query = Webapi.Dom.window |> location |> search;
    let params = query |> Webapi.Url.URLSearchParams.make;
    Js.log(params |> Webapi.Url.URLSearchParams.get("code"));
    None;
  });

  <main className="t">
    <h1> {React.string("Connect")} </h1>
    <pre> {React.string("code: ")} </pre>
    <pre> {React.string("state: ")} </pre>
    <pre> {React.string("callbackUri: ")} </pre>
  </main>;
};
