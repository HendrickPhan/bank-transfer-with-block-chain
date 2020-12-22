import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getInterestRate, updateInterestRate } from '../../../redux/actions/interestRate';
import RenderPage from './render';
import { useParams } from "react-router-dom";

export default function InterestRateDetailPage() {
  const dispatch = useDispatch();
  
  const data = useSelector(state => state.interestRates);
  const { loading, interestRate, errors } = data;
  const [rate, setRate] = useState(0);

  let { interestRateId } = useParams();

  const fetchData =  ()  => {
    dispatch(
      getInterestRate(interestRateId)
    );
  }

  const handleSubmit = (e) => {
    e.preventDefault();
    dispatch(
      updateInterestRate(interestRateId, {rate})
    );
  }

  useEffect(() => {
    fetchData();
  }, []);

  useEffect(() => {
    setRate(interestRate?.rate)  
  }, [data]);
  
  return (
    <RenderPage
      interestRate={interestRate}
      errors={errors}
      rate={rate}
      setRate={setRate}
      handleSubmit={handleSubmit}
    />
  );
}