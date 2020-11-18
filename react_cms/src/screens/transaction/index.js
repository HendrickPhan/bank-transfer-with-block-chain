import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getTransactions } from '../../redux/actions/transaction';
import RenderTransactionsPage from './transactions';
import { useHistory, useParams } from "react-router-dom";

export default function TransactionPage() {
  const dispatch = useDispatch();
  const transactionsData = useSelector(state => state.transactions);
  const { loading, transactions, total, errors } = transactionsData;

  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  let { accountNumber } = useParams();
  const [initalled, setInitalled] = useState(false);
  const [filterFromAccount, setFilterFromAccount] = useState('');
  const [filterToAccount, setFilterToAccount] = useState('');
  const [filterType, setFilterType] = useState('');
  const [filterStatus, setFilterStatus] = useState('');  

  const fetchDataTimeOut = useRef();

  const handleChangePage = (event, value) => {
    setPage(value);
  }

  const handleChangeRowsPerPage = (event) => {
    setPage(0)
    setRowsPerPage(event.target.value)
  }
  
  const fetchData =  ()  => {
    dispatch(
      getTransactions(
        page + 1, 
        rowsPerPage,
        {
          account_number: accountNumber ? accountNumber : null,
          from_account: filterFromAccount ? filterFromAccount : null,
          to_account: filterToAccount ? filterToAccount : null,
          type: filterType ? filterType : null,
          status: filterStatus ? filterStatus : null,
        }
      ));
  }

  useEffect(() => {
    fetchData();
    setInitalled(true);
  }, [
    page, 
    rowsPerPage,
    filterType,
    filterStatus
  ]);

  useEffect(() => {
    if(initalled) {
      clearTimeout(fetchDataTimeOut.current);
      fetchDataTimeOut.current = setTimeout(fetchData, 500);
    }
  }, [
    filterFromAccount,
    filterToAccount
  ]);

  return (
    // loading ?
    //   <div>Loading</div> :
    //   errors ?
    //     <div>Err</div> :
        <RenderTransactionsPage
          total={total}
          transactions={transactions}
          page={page}
          rowsPerPage={rowsPerPage}
          handleChangePage={handleChangePage}
          handleChangeRowsPerPage={handleChangeRowsPerPage}
          filterFromAccount={filterFromAccount}
          filterToAccount={filterToAccount}
          filterType={filterType}
          filterStatus={filterStatus}
          setFilterFromAccount={setFilterFromAccount}
          setFilterToAccount={setFilterToAccount}
          setFilterType={setFilterType}
          setFilterStatus={setFilterStatus}
        />
  );
}