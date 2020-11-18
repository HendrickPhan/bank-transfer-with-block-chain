import {
  GETTING_TRANSACTIONS,
  GET_TRANSACTIONS_SUCCESS,
  GET_TRANSACTIONS_FAIL
} from '../constants/transaction';

import { callApi } from "../../ultilities/api"

export const getTransactions = (page, limit, filter={}) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_TRANSACTIONS});

    let param = {
      page: page, 
      limit: limit,
      ...filter
    }

    const data = await callApi("get", "admin/transaction", param);
    dispatch({
      type: GET_TRANSACTIONS_SUCCESS, payload: {
        total: data.total,
        transactions: data.data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_TRANSACTIONS_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}