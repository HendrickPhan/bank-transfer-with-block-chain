import {
  GETTING_INTEREST_RATES,
  GET_INTEREST_RATES_SUCCESS,
  GET_INTEREST_RATES_FAIL,

  GETTING_INTEREST_RATE,
  GET_INTEREST_RATE_SUCCESS,
  GET_INTEREST_RATE_FAIL,

  UPDATING_INTEREST_RATE,
  UPDATE_INTEREST_RATE_SUCCESS,
  UPDATE_INTEREST_RATE_FAIL,

  CLEAR_UPDATE_INTEREST_RATE
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

export const getInterestRate = (id) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_INTEREST_RATE});
    
    const data = await callApi("get", `admin/interest-rate/${id}`);
    dispatch({
      type: GET_INTEREST_RATE_SUCCESS, payload: {
        interestRate: data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_INTEREST_RATE_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const updateInterestRate = (id, updateData) => async (dispatch, getState) => {
  try {
    dispatch({type: UPDATING_INTEREST_RATE});
    
    const data = await callApi("put", `admin/interest-rate/${id}`, updateData);
    dispatch({
      type: UPDATE_INTEREST_RATE_SUCCESS, payload: {
        interestRate: data
      }
    });

  } catch (error) {
    dispatch({
      type: UPDATE_INTEREST_RATE_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const clearUpdate = () => async (dispatch, getState) => {
  dispatch({type: CLEAR_UPDATE_INTEREST_RATE});
}