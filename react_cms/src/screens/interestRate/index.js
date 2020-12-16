import React from 'react';
import {useState, useEffect} from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getInterestRates } from '../../redux/actions/interestRate';
import RenderInterestRatesPage from './interestRates'

export default function InterestRatesPage() {
  const dispatch = useDispatch();
  const interestRatesData = useSelector(state => state.interestRates);
  const { loading, interestRates, total, errors } = interestRatesData;
  
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  
  const handleChangePage = (event, value) => {
    setPage(value);
  }
  
  const handleChangeRowsPerPage = (event) => {
    setPage(0)
    setRowsPerPage(event.target.value)
  }

  useEffect(() => {
    dispatch(getInterestRates(page + 1, rowsPerPage));
  }, [page, rowsPerPage]);

  return (
    loading ? 
      <div>Loading</div> :
    errors ? 
      <div>Err</div> :
      <RenderInterestRatesPage
        total={total}
        interestRates={interestRates}
        page={page}
        rowsPerPage={rowsPerPage}
        handleChangePage={handleChangePage}
        handleChangeRowsPerPage={handleChangeRowsPerPage}
      />
  );
}