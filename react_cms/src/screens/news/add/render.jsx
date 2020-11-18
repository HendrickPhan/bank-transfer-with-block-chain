import React from 'react';
import Button from '@material-ui/core/Button';
import Paper from '@material-ui/core/Paper';
import Alert from '@material-ui/lab/Alert';
import TextField from '@material-ui/core/TextField';
import Grid from '@material-ui/core/Grid';
import FormControl from '@material-ui/core/FormControl';
import Typography from '@material-ui/core/Typography';
import { Editor } from 'react-draft-wysiwyg';
import 'react-draft-wysiwyg/dist/react-draft-wysiwyg.css';
import useStyles from "./styles";

const RenderAddNewsPage = (props) => {
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
        {props.news &&
          <Alert
            severity="success"
            onClose={() => {
              props.handleClearNews()
            }}
          >
            Added News success!
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
                label="title"
                variant="filled"
                value={props.title}
                required
                onChange={(event) => {
                  props.setTitle(event.target.value)
                }}
              />
              <Paper className={classes.editorPaper}>
                <Typography variant="subtitle">
                  Body:
                </Typography>
                <Editor
                  id="editor"
                  editorState={props.editorState}
                  toolbarClassName="toolbarClassName"
                  wrapperClassName="wrapperClassName"
                  editorClassName="editorClassName"
                  onEditorStateChange={props.setEditorState}
                />
              </Paper>
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

export default RenderAddNewsPage;