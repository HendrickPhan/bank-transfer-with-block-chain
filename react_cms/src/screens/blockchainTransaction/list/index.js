import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getBlockchainTransactions } from '../../../redux/actions/blockchainTransaction';
import RenderPage from './render';
import { useHistory, useParams } from "react-router-dom";

export default function BlockchainTransactionsPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const data = useSelector(state => state.blockchainTransaction);
  const { loading, transactions, total, errors } = data;

  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  const handleChangePage = (event, value) => {
    setPage(value);
  }

  const handleChangeRowsPerPage = (event) => {
    setPage(0)
    setRowsPerPage(event.target.value)
  }

  const handleDetailClick = (transactionId) => {
    history.push({
      pathname: `/blockchain/transactions/${transactionId}`,
    })
  }

  const fetchData =  ()  => {
    dispatch(
      getBlockchainTransactions(
        page + 1, 
        rowsPerPage      
      )
    );
  }

  useEffect(() => {
    fetchData();
  }, [
    page, 
    rowsPerPage
  ]);

  return (
    <RenderPage
      total={total}
      transactions={transactions}
      page={page}
      rowsPerPage={rowsPerPage}
      handleChangePage={handleChangePage}
      handleChangeRowsPerPage={handleChangeRowsPerPage}
      handleDetailClick={handleDetailClick}
    />
  );
}