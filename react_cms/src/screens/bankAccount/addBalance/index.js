import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { 
  addBankAccountBalance, 
  clearAddBankAccountBalanceResult 
} from '../../../redux/actions/bankAccount';
import RenderAddBankAccountBalancePage from './render';
import { useHistory, useParams } from "react-router-dom";

export default function AddBankAccountBalancePage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const addBankAccountBalanceData = useSelector(state => state.addBankAccountBalance);
  const { loading, added, errors } = addBankAccountBalanceData;

  const [amount, setAmount] = useState('');

  let { accountNumber } = useParams();

  const handleBack = (e) => {
    e.preventDefault();
    history.goBack();
  }

  const handleSubmit = (e) => {
    e.preventDefault();
    dispatch(
      addBankAccountBalance(
        amount, 
        accountNumber
      )
    );
    
    setTimeout(
      () => {
        dispatch(
          clearAddBankAccountBalanceResult()
        );
      }, 5000  
    )
  }

  const handleClear = () => {
    dispatch(
      clearAddBankAccountBalanceResult()
    );
  }

  return (
    <RenderAddBankAccountBalancePage
      amount={amount}
      setAmount={setAmount}
      handleSubmit={handleSubmit}
      added={added}
      handleBack={handleBack}
      handleClear={handleClear}
      errors={errors}
    />
  );
}