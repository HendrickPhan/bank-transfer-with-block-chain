import React from 'react';
import { useState, useEffect, useCallback } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import Settings from "../../settings"

const useStyles = makeStyles((theme) => ({
  root: {
    '& > *': {
      margin: theme.spacing(1),
    },
    textAlign: 'center',
    alignSelf: 'center'
  },
  textField: {
    width: 450,
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1),
    marginBottom: theme.spacing(2),
  },
  extendedIcon: {
    marginRight: theme.spacing(1),
  },
  paper: {
    position: 'absolute',
    width: 500,
    backgroundColor: theme.palette.background.paper,
    border: '2px solid #000',
    boxShadow: theme.shadows[5],
    padding: theme.spacing(2, 4, 3),
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
  }
}));

export default function LoginPage(props) {
  const classes = useStyles();
  const [phoneNumber, setPhoneNumber] = React.useState('');
  const [password, setPassword] = React.useState('');
  const [isLoaded, setIsLoaded] = React.useState(false);
  const [errors, setErrors] = React.useState({});

  const handleLogin = (e) => {
    e.preventDefault();
    fetch(Settings.API_URL_WITHOUT_ADMIN + 'login', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        phone_number: phoneNumber,
        password: password,
      })
    })
      .then(res => res.json())
      .then(
        (result) => {
          setIsLoaded(true);
          if (result.errors) {
            setErrors(result.errors);
          } else {
            setErrors({});
            props.setLoggedIn(true);
            localStorage.setItem('token', result);
          }
        },
        (errors) => {
          setIsLoaded(true);
          setErrors(errors);
        }

      )
  }

  return (
    <Grid container justify="center">
      <Paper
        className={classes.paper}
      >
        <Typography 
          align="center"
          variant="h4"
        >
        Login
        </Typography>
        <form
          className={classes.root}
          autoComplete="off"
          onSubmit={handleLogin}
        >
          <TextField
            label="Phone Number"
            required={true}
            className={classes.textField}
            margin="normal"
            InputLabelProps={{
              shrink: true,
            }}
            onChange={(event) => setPhoneNumber(event.target.value)}
            value={phoneNumber}
          />
          <TextField
            label="Password"
            required={true}
            type="password"
            className={classes.textField}
            InputLabelProps={{
              shrink: true,
            }}
            onChange={(event) => setPassword(event.target.value)}
            value={password}
          />
          {
            Object.keys(errors).map((field) => {
              return (
                errors[field].map((err, idx) => {
                  return (
                    <Typography
                      color="error"
                      key={idx}
                    >
                      {err}
                    </Typography>
                  )
                })
              )
            })
          }
          <Button
            variant="contained"
            // onClick={() => handleActionClick(action.path, {id: data[0]})}
            color='primary'
            className={classes.button}
            type="submit"
          >
            login
            </Button>
        </form>
      </Paper>
    </Grid>

  );
}