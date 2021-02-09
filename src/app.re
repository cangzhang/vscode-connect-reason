[@react.component]
let make = () => {
  let url = ReasonReact.Router.useUrl();

  switch (url.path) {
  | [] => <Home />
  | _ => <NotFound />
  };
};
