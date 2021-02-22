open Utils

@bs.get external location: Dom.window => Dom.location = "location"
@bs.get external pathname: Dom.location => string = "pathname"
@bs.get external search: Dom.location => string = "search"
@bs.val external decodeURIComponent: string => string = "decodeURIComponent"

@bs.val @bs.scope("localStorage") external setItem: (string, string) => unit = "setItem"
@bs.val @bs.scope("localStorage") external removeItem: string => unit = "removeItem"
@bs.val @bs.scope("localStorage") external getItem: string => string = "getItem"

@bs.val external setTimeout: (unit => unit, int) => Js.Global.timeoutId = "setTimeout"
@bs.val external clearTimeout: Js.Global.timeoutId => unit = "clearTimeout"

@bs.val external \"open": (string, string) => unit = "open"

requireCSS("src/Home.css")

let clientId = "ff768664c96d04235b1cc4af1e3b37a8"

let getParam = (p: string) => {
  let query = Webapi.Dom.window |> location |> search |> Webapi.Url.URLSearchParams.make

  query |> Webapi.Url.URLSearchParams.get(p) |> Belt.Option.getWithDefault(_, "")
}

let openVscode = () => {
  let state = getParam("state")
  let code = getParam("code")
  let cbUri = getItem("callbackUri")
  let url = cbUri ++ "&state=" ++ state ++ "&code=" ++ code

  \"open"(url, "_self")
}

@react.component
let make = () => {
  let code = getParam("code")
  let state = getParam("state")
  let team = getParam("team")
  let scope = getParam("scope")

  let callbackUri = ref(getParam("callbackUri")->decodeURIComponent)
  if Js.String.length(callbackUri.contents) === 0 {
    callbackUri := getItem("callbackUri")
  }

  let shouldOpenVscode = Js.String.length(code) > 0 && Js.String.length(state) > 0

  React.useEffect0(() => {
    if Js.String.length(callbackUri.contents) > 0 {
      setItem("callbackUri", callbackUri.contents)
    }

    if shouldOpenVscode {
      let timer = ref(Js.Nullable.null)
      Js.Nullable.iter(timer.contents, (. timer) => Js.Global.clearTimeout(timer))
      timer := Js.Nullable.return(Js.Global.setTimeout(() => {
        openVscode()
      }, 200))
    }

    Some(() => ())
  })

  let hasTeam = Js.String.length(team) > 0

  let queries = [
    "response_type=code",
    "client_id=" ++ clientId,
    "scope=" ++ scope,
    "state=" ++ state,
    "callbackUri=" ++ callbackUri.contents,
  ]
  let authQuery = Js.Array.joinWith("&", queries)

  let authUrl = ref("")
  if hasTeam {
    authUrl := "https://" ++ team ++ ".coding.net/oauth_authorize.html?"
  }

  <main>
    <h1> {React.string("Connect to CODING.NET")} </h1>
    <pre> {React.string("team: ")} <code> {React.string(team)} </code> </pre>
    <pre> {React.string("callbackUri: ")} <code> {React.string(callbackUri.contents)} </code> </pre>
    {// <pre> {React.string("state: ")} <code> {React.string(state)} </code> </pre>
    // <pre> {React.string("code: ")} <code> {React.string(code)} </code> </pre>
    hasTeam && !shouldOpenVscode
      ? <a href={authUrl.contents ++ authQuery} target="_blank"> {React.string("Authorize")} </a>
      : React.null}
    {shouldOpenVscode
      ? <button className="open-vscode" onClick={ev => openVscode()}>
          {React.string("Open VS Code")}
        </button>
      : React.null}
  </main>
}
