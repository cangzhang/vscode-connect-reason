open Utils

@bs.get external location: Dom.window => Dom.location = "location"
@bs.get external pathname: Dom.location => string = "pathname"
@bs.get external search: Dom.location => string = "search"
@bs.val external decodeURIComponent: string => string = "decodeURIComponent"
@bs.val @bs.scope("localStorage") external setItem: (string, string) => unit = "setItem"
@bs.val @bs.scope("localStorage") external removeItem: string => unit = "removeItem"
@bs.val external \"open": (string, string) => unit = "open"

requireCSS("src/Home.css")

let getParam = (p: string) => {
  let query = Webapi.Dom.window |> location |> search |> Webapi.Url.URLSearchParams.make

  query |> Webapi.Url.URLSearchParams.get(p) |> Belt.Option.getWithDefault(_, "")
}

let clientId = "ff768664c96d04235b1cc4af1e3b37a8"

@react.component
let make = () => {
  let code = getParam("code")
  let state = getParam("state")
  let callbackUri = getParam("callbackUri")->decodeURIComponent
  let team = getParam("team")
  let scope = getParam("scope")

  React.useEffect0(() => {
    if Js.String2.length(callbackUri) > 0 {
      setItem("callbackUri", callbackUri)
    }

    if Js.String.length(code) > 0 && Js.String.length(state) > 0 {
      let task = Js.Global.setTimeout(() => {
        let url = callbackUri ++ "&state=" ++ state ++ "&code=" ++ code
        \"open"(url, "_self")
        // clearTimeout(task)
      }, 200)
    }

    Some(
      () => {
        removeItem("callbackUri")
      },
    )
  })

  let hasTeam = Js.String.length(team) > 0

  let queries = [
    "response_type=code",
    "client_id=" ++ clientId,
    "scope=" ++ scope,
    "state=" ++ state,
    "callbackUri=" ++ callbackUri,
  ]
  let authQuery = Js.Array.joinWith("&", queries)

  let authUrl = ref("")
  if hasTeam {
    authUrl := "https://" ++ team ++ ".coding.net/oauth_authorize.html?"
  }

  <main>
    <h1> {React.string("Connect to CODING.NET")} </h1>
    <pre> {React.string("team: ")} <code> {React.string(team)} </code> </pre>
    <pre> {React.string("callbackUri: ")} <code> {React.string(callbackUri)} </code> </pre>
    <pre> {React.string("state: ")} <code> {React.string(state)} </code> </pre>
    <pre> {React.string("code: ")} <code> {React.string(code)} </code> </pre>
    {hasTeam
      ? <a href={authUrl.contents ++ authQuery} target="_blank"> {React.string("Authorize")} </a>
      : <p> {React.string("Please try again.")} </p>}
  </main>
}
