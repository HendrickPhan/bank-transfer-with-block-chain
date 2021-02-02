import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getBankAccount } from '../../../redux/actions/bankAccount';
import RenderPage from './render';
import { useParams } from "react-router-dom";

export default function BankAccountDetailPage() {
  const dispatch = useDispatch();
  
  const data = useSelector(state => state.bankAccount);
  const { loading, bankAccount, errors } = data;
  console.log(loading, bankAccount, errors)
  let { accountNumber } = useParams();

  const fetchData =  ()  => {
    console.log("debug 1");
    dispatch(
      getBankAccount(accountNumber)
    );
  }

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <RenderPage
      bankAccount={bankAccount}
      errors={errors}
    />
  );
}