import {
  GETTING_BILLS,
  GET_BILLS_SUCCESS,
  GET_BILLS_FAIL,

  GETTING_BILL,
  GET_BILL_SUCCESS,
  GET_BILL_FAIL,

  ADDING_BILL,
  ADD_BILL_SUCCESS,
  ADD_BILL_FAIL,
  ADD_BILL_CLEAR,
} from '../constants/bill';
import { callApi } from "../../ultilities/api"

export const getBills = (page, limit, filter={}) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_BILLS});

    let param = {
      page: page, 
      limit: limit,
      ...filter
    }

    const data = await callApi("get", "admin/bill", param);

    dispatch({
      type: GET_BILLS_SUCCESS, payload: {
        total: data.total,
        bills: data.data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_BILLS_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const getBill = (billId) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_BILL});

    const data = await callApi("get", `admin/bill/${billId}`);

    dispatch({
      type: GET_BILL_SUCCESS, payload: {
        bill: data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_BILL_FAIL, payload: {
        error: error.response.data.errors,
      }
    });
  }
}

/**
 * add 
 */
export const addBill = (phoneNumber, type, amount, time) =>  async (dispatch, getState) => {
  try {
    dispatch({type: ADDING_BILL});
    let param = {
      phone_number: phoneNumber,
      type: type,
      amount: amount,
      time: time,
    }

    const data = await callApi('post', `admin/bill`, param);
    dispatch({
      type: ADD_BILL_SUCCESS, payload: {
        bill: {
          phone_number: phoneNumber,
          type: type,
          amount: amount,
          time: time
        }
      }
    });

  } catch (error) {
    dispatch({
      type: ADD_BILL_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const clearAddBillResult = () => async (dispatch, getState) => {
  dispatch({
    type: ADD_BILL_CLEAR, payload: {}
  });
}