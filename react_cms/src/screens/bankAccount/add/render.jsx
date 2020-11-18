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

const RenderAddBankAccountPage = (props) => {
  console.log(props);
  const classes = useStyles();

  return (
    <div className={classes.root}>
      <Paper className={classes.paper}>
      {props.bankAccount &&
        <Alert 
          severity="success"
          onClose={() => {
            props.handleClearBankAccount()
          }}
        >
          Added Bank Account success, number: {props.bankAccount.account_number}
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
              <InputLabel id="type-label">Type</InputLabel>
              <Select
                labelId="type-label"
                id="type"
                value={props.type}
                onChange={(event) => {
                  props.setType(event.target.value);
                }}
              >
                <MenuItem value=''>
                  <em>None</em>
                </MenuItem>
                <MenuItem value={0}>Transfer</MenuItem>
                <MenuItem value={1}>Saving 1 month</MenuItem>
                <MenuItem value={2}>Saving 3 month</MenuItem>
                <MenuItem value={3}>Saving 6 month</MenuItem>
                <MenuItem value={4}>Saving 12 month</MenuItem>
              </Select>
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

export default RenderAddBankAccountPage;