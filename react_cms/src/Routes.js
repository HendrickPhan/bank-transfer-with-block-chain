import React from "react";
import {
  BrowserRouter as Router,
  Switch,
  Route,
} from "react-router-dom";
import Menu from "./components/menu"
import Home from "./pages/home"
import UserPage from "./pages/user"
import BankAccountPage from "./pages/bank_account"
import InterestRatePage from "./pages/interest_rate"
// Since routes are regular React components, they
// may be rendered anywhere in the app, including in
// child elements.
//
// This helps when it's time to code-split your app
// into multiple bundles because code-splitting a
// React Router app is the same as code-splitting
// any other React app.

export default function Routes() {
  return (
    <Router>
        <Menu/>
        <Switch>
          <Route exact path="/">
            <Home />
          </Route>
          <Route path="/user">
            <UserPage />
            {/* <Topics /> */}
          </Route>
          <Route path="/bank-account">
            <BankAccountPage />
            {/* <Topics /> */}
          </Route>
          <Route path="/interest-rate">
            <InterestRatePage />
            {/* <Topics /> */}
          </Route>
          
        </Switch>
    </Router>
  );
}
