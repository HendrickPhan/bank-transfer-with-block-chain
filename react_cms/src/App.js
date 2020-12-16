import React from 'react';
import CssBaseline from "@material-ui/core/CssBaseline";
import {ThemeProvider } from '@material-ui/core/styles';
import Theme from './theme'
import Routes from './routes';
import { useSelector, useDispatch } from 'react-redux';
import {useState, useEffect} from 'react';
import {getProfile} from './redux/actions/auth';

function App() {
  const dispatch = useDispatch();
  const authData = useSelector(state => state.auth);
  const { loggedIn, profile, errors } = authData;
  
  useEffect(()=> {
    dispatch(getProfile());
  }, [loggedIn])

  return (
    <ThemeProvider theme={Theme}>
      <CssBaseline />
      <Routes loggedIn={loggedIn}/>
    </ThemeProvider>
  );
}

export default App;
