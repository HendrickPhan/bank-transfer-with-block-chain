import {
  GETTING_INTEREST_RATES,
  GET_INTEREST_RATES_SUCCESS,
  GET_INTEREST_RATES_FAIL
} from '../constants/interestRate';

import { callApi } from "../../ultilities/api"

export const getInterestRates = (page, limit, filter={}) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_INTEREST_RATES});
    let param = {
      page: page, 
      limit: limit,
      ...filter
    }

    const data = await callApi("get", "admin/interest-rate", param);
    dispatch({
      type: GET_INTEREST_RATES_SUCCESS, payload: {
        total: data.total,
        interestRates: data.data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_INTEREST_RATES_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}