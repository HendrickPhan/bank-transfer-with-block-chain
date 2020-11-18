import React from 'react';
import { useState, useEffect, useRef } from 'react';
import Button from '@material-ui/core/Button';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import TablePagination from '@material-ui/core/TablePagination';
import Paper from '@material-ui/core/Paper';
import TextField from '@material-ui/core/TextField';
import Grid from '@material-ui/core/Grid';
import MenuItem from '@material-ui/core/MenuItem';
import FormControl from '@material-ui/core/FormControl';
import InputLabel from '@material-ui/core/InputLabel';
import Select from '@material-ui/core/Select';

import useStyles from "./styles";

const headers = [
  {
    "value": "Code",
    "field": "code",
    "align": "left"
  },
  {
    "value": "From Account",
    "field": "from_account",
    "align": "left"
  },
  {
    "value": "To Account",
    "field": "to_account",
    "align": "left"
  },
  {
    "value": "Amount",
    "field": "amount",
    "align": "right"
  },
  {
    "value": "Type",
    "field": "type_text",
    "align": "left"
  },
  {
    "value": "Status",
    "field": "status_text"
  },
  {
    "value": "Action",
    "align": "center"
  }
]

const RenderTransactionsPage = (props) => {
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
              label="From Account"
              variant="filled"
              value={props.filterFromAccount}
              onChange={(event) => {
                props.setFilterFromAccount(event.target.value);
              }}
            />
            <TextField
              className={classes.textField}
              label="To Account"
              variant="filled"
              value={props.filterToAccount}
              onChange={(event) => {
                props.setFilterToAccount(event.target.value)
              }}
            />
            <FormControl variant="filled" className={classes.textField}>
              <InputLabel id="type-filter-label">Type</InputLabel>
              <Select
                labelId="type-filter-label"
                id="type-filter"
                value={props.filterType}
                onChange={(event) => {
                  props.setFilterType(event.target.value);
                }}
              >
                <MenuItem value=''>
                  <em>None</em>
                </MenuItem>
                <MenuItem value={0}>Transfer</MenuItem>
                <MenuItem value={1}>Cash In</MenuItem>
                <MenuItem value={2}>Cash Out</MenuItem>
              </Select>
            </FormControl>
            <FormControl variant="filled" className={classes.textField}>
              <InputLabel id="status-filter-label">Status</InputLabel>
              <Select
                labelId="status-filter-label"
                id="status-filter"
                value={props.filterStatus}
                onChange={(event) => {
                  props.setFilterStatus(event.target.value);
                }}
              >
                <MenuItem value=''>
                  <em>None</em>
                </MenuItem>
                <MenuItem value={0}>Pending</MenuItem>
                <MenuItem value={1}>Confirmed</MenuItem>
              </Select>
            </FormControl>

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
              {props.transactions.map((transaction, rowIdx) => (
                <TableRow key={transaction.id}>
                  {headers.map((header, idx) =>
                    header.field && <TableCell
                      key={idx}
                      align={header.align ? header.align : "right"}
                    >
                      {transaction[header.field]}
                    </TableCell>
                  )}

                  <TableCell
                    align="center"
                  >
                    <Button
                      variant="outlined"
                      // onClick={() => handleActionClick(action.path, {id: data[0]})}
                      color='primary'
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

export default RenderTransactionsPage;