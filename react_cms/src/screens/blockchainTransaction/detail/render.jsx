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
import Typography from '@material-ui/core/Typography';
import useStyles from "./styles";

const RenderPage = (props) => {
  const classes = useStyles();

  return (
    <div className={classes.root}>
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
          <FormControl
            variant="filled"
            className={classes.textField}
          >
            <TextField
              className={classes.textField}
              label="Block Hash"
              variant="filled"
              value={props.transaction ? props.transaction.blockHash : ''}
              required
              disabled
            />
            <TextField
                className={classes.textField}
                label="Block Number"
                variant="filled"
                value={props.transaction ? props.transaction.blockNumber : ''}
                required
                disabled
            />
            <TextField
              className={classes.textField}
              label="From"
              variant="filled"
              value={props.transaction ? props.transaction.from : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Hash"
              variant="filled"
              value={props.transaction ? props.transaction.hash : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Input"
              variant="filled"
              value={props.transaction ? props.transaction.input : ''}
              multiline
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Nonce"
              variant="filled"
              value={props.transaction ? props.transaction.nonce : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="To"
              variant="filled"
              value={props.transaction ? props.transaction.to : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Value"
              variant="filled"
              value={props.transaction ? props.transaction.value : ''}
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