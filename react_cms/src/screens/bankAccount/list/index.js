import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getBankAccounts } from '../../../redux/actions/bankAccount';
import RenderBankAccountsPage from './bankAccounts';
import { useHistory, useParams } from "react-router-dom";

export default function BankAccountsPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const bankAccountsData = useSelector(state => state.bankAccounts);
  const { loading, bankAccounts, total, errors } = bankAccountsData;

  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  let { userId } = useParams();

  const handleChangePage = (event, value) => {
    setPage(value);
  }

  const handleChangeRowsPerPage = (event) => {
    setPage(0)
    setRowsPerPage(event.target.value)
  }
  
  const handleTransactionClick = (accountNumber) => {
    history.push({
      pathname: `/bank-account/${accountNumber}/transactions`,
    })  
  }

  const handleAddBalanceClick = (accountNumber) => {
    history.push({
      pathname: `/bank-account/${accountNumber}/add-balance`,
    })  
  }

  const handleDetailClick = (accountNumber) => {
    history.push({
      pathname: `/bank-account/${accountNumber}/detail`,
    })  
  }

  const handleAddMoreClick = () => {
    history.push({
      pathname: `/user/${userId}/bank-account/add`,
    })
  }

  const fetchData =  ()  => {
    dispatch(
      getBankAccounts(
        userId,
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
    <RenderBankAccountsPage
      total={total}
      userId={userId}
      bankAccounts={bankAccounts}
      page={page}
      rowsPerPage={rowsPerPage}
      handleChangePage={handleChangePage}
      handleChangeRowsPerPage={handleChangeRowsPerPage}
      handleAddMoreClick={handleAddMoreClick}
      handleTransactionClick={handleTransactionClick}
      handleAddBalanceClick={handleAddBalanceClick}
      handleDetailClick={handleDetailClick}
    />
  );
}