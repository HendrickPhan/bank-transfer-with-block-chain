// This is used to determine if a user is authenticated and
// if they are allowed to visit the page they navigated to.

// If they are: they proceed to the page
// If not: they are redirected to the login page.
import React from 'react'
import { Auth } from '../ultilities/auth';
import { Redirect, Route } from 'react-router-dom'
import { useSelector } from 'react-redux';

const AdminRoute = ({ component: Component, ...rest }) => {

  // Add your own authentication on the below line.
  const loginData = useSelector(state => state.auth);
  const { loggedIn } = loginData;

  return (
    <Route
      {...rest}
      render={props =>
        loggedIn ? (
          <Component {...props} />
        ) : (
          <Redirect to={{ pathname: '/login', state: { from: props.location } }} />
        )
      }
    />
  )
}

export default AdminRoute