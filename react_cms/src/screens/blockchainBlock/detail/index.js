import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getBlockchainBlock } from '../../../redux/actions/blockchainBlock';
import RenderPage from './render';
import { useParams } from "react-router-dom";

export default function BlockchainBlockDetailPage() {
  const dispatch = useDispatch();
  
  const data = useSelector(state => state.blockchainBlock);
  const { loading, block, errors } = data;
  
  let { blockId } = useParams();

  const fetchData =  ()  => {
    dispatch(
      getBlockchainBlock(blockId)
    );
  }

  useEffect(() => {
    fetchData();
  }, []);

  return (
    <RenderPage
      block={block}
      errors={errors}
    />
  );
}