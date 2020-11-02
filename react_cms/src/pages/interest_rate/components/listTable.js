import React from 'react';
import {useState, useEffect, useCallback} from 'react';
import Button from '@material-ui/core/Button';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import TablePagination from '@material-ui/core/TablePagination';
import Paper from '@material-ui/core/Paper';
import { makeStyles } from '@material-ui/core/styles';
import { useHistory } from "react-router-dom";
import Settings from '../../../settings';

const headers = [
  {
    "value": "Id",
    "field": "id",
    "align": "right"
  },
  {
    "value": "Type",
    "field": "type_text",
    "align": "left"
  },
  {
    "value": "Interest Rate",
    "field": "rate"
  },
  {
    "value": "Action",
    "align": "center"
  }
]

const useStyles = makeStyles((theme) => ({
  root: {
  
  },
  paper: {
    margin: theme.spacing(2),
  },
  table: {
    minWidth: 650,
  },
  textField: {
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1),
    width: '25ch',
  },
  button: {
    margin: theme.spacing(1)
  }
}));

export default function ListTable(props) {
  const classes = useStyles();
  const history = useHistory();
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [data, setData] = useState({
    total: 0,
    data: []  
  });
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(5);

  const handleActionClick = (data) => {
    props.setUpdateData(data);
    props.setOpenModal(true);
  }

  const handleChangePage = (event, value) => {
    setPage(value)
  };

  const handleChangeRowsPerPage = (event) => {
    console.log(event.target.value);
    setPage(0)
    setRowsPerPage(event.target.value)
  }

  const handleBankAccountClick = (userId) => {
    history.push({
      pathname: '/bank-account',
      state: { userId: userId }
    })
  }

  const fetchData = useCallback(() => {
    fetch(Settings.API_URL + `interest-rate?page=${page + 1}&limit=${rowsPerPage}`)
      .then(res => res.json())
      .then(
        (result) => {
          setIsLoaded(true);
          setData(result);
          console.log(result.data);

        },
        // Note: it's important to handle errors here
        // instead of a catch() block so that we don't swallow
        // exceptions from actual bugs in components.
        (error) => {
          setIsLoaded(true);
          setError(error);
        }
      )
  }, [page, rowsPerPage]);

  useEffect(() => {
    fetchData();
  }, [fetchData])

  return (
    <div className={classes.root}>
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
              {data.data.map((row, rowIdx) => (
                <TableRow key={rowIdx}>
                  {headers.map((header, idx) =>
                    header.field && <TableCell
                      key={idx}
                      align={header.align ? header.align : "right"}
                    >
                      {row[header.field]}
                    </TableCell>
                  )}
                  
                  <TableCell
                    align="center"
                  >
                    <Button
                      variant="contained"
                      onClick={() => handleActionClick(row)}
                      color='default' 
                      className={classes.button}
                    >
                      Update
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
            count={data.total}
            rowsPerPage={rowsPerPage}
            page={page}
            onChangePage={handleChangePage}
            onChangeRowsPerPage={handleChangeRowsPerPage}
        />
      </Paper>
    </div>
  );
}