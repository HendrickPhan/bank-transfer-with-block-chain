import React from 'react';
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';
import Alert from '@material-ui/lab/Alert';
import TextField from '@material-ui/core/TextField';
import Grid from '@material-ui/core/Grid';
import FormControl from '@material-ui/core/FormControl';
import { Breadcrumbs, Link, Typography } from '@material-ui/core';
import InputLabel from '@material-ui/core/InputLabel';
import Select from '@material-ui/core/Select';
import MenuItem from '@material-ui/core/MenuItem';

import useStyles from "./styles";

const RenderAddBillPage = (props) => {
  const classes = useStyles();

  return (
    <div className={classes.root}>
      <Breadcrumbs aria-label="breadcrumb" className={classes.paper}>
        <Link color="inherit" href="/bills" onClick={null}>
          Bills
          </Link>
        <Typography color="textPrimary">Add</Typography>
      </Breadcrumbs>

      <Paper className={classes.paper}>
        {(Object.keys(props.bill).length > 0) &&
          <Alert
            severity="success"
            onClose={() => {
              props.handleClearBill()
            }}
          >
            Added Bill success.
        </Alert>
        }
        {(Object.keys(props.errors).length > 0) &&
          <Alert
            severity="error"
            onClose={() => {
              props.handleClearBill()
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
                label="Phone Number"
                variant="filled"
                value={props.phoneNumber}
                required
                onChange={(event) => {
                  props.setPhoneNumber(event.target.value)
                }}
              />
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
                  <MenuItem value={0}>Water</MenuItem>
                  <MenuItem value={1}>Electricity</MenuItem>
                  <MenuItem value={2}>Internet</MenuItem>
                </Select>
              </FormControl>
              
              <TextField
                className={classes.textField}
                label="Amount"
                variant="filled"
                type="number"
                value={props.amount}
                required
                onChange={(event) => {
                  props.setAmount(event.target.value)
                }}
              />

              <TextField
                className={classes.textField}
                label="Time"
                variant="filled"
                type="date"
                value={props.time}
                required
                onChange={(event) => {
                  console.log(event.target.value)
                  props.setTime(event.target.value)
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

export default RenderAddBillPage;