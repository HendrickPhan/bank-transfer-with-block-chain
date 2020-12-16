import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getStatistic } from '../../redux/actions/statistic';
import RenderStatistic from './statistic';
import { useHistory, useParams } from "react-router-dom";
import { getDateString } from "../../ultilities/dateFormat";

export default function StatisticPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const statisticData = useSelector(state => state.statistic);
  const { loading, daily, monthly, errors } = statisticData;
  
  const [initalled, setInitalled] = useState(false);
  const [fromDate, setFromDate] = useState();
  const [toDate, setToDate] = useState();
  
  const fetchData =  ()  => {
    dispatch(
      getStatistic(
        fromDate,
        toDate 
      )
    );
  }

  useEffect(() => {
    if(!initalled) {
      let today = getDateString(new Date());
      let defaultFromDate = new Date();
      defaultFromDate.setDate( 
        defaultFromDate.getDate() - 7 
      );
      defaultFromDate = getDateString(defaultFromDate);
      setFromDate(defaultFromDate)
      setToDate(today)
      setInitalled(true);
    }
  }, []);

  useEffect(() => {
    fetchData();
  }, [
    fromDate, 
    toDate
  ]);

  return (
    <RenderStatistic
      fromDate={fromDate}
      setFromDate={setFromDate}
      toDate={toDate}
      setToDate={setToDate}
      daily={daily}
      monthly={monthly}
    />
  );
}