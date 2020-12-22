import React from 'react';
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';
import Alert from '@material-ui/lab/Alert';
import TextField from '@material-ui/core/TextField';
import Grid from '@material-ui/core/Grid';
import FormControl from '@material-ui/core/FormControl';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import { Breadcrumbs, Link, Typography } from '@material-ui/core';
import useStyles from "./styles";

const RenderPage = (props) => {
  console.log(props)
  const classes = useStyles();

  return (
    <div className={classes.root}>
      <Breadcrumbs aria-label="breadcrumb" className={classes.paper}>
        <Link color="inherit" href="/interest-rates" onClick={null}>
          Interest Rate
        </Link>
        <Typography color="textPrimary">Detail</Typography>
      </Breadcrumbs>

      <Paper className={classes.paper}>
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
                label="Type"
                variant="filled"
                value={props.interestRate ? props.interestRate.type_text : ''}
                required
                disabled
              />
              <TextField
                className={classes.textField}
                label="Rate"
                variant="filled"
                value={props.rate ? props.rate : ''}
                onChange={(event) => {
                  props.setRate(event.target.value)
                }}
                required
              />
            </FormControl>
            <Button
              variant="contained"
              color="secondary"
              className={`${classes.button} ${classes.addButton}`}
              type="submit"
            >
              Update
            </Button>
          </Grid>
        </form>
      </Paper>
    </div>
  )
}

export default RenderPage;