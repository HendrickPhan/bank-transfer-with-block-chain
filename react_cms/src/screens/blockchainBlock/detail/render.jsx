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
        <Link color="inherit" href="/blockchain/blocks" onClick={null}>
          Block Chain Block
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
          <FormControl
            variant="filled"
            className={classes.textField}
          >
            <TextField
              className={classes.textField}
              label="Number"
              variant="filled"
              value={props.block ? props.block.number : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Hash"
              variant="filled"
              value={props.block ? props.block.hash : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Parent Hash"
              variant="filled"
              value={props.block ? props.block.parentHash : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Difficulty"
              variant="filled"
              value={props.block ? props.block.difficulty : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Time Stamp"
              variant="filled"
              value={props.block ? props.block.timestamp : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Extra Data"
              variant="filled"
              value={props.block ? props.block.extraData : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Logs Bloom"
              multiline
              variant="filled"
              value={props.block ? props.block.logsBloom : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Nonce"
              variant="filled"
              value={props.block ? props.block.nonce : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Receipts Root"
              variant="filled"
              value={props.block ? props.block.receiptsRoot : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Size"
              variant="filled"
              value={props.block ? props.block.size : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="State Root"
              variant="filled"
              value={props.block ? props.block.stateRoot : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Total Difficulty"
              variant="filled"
              value={props.block ? props.block.totalDifficulty : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Gas Limit"
              variant="filled"
              value={props.block ? props.block.gasLimit : ''}
              required
              disabled
            />
            <TextField
              className={classes.textField}
              label="Gas Used"
              variant="filled"
              value={props.block ? props.block.gasUsed : ''}
              required
              disabled
            />
          </FormControl>

          <Typography
            variant="h4"
          >Transactions</Typography>
          <TableContainer component={Paper}>
            <Table className={classes.table}>
              <TableHead>
                <TableRow>
                  <TableCell
                    align={"center"}
                  >
                    Id
                </TableCell>
                  <TableCell
                    align={"center"}
                  >
                    Hash
                </TableCell>
                  <TableCell
                    align={"center"}
                  >
                    Action
                </TableCell>
                </TableRow>
              </TableHead>

              <TableBody>
                {props.block && props.block.transactions.map((row, rowIdx) => (
                  <TableRow key={rowIdx}>
                    <TableCell
                      align={"center"}
                    >
                      {row['id']}
                    </TableCell>
                    <TableCell
                      align={"center"}
                    >
                      {row['hash']}
                    </TableCell>
                    <TableCell
                      align="center"
                    >
                      <Button
                        variant="outlined"
                        onClick={() => props.handleDetailClick(row['id'])}
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

        </Grid>
      </Paper>
    </div>
  )
}

export default RenderPage;