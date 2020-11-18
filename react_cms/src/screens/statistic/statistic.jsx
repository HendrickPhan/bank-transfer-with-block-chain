import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { Line } from "react-chartjs-2";
import Paper from '@material-ui/core/Paper';
import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import DateFnsUtils from '@date-io/date-fns';
import {
  MuiPickersUtilsProvider,
  DatePicker
} from '@material-ui/pickers';
import useStyles from "./styles";

const options = {
  scales: {
    yAxes: [
      {
        ticks: {
          beginAtZero: true,
        },
      },
    ],
  },
}

const RenderBankAccountsPage = (props) => {
  const classes = useStyles();
  
  let data = {
    labels: [],
    datasets: [
      {
        label: 'Total Cash In Amount',
        data: [],
        fill: false,
        backgroundColor: 'rgb(255, 99, 132)',
        borderColor: 'rgba(255, 99, 132, 0.2)',
      },
      {
        label: 'Total Cash Out Amount',
        data: [],
        fill: false,
        backgroundColor: 'rgb(99, 99, 132)',
        borderColor: 'rgba(99, 99, 132, 0.2)',
      },
      {
        label: 'Total Transfer Amount',
        data: [],
        fill: false,
        backgroundColor: 'rgb(132, 50, 132)',
        borderColor: 'rgba(132, 50, 132, 0.2)',
      },
      {
        label: 'Total Pending Amount',
        data: [],
        fill: false,
        backgroundColor: 'rgb(99, 99, 50)',
        borderColor: 'rgba(99, 99, 50, 0.2)',
      }
    ]
  }
  props.daily.map((value, index) => {
    data.labels.push(value.date)
    data.datasets[0].data.push(value.total_cash_in_amount)
    data.datasets[1].data.push(value.total_cash_out_amount)
    data.datasets[2].data.push(value.total_transfer_amount)
    data.datasets[3].data.push(value.total_pending_amount)
    return;
  })

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
            <MuiPickersUtilsProvider utils={DateFnsUtils}>
              <DatePicker
                className={classes.textField}
                disableToolbar
                variant="inline"
                format="yyyy/MM/dd"
                margin="normal"
                id="from-date"
                label="From Date"
                value={props.fromDate}
                onChange={(value) => {
                  props.setFromDate(value);
                }}
                KeyboardButtonProps={{
                  'aria-label': 'change date',
                }}
              />
              <DatePicker
                className={classes.textField}
                disableToolbar
                variant="inline"
                format="yyyy/MM/dd"
                margin="normal"
                id="to-date"
                label="To Date"
                value={props.toDate}
                onChange={(value) => {
                  props.setToDate(value);
                }}
                KeyboardButtonProps={{
                  'aria-label': 'change date',
                }}
              />
              
            </MuiPickersUtilsProvider>
          </Grid>
        </form>
      </Paper>
      <Paper className={classes.paper}>
        <Line data={data} options={options} />
      </Paper>
    </div>
  )
}

export default RenderBankAccountsPage;