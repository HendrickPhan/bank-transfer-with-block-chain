import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getBlockchainTransaction } from '../../../redux/actions/blockchainTransaction';
import RenderPage from './render';
import { useParams } from "react-router-dom";

export default function BlockchainTransactionDetailPage() {
  const dispatch = useDispatch();
  
  const data = useSelector(state => state.blockchainTransaction);
  const { loading, transaction, errors } = data;
  
  let { transactionId } = useParams();

  const fetchData =  ()  => {
    dispatch(
      getBlockchainTransaction(transactionId)
    );
  }

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <RenderPage
      transaction={transaction}
      errors={errors}
    />
  );
}