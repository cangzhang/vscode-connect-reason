open Utils;

[@bs.get] external location: Dom.window => Dom.location = "location";
[@bs.get] external pathname: Dom.location => string = "pathname";
[@bs.get] external search: Dom.location => string = "search";
[@bs.val] external decodeURIComponent: string => string = "decodeURIComponent";

requireCSS("src/Home.css");

[@react.component]
let make = () => {
  let query =
    Webapi.Dom.window |> location |> search |> Webapi.Url.URLSearchParams.make;
  let getParam: string => string =
    p =>
      query
      |> Webapi.Url.URLSearchParams.get(p)
      |> Belt.Option.getWithDefault(_, "");

  let (code, setCode) = React.useState(() => getParam("code"));
  let (state, setState) = React.useState(() => getParam("state"));
  let (callbackUri, setUri) = React.useState(() => getParam("callbackUri") -> decodeURIComponent);
  let (team, setTeam) = React.useState(() => getParam("team"));

  React.useEffect0(() => {
    if (Js.String2.length(callbackUri) > 0) {
      Js.log("should remove local storage")
    }
    None;
  });

  <main>
    <h1> {React.string("Connect")} </h1>
    <pre> {React.string("code: " ++ code)} </pre>
    <pre> {React.string("state: " ++ state)} </pre>
    <pre> {React.string("team: " ++ team)} </pre>
    <pre> {React.string("callbackUri: " ++ callbackUri)} </pre>
  </main>;
};
