import React from 'react';
import Button from '@material-ui/core/Button';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import TablePagination from '@material-ui/core/TablePagination';
import Paper from '@material-ui/core/Paper';
import AddIcon from '@material-ui/icons/Add';
import Fab from '@material-ui/core/Fab';
import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import useStyles from "./styles";

const headers = [
  {
    "value": "Id",
    "field": "id",
    "align": "left"
  },
  {
    "value": "Key",
    "field": "key",
    "align": "left"
  },
  {
    "value": "Value",
    "field": "value",
    "align": "left"
  },
  {
    "value": "Action",
    "align": "center"
  }
]

const RenderSettingsPage = (props) => {
  const classes = useStyles();
  
  return (
    <div className={classes.root}>
      <Paper className={classes.paper}>
        <form autoComplete="off">
          <Grid
            className={classes.filter}
            spacing={0}
            alignItems="center"
            justify="center"
          >
            <TextField
              className={classes.textField}
              label="Search Keyword"
              variant="filled"
              value={props.filterKeyword}
              onChange={(event) => {
                props.setFilterKeyword(event.target.value);
              }}
            />
          </Grid>
        </form>
      </Paper>
      <Paper className={classes.paper}>
        <TableContainer component={Paper}>
          <Table className={classes.table}>
            <TableHead>
              <TableRow>
                {
                  headers.map((header, idx) =>
                    <TableCell
                      key={idx}
                      align={header.align ? header.align : "right"}
                    >
                      {header.value}
                    </TableCell>
                  )
                }
              </TableRow>
            </TableHead>

            <TableBody>
              {props.settings.map((setting, settingIdx) => (
                <TableRow key={setting.id}>
                  {headers.map((header, idx) =>
                    header.field && <TableCell
                      key={idx}
                      align={header.align ? header.align : "right"}
                    >
                      {setting[header.field]}
                    </TableCell>
                  )}

                  <TableCell
                    align="center"
                  >
                    <Button
                      variant="outlined"
                      onClick={() => props.handleDetailClick(setting.id)}
                      color="primary"
                      className={classes.button}
                    >
                      Detail
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>

        <TablePagination
          rowsPerPageOptions={[5, 10, 20]}
          component="div"
          count={props.total}
          rowsPerPage={props.rowsPerPage}
          page={props.page}
          onChangePage={props.handleChangePage}
          onChangeRowsPerPage={props.handleChangeRowsPerPage}
        />
      </Paper>
    </div>
  )
}

export default RenderSettingsPage;