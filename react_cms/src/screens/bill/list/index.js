import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getBills } from '../../../redux/actions/bill';
import RenderPage from './render';
import { useHistory, useParams } from "react-router-dom";

export default function BlockchainBlocksPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const data = useSelector(state => state.bill);
  const { loading, bills, total, errors } = data;

  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);

  const handleChangePage = (event, value) => {
    setPage(value);
  }

  const handleChangeRowsPerPage = (event) => {
    setPage(0)
    setRowsPerPage(event.target.value)
  }

  const handleDetailClick = (blockId) => {
    history.push({
      pathname: `/bill/${blockId}`,
    })
  }

  const handleAddMoreClick = () => {
    history.push({
      pathname: `/bills/add`,
    })
  }

  const fetchData =  ()  => {
    dispatch(
      getBills(
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
    <RenderPage
      total={total}
      bills={bills}
      page={page}
      rowsPerPage={rowsPerPage}
      handleChangePage={handleChangePage}
      handleChangeRowsPerPage={handleChangeRowsPerPage}
      handleDetailClick={handleDetailClick}
      handleAddMoreClick={handleAddMoreClick}
    />
  );
}