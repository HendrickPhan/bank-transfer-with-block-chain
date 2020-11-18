import React from 'react';
import { useState, useEffect, useRef } from 'react';
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';
import Alert from '@material-ui/lab/Alert';
import TextField from '@material-ui/core/TextField';
import Grid from '@material-ui/core/Grid';
import MenuItem from '@material-ui/core/MenuItem';
import FormControl from '@material-ui/core/FormControl';
import InputLabel from '@material-ui/core/InputLabel';
import Select from '@material-ui/core/Select';

import useStyles from "./styles";

const RenderAddBankAccountBalancePage = (props) => {
  const classes = useStyles();

  return (
    <div className={classes.root}>
      <Paper className={classes.paper}>
      {props.added &&
        <Alert 
          severity="success"
          onClose={() => {
            props.handleClear()
          }}
        >
          Added Bank Account balance success.
        </Alert>
      }
      {(Object.keys(props.errors).length > 0) &&
        <Alert 
          severity="error"
          onClose={() => {
            props.handleClear()
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
                label="Amount"
                type="number"
                variant="filled"
                value={props.amount}
                required
                onChange={(event) => {
                  props.setAmount(event.target.value)
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

export default RenderAddBankAccountBalancePage;