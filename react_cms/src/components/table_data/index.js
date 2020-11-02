import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import TablePagination from '@material-ui/core/TablePagination';
import Paper from '@material-ui/core/Paper';
import { useHistory } from "react-router-dom";


const useStyles = makeStyles((theme) => ({
  paper: {
    margin: theme.spacing(2),
  },
  table: {
    minWidth: 650,
  },
}));

export default function TableData(props) {
  const classes = useStyles();
  const history = useHistory();

  const handleActionClick = (route, data) => {
    history.push(route, data);
  }

  return (
    <div className={classes.root}>
      <Paper className={classes.paper}>
        <TableContainer component={Paper}>
          <Table className={classes.table}>
            <TableHead>
              <TableRow>
                {
                  props.headers.map((header, idx) =>
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
              {props.rows.map((row, rowIdx) => (
                <TableRow key={rowIdx}>
                  {row.map((data, dataIdx) => (
                    <TableCell
                      key={dataIdx}
                      align={data.align ? data.align: "right"}
                    >
                      {data.value}
                    </TableCell>
                  ))}
                  {
                    props.actions && 
                    <TableCell
                      align="center"
                    >
                      {
                        props.actions.map((action, idx) => 
                          <Button
                          variant="contained"
                          onClick={() => handleActionClick(action.path, {id: row[0]})}
                          color={action.color ? action.color : 'default'} 
                          style={{minWidth: '150px'}}
                        >
                          {action.title}
                        </Button>
                        )
                      }
                    </TableCell> 
                  }
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </TableContainer>
        {
          props.pagination && <TablePagination
            rowsPerPageOptions={[10, 20, 50]}
            component="div"
            count={props.count}
            rowsPerPage={props.rowsPerPage}
            page={props.page}
            onChangePage={props.handleChangePage}
            onChangeRowsPerPage={props.handleChangeRowsPerPage}
          />
        }
      </Paper>
    </div>
  );
}