import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getBill } from '../../../redux/actions/bill';
import RenderPage from './render';
import { useParams } from "react-router-dom";

export default function BillDetailPage() {
  const dispatch = useDispatch();
  
  const data = useSelector(state => state.bill);
  const { loading, bill, errors } = data;
  
  let { billId } = useParams();

  const fetchData =  ()  => {
    dispatch(
      getBill(billId)
    );
  }

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <RenderPage
      bill={bill}
      errors={errors}
    />
  );
}