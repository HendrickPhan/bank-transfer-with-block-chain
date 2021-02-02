import {
  GETTING_BANK_ACCOUNTS,
  GET_BANK_ACCOUNTS_SUCCESS,
  GET_BANK_ACCOUNTS_FAIL,

  GETTING_BANK_ACCOUNT,
  GET_BANK_ACCOUNT_SUCCESS,
  GET_BANK_ACCOUNT_FAIL,

  ADDING_BANK_ACCOUNT,
  ADDING_BANK_ACCOUNT_SUCCESS,
  ADDING_BANK_ACCOUNT_FAIL,
  ADDING_BANK_ACCOUNT_CLEAR,
  
  ADDING_BANK_ACCOUNT_BALANCE,
  ADDING_BANK_ACCOUNT_BALANCE_SUCCESS,
  ADDING_BANK_ACCOUNT_BALANCE_FAIL,
  ADDING_BANK_ACCOUNT_BALANCE_CLEAR
  
} from '../constants/bankAccount';

import { callApi } from "../../ultilities/api"

/**
 * list 
 */
export const getBankAccounts = (userId, page, limit) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_BANK_ACCOUNTS});
    let param = {
      page: page, 
      limit: limit
    }

    const data = await callApi("get", `admin/${userId}/bank-account`, param);
    dispatch({
      type: GET_BANK_ACCOUNTS_SUCCESS, payload: {
        total: data.total,
        bankAccounts: data.data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_BANK_ACCOUNTS_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}


/**
 * add 
 */
export const getBankAccount = (accountNumber, type) =>  async (dispatch, getState) => {
  console.log("OK");
  try {
    dispatch({type: GETTING_BANK_ACCOUNT});

    const data = await callApi('get', `admin/bank-account/${accountNumber}`);
    dispatch({
      type: GET_BANK_ACCOUNT_SUCCESS, payload: {
        bankAccount: data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_BANK_ACCOUNT_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

/**
 * add 
 */
export const addBankAccount = (userId, type) =>  async (dispatch, getState) => {
  try {
    dispatch({type: ADDING_BANK_ACCOUNT});
    let param = {
      user_id: userId, 
      type: type
    }

    const data = await callApi('post', `admin/${userId}/bank-account`, param);
    dispatch({
      type: ADDING_BANK_ACCOUNT_SUCCESS, payload: {
        bankAccount: data
      }
    });

  } catch (error) {
    dispatch({
      type: ADDING_BANK_ACCOUNT_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const clearBankAccount = () => async (dispatch, getState) => {
  dispatch({
    type: ADDING_BANK_ACCOUNT_CLEAR, payload: {}
  });
}

/**
 * add balance 
 */
export const addBankAccountBalance = (amount, accountNumber) =>  async (dispatch, getState) => {
  try {
    dispatch({type: ADDING_BANK_ACCOUNT_BALANCE});
    let param = {
      amount: amount, 
      account_number: accountNumber
    }
    
    const data = await callApi('post', `admin/transaction/cash-in`, param);
    dispatch({
      type: ADDING_BANK_ACCOUNT_BALANCE_SUCCESS, payload: {
        bankAccount: data
      }
    });

  } catch (error) {
    dispatch({
      type: ADDING_BANK_ACCOUNT_BALANCE_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const clearAddBankAccountBalanceResult = () => async (dispatch, getState) => {
  dispatch({
    type: ADDING_BANK_ACCOUNT_BALANCE_CLEAR, payload: {}
  });
}