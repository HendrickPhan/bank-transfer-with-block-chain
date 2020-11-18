import React from 'react';
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';
import Alert from '@material-ui/lab/Alert';
import TextField from '@material-ui/core/TextField';
import Grid from '@material-ui/core/Grid';
import FormControl from '@material-ui/core/FormControl';

import useStyles from "./styles";

const RenderAddUserPage = (props) => {
  const classes = useStyles();

  return (
    <div className={classes.root}>
      <Paper className={classes.paper}>
      {(Object.keys(props.user).length > 0) &&
        <Alert 
          severity="success"
          onClose={() => {
            props.handleClearUser()
          }}
        >
          Added User success: <br/>
          &emsp;<b>Phone number:</b> {props.user.phone_number}<br/>
          &emsp;<b>Name:</b> {props.user.name}<br/>
          &emsp;<b>Password:</b> {props.user.password}<br/>
        </Alert>
      }
      {(Object.keys(props.errors).length > 0) &&
        <Alert 
          severity="error"
          onClose={() => {
            props.handleClearUser()
          }}
        >
          {Object.keys(props.errors).map((field) => {
              return (
                props.errors[field].map((err, idx) => {
                  return (
                    <div>{err}</div>
                  )
                })
              )
            })
          }
        </Alert>
      }  
      <form 
        onSubmit={props.handleSubmit}
      >
          <Grid
            className={classes.filter}
            direction="column"
            alignItems="center"
            justify="center"
          >
            <FormControl 
              variant="filled" 
              className={classes.textField}
            >
              <TextField
                className={classes.textField}
                label="Name"
                variant="filled"
                value={props.name}
                required
                onChange={(event) => {
                  props.setName(event.target.value)
                }}
              />
              <TextField
                className={classes.textField}
                label="Phone Number"
                variant="filled"
                value={props.phoneNumber}
                required
                onChange={(event) => {
                  props.setPhoneNumber(event.target.value)
                }}
              />
            </FormControl>
            <Button
              variant="contained"
              color="secondary"
              className={`${classes.button} ${classes.addButton}`}
              type="submit"
            >
              Add
            </Button>
          </Grid>
        </form>
      </Paper>
    </div>
  )
}

export default RenderAddUserPage;