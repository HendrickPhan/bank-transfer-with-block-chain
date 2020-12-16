import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getBlockchainBlocks } from '../../../redux/actions/blockchainBlock';
import RenderPage from './render';
import { useHistory, useParams } from "react-router-dom";

export default function BlockchainBlocksPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const data = useSelector(state => state.blockchainBlock);
  const { loading, blocks, total, errors } = data;

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
      pathname: `/blockchain/blocks/${blockId}`,
    })
  }

  const fetchData =  ()  => {
    dispatch(
      getBlockchainBlocks(
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
      blocks={blocks}
      page={page}
      rowsPerPage={rowsPerPage}
      handleChangePage={handleChangePage}
      handleChangeRowsPerPage={handleChangeRowsPerPage}
      handleDetailClick={handleDetailClick}
    />
  );
}