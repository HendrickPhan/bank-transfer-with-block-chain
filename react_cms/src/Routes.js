import React from "react";
import { useState, useEffect, useCallback } from 'react';
import {
  BrowserRouter as Router,
  Switch,
  Route,
} from "react-router-dom";
import Menu from "./components/menu"
import Home from "./pages/home"
import UserPage from "./pages/user"
import BankAccountPage from "./pages/bank_account"
import TransactionPage from "./pages/transaction"
import InterestRatePage from "./pages/interest_rate"
import LoginPage from "./pages/login"
import Settings from "./settings"
import { Get } from "./api"
// theme
import CssBaseline from "@material-ui/core/CssBaseline";
import {ThemeProvider } from '@material-ui/core/styles';
import Theme from './theme'
import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) => ({
  root: {
   
  }
}));

export default function Routes() {
  const classes = useStyles();
  const [loggedIn, setLoggedIn] = React.useState(false);
  const fetchData = useCallback(() => {
    Get(Settings.API_URL_WITHOUT_ADMIN + 'profile')
      .then(
        (result) => {
          setLoggedIn(true)
        },
        (errors) => {
          setLoggedIn(false)
        }
      )
  }, []);

  useEffect(() => {
    fetchData();
  }, [fetchData])


  return (
    <ThemeProvider theme={Theme}>
      <CssBaseline />
      <Router>
        {loggedIn ?
          <div
            className={classes.root}
          >
            <Menu
              setLoggedIn={setLoggedIn}
            />

            <Switch>
              <Route exact path="/">
                <Home />
              </Route>
              <Route path="/user">
                <UserPage />
              </Route>
              <Route path="/bank-account">
                <BankAccountPage />
              </Route>
              <Route path="/transaction">
                <TransactionPage />
              </Route>
              <Route path="/transaction/:accountNumber">
                <TransactionPage />
              </Route>
              <Route path="/interest-rate">
                <InterestRatePage />
              </Route>
            </Switch>
          </div>
          : <LoginPage
            setLoggedIn={setLoggedIn}
          />
        }
      </Router>
    </ThemeProvider>

  );
}
