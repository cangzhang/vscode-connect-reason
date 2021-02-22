open Utils

let nodeEnv = Node.Process.process["env"]

let env = name =>
  switch Js.Dict.get(nodeEnv, name) {
  | Some(value) => Ok(value)
  | None => Error(`Environment variable ${name} is missing`)
  }

switch env("NODE_ENV") {
| Ok("production") => registerServiceWorker()
| Ok(_) => ()
| Error(_) => ()
}

let rootDom = ReactDOM.querySelector("#root")

switch rootDom {
| None => ()
| Some(root) => ReactDOM.render(<App />, root)
}

ReasonReactRouter.push("")
