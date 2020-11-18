import React from 'react';
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';
import Alert from '@material-ui/lab/Alert';
import TextField from '@material-ui/core/TextField';
import Grid from '@material-ui/core/Grid';
import FormControl from '@material-ui/core/FormControl';

import useStyles from "./styles";

const RenderSettingDetailPage = (props) => {
  const classes = useStyles();

  return (
    <div className={classes.root}>
      <Paper className={classes.paper}>
      {(props.updated) &&
        <Alert 
          severity="success"
          onClose={props.handleClearResult}
        >
          Update Setting success.
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
                label="Key"
                variant="filled"
                value={props.keyProp}
                disabled
              />
              <TextField
                className={classes.textField}
                label="Value"
                variant="filled"
                value={props.value}
                required
                onChange={(event) => {
                  props.setValue(event.target.value)
                }}
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

export default RenderSettingDetailPage;