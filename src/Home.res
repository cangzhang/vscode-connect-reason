open Utils

@get external search: Dom.location => string = "search"
@val external decodeURIComponent: string => string = "decodeURIComponent"

@val external setTimeout: (unit => unit, int) => Js.Global.timeoutId = "setTimeout"
@val external clearTimeout: Js.Global.timeoutId => unit = "clearTimeout"
@val external \"open": (string, string) => unit = "open"

requireCSS("src/Home.css")

let clientId = "ff768664c96d04235b1cc4af1e3b37a8"

let getParam = (p: string) => {
  let q = Webapi.Dom.location -> search -> Webapi.Url.URLSearchParams.make
  q -> Webapi.Url.URLSearchParams.get(p, _) -> Belt.Option.getWithDefault(_, "")
}

let getLocalItem = (key: string) =>
  Dom.Storage2.localStorage->Dom.Storage2.getItem(key)->Belt.Option.getWithDefault("")

let openVscode = () => {
  let state = getParam("state")
  let code = getParam("code")
  let cbUri = getLocalItem("callbackUri")
  let url = j`${cbUri}&state=${state}&code=${code}`

  switch Js.String.length(cbUri) {
  | 0 => ()
  | _ => \"open"(url, "_self")
  }
}

@react.component
let make = () => {
  let code = getParam("code")
  let state = getParam("state")
  let team = getParam("team")
  let scope = getParam("scope")

  let queryUri = getParam("callbackUri")->decodeURIComponent
  let localUri = getLocalItem("callbackUri")
  let cbUri = ref(queryUri)

  if Js.String.length(queryUri) === 0 {
    cbUri := localUri
  }

  let shouldOpenVscode = Js.String.length(code) > 0 && Js.String.length(state) > 0

  React.useEffect0(() => {
    if Js.String.length(cbUri.contents) > 0 {
      Dom.Storage2.localStorage->Dom.Storage2.setItem("callbackUri", cbUri.contents)
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
    "callbackUri=" ++ cbUri.contents,
  ]
  let authQuery = Js.Array.joinWith("&", queries)

  let authUrl = ref("")
  if hasTeam {
    authUrl := "https://" ++ team ++ ".coding.net/oauth_authorize.html?"
  }

  <main>
    <h1> {React.string("Connect to CODING.NET")} </h1>
    <pre> {React.string("team: ")} <code> {React.string(team)} </code> </pre>
    <pre> {React.string("callbackUri: ")} <code> {React.string(cbUri.contents)} </code> </pre>
    {
      // <pre> {React.string("state: ")} <code> {React.string(state)} </code> </pre>
      // <pre> {React.string("code: ")} <code> {React.string(code)} </code> </pre>
      hasTeam && !shouldOpenVscode
        ? <a href={authUrl.contents ++ authQuery} target="_blank"> {React.string("Authorize")} </a>
        : React.null
    }
    {shouldOpenVscode
      ? <button className="open-vscode" onClick={ev => openVscode()}>
          {React.string("Open VS Code")}
        </button>
      : React.null}
  </main>
}
