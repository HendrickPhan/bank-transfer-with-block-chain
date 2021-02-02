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
  const classes = useStyles();

  return (
    <div className={classes.root}>
        <Breadcrumbs aria-label="breadcrumb" className={classes.paper}>
          <Link color="inherit" href={`/users`} onClick={null}>
            Users
          </Link>
        <Typography color="inherit">Bank Account</Typography>
        <Typography color="textPrimary">Detail</Typography>
      </Breadcrumbs>

      <Paper className={classes.paper}>
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
              InputLabelProps={{ shrink: true }}  
              className={classes.textField}
              label="Account Number"
              variant="filled"
              value={props.bankAccount ? props.bankAccount.account_number : ''}
              required
              disabled
            />
            <TextField
              InputLabelProps={{ shrink: true }}  
                className={classes.textField}
                label="Type"
                variant="filled"
                value={props.bankAccount ? props.bankAccount.type_text : ''}
                required
                disabled
            />
            <TextField
              InputLabelProps={{ shrink: true }}  
              className={classes.textField}
              label="Amount"
              variant="filled"
              value={props.bankAccount ? props.bankAccount.amount : ''}
              required
              disabled
            />
            <TextField
              InputLabelProps={{ shrink: true }}  
              className={classes.textField}
              label="Interest Rate"
              variant="filled"
              value={props.bankAccount ? props.bankAccount.interest_rate : ''}
              required
              disabled
            />
            <TextField
              InputLabelProps={{ shrink: true }}  
              className={classes.textField}
              label="Status"
              variant="filled"
              value={props.bankAccount ? props.bankAccount.status_text : ''}
              multiline
              required
              disabled
            />
            <TextField
              InputLabelProps={{ shrink: true }}  
              className={classes.textField}
              label="Created at"
              variant="filled"
              value={props.bankAccount ? props.bankAccount.created_at : ''}
              required
              disabled
            />
            <TextField
              InputLabelProps={{ shrink: true }}  
              className={classes.textField}
              label="Due Date"
              variant="filled"
              value={props.bankAccount ? props.bankAccount.date : ''}
              required
              disabled
            />
            <TextField
              InputLabelProps={{ shrink: true }}  
              className={classes.textField}
              label="Interest"
              variant="filled"
              value={props.bankAccount ? props.bankAccount.interest : ''}
              required
              disabled
            />
          </FormControl>

        </Grid>
      </Paper>
    </div>
  )
}

export default RenderPage;