import {
  GETTING_BLOCKCHAIN_BLOCKS,
  GET_BLOCKCHAIN_BLOCKS_SUCCESS,
  GET_BLOCKCHAIN_BLOCKS_FAIL,

  GETTING_BLOCKCHAIN_BLOCK,
  GET_BLOCKCHAIN_BLOCK_SUCCESS,
  GET_BLOCKCHAIN_BLOCK_FAIL,
} from '../constants/blockchainBlock';

import { callApi } from "../../ultilities/api"

/**
 * list 
 */
export const getBlockchainBlocks = (page, limit) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_BLOCKCHAIN_BLOCKS});
    let param = {
      page: page, 
      limit: limit
    }

    const data = await callApi("get", `admin/block-chain/block`, param);
    dispatch({
      type: GET_BLOCKCHAIN_BLOCKS_SUCCESS, payload: {
        total: data.total,
        blocks: data.data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_BLOCKCHAIN_BLOCKS_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

/**
 * detail 
 */
export const getBlockchainBlock = (id) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_BLOCKCHAIN_BLOCK});

    const data = await callApi("get", `admin/block-chain/block/${id}`);
    dispatch({
      type: GET_BLOCKCHAIN_BLOCK_SUCCESS, payload: {
        block: data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_BLOCKCHAIN_BLOCK_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

