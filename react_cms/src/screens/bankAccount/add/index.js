import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { addBankAccount, clearBankAccount } from '../../../redux/actions/bankAccount';
import RenderAddBankAccountPage from './render';
import { useHistory, useParams } from "react-router-dom";

export default function AddBankAccountPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const addBankAccountData = useSelector(state => state.addBankAccount);
  const { loading, bankAccount, errors } = addBankAccountData;

  const [type, setType] = useState('');

  let { userId } = useParams();

  const handleSubmit = (e) => {
    e.preventDefault();
    dispatch(
      addBankAccount(
        userId,
        type      
      )
    );
    
    setTimeout(
      () => {
        dispatch(
          clearBankAccount()
        );
      }, 5000  
    )
  }

  const handleClearBankAccount = () => {
    dispatch(
      clearBankAccount()
    );
  }

  return (
    <RenderAddBankAccountPage
      type={type}
      setType={setType}
      handleSubmit={handleSubmit}
      bankAccount={bankAccount}
      handleClearBankAccount={handleClearBankAccount}
    />
  );
}