import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { addBill, clearAddBillResult } from '../../../redux/actions/bill';
import RenderAddBillPage from './render';
import { useHistory, useParams } from "react-router-dom";

export default function AddBillPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const addBillData = useSelector(state => state.addBill);
  const { loading, bill, errors } = addBillData;

  const [phoneNumber, setPhoneNumber] = useState('');
  const [type, setType] = useState('');
  const [amount, setAmount] = useState('');
  const [time, setTime] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    dispatch(
      addBill(
        phoneNumber, 
        type, 
        amount, 
        time
      )
    );
    setPhoneNumber('');
    setType('');
    setAmount('');
    setTime('');
  }

  const handleClearBill = () => {
    dispatch(
      clearAddBillResult()
    );
  }

  return (
    <RenderAddBillPage
      phoneNumber={phoneNumber}
      setPhoneNumber={setPhoneNumber}
      type={type}
      setType={setType}
      amount={amount}
      setAmount={setAmount}
      time={time}
      setTime={setTime}
      handleSubmit={handleSubmit}
      handleClearBill={handleClearBill}
      bill={bill}
      errors={errors}
    />
  );
}