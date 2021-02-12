@react.component
let make = () => {
  let url = ReasonReactRouter.useUrl();

  switch (url.path) {
  | list{} => <Home />
  | _ => <NotFound />
  };
};
