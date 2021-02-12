open Utils;

registerServiceWorker();

let rootDom = ReactDOM.querySelector("#root")

switch rootDom {
| None => ()
| Some(root) => ReactDOM.render(<App />, root)
}

ReasonReactRouter.push("");
