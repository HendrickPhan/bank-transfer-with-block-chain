import React from 'react';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import TextField from '@material-ui/core/TextField';
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import useStyles from "./styles";

const RenderLoginPage = (props) => {
  const classes = useStyles();
  const [phoneNumber, setPhoneNumber] = React.useState('');
  const [password, setPassword] = React.useState('');
  
  const handleSubmit = (e) => {
    e.preventDefault();
    props.handleLogin(phoneNumber, password);
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
          onSubmit={handleSubmit}
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
            Object.keys(props.errors).length > 0 && Object.keys(props.errors).map((field) => {
              return (
                props.errors[field].map((err, idx) => {
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
            color='primary'
            className={classes.button}
            type="submit"
          >
            login
            </Button>
        </form>
      </Paper>
    </Grid>
  )
}

export default RenderLoginPage;