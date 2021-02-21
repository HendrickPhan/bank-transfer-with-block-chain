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
import QRCode from 'qrcode.react';

import useStyles from "./styles";

const RenderPage = (props) => {
  const classes = useStyles();

  return (
    <div className={classes.root}>
      <Breadcrumbs aria-label="breadcrumb" className={classes.paper}>
        <Link color="inherit" href="/bills" onClick={null}>
          Bills
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
        <Grid
          className={classes.filter}
          direction="column"
          alignItems="center"
          justify="center"
        >
          {props.bill && <QRCode value={"bill|" +  props.bill.id} />}
          <FormControl
            variant="filled"
            className={classes.textField}
          >
            <TextField
              className={classes.textField}
              label="Id"
              variant="filled"
              value={props.bill ? props.bill.id : ''}
              disabled
            />
            <TextField
              className={classes.textField}
              label="User id"
              variant="filled"
              value={props.bill ? props.bill.user_id : ''}
              disabled
            />
            <TextField
              className={classes.textField}
              label="Type"
              variant="filled"
              value={props.bill ? props.bill.type_text : ''}
              disabled
            />
            <TextField
              className={classes.textField}
              label="Amount"
              variant="filled"
              value={props.bill ? props.bill.amount : ''}
              disabled
            />
            <TextField
              className={classes.textField}
              label="Time"
              variant="filled"
              value={props.bill ? props.bill.time : ''}
              disabled
            />
            <TextField
              className={classes.textField}
              label="Status"
              variant="filled"
              value={props.bill ? (props.bill.status ? "PAID" : "UNPAID") : ''}
              disabled
            />
            <TextField
              className={classes.textField}
              label="Paid at"
              variant="filled"
              value={props.bill ? props.bill.paid_at : ''}
              disabled
            />
          </FormControl>
        </Grid>
      </Paper>
    </div>
  )
}

export default RenderPage;