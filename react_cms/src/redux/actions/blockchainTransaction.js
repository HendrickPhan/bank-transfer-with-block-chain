import {
  GETTING_BLOCKCHAIN_TRANSACTIONS,
  GET_BLOCKCHAIN_TRANSACTIONS_SUCCESS,
  GET_BLOCKCHAIN_TRANSACTIONS_FAIL,

  GETTING_BLOCKCHAIN_TRANSACTION,
  GET_BLOCKCHAIN_TRANSACTION_SUCCESS,
  GET_BLOCKCHAIN_TRANSACTION_FAIL,
} from '../constants/blockchainTransaction';

import { callApi } from "../../ultilities/api"

/**
 * list 
 */
export const getBlockchainTransactions = (page, limit) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_BLOCKCHAIN_TRANSACTIONS});
    let param = {
      page: page, 
      limit: limit
    }

    const data = await callApi("get", `admin/block-chain/transaction`, param);
    dispatch({
      type: GET_BLOCKCHAIN_TRANSACTIONS_SUCCESS, payload: {
        total: data.total,
        transactions: data.data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_BLOCKCHAIN_TRANSACTIONS_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

/**
 * detail 
 */
export const getBlockchainTransaction = (id) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_BLOCKCHAIN_TRANSACTION});

    const data = await callApi("get", `admin/block-chain/transaction/${id}`);
    dispatch({
      type: GET_BLOCKCHAIN_TRANSACTION_SUCCESS, payload: {
        transaction: data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_BLOCKCHAIN_TRANSACTION_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

