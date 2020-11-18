import React from 'react';

import { Redirect } from 'react-router-dom'

import { useSelector, useDispatch } from 'react-redux';
import { login } from '../../redux/actions/auth';
import RenderLoginPage from './login'

export default function LoginPage(props) {
  const dispatch = useDispatch();
  const loginData = useSelector(state => state.auth);
  const { loggedIn, errors } = loginData;
  
  const handleLogin = (phoneNumber, password) => {
    dispatch(login(phoneNumber, password));
  }

  return (
    loggedIn ? (
      <Redirect to={{ pathname: '/' }} />
    ) : (
      <RenderLoginPage
        handleLogin={handleLogin}
        errors={errors}
      />
    )
    
  );
}