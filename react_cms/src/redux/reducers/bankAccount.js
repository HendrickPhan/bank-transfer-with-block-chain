import {
  GETTING_BANK_ACCOUNTS,
  GET_BANK_ACCOUNTS_SUCCESS,
  GET_BANK_ACCOUNTS_FAIL,

  ADDING_BANK_ACCOUNT,
  ADDING_BANK_ACCOUNT_SUCCESS,
  ADDING_BANK_ACCOUNT_FAIL,
  ADDING_BANK_ACCOUNT_CLEAR,

  ADDING_BANK_ACCOUNT_BALANCE,
  ADDING_BANK_ACCOUNT_BALANCE_SUCCESS,
  ADDING_BANK_ACCOUNT_BALANCE_FAIL,
  ADDING_BANK_ACCOUNT_BALANCE_CLEAR

} from '../constants/bankAccount';

/**
 * list 
 */
const initialStateList = {
  loading: false,
  bankAccounts: [],
  total: 0,
  errors: null,
};

export const bankAccountsReducer = (state = initialStateList, { payload, type }) => {
  switch (type) {
    case GETTING_BANK_ACCOUNTS:
      return {
        ...state,
        loading: true
      };
    case GET_BANK_ACCOUNTS_SUCCESS:
      return {
        ...state,
        bankAccounts: payload.bankAccounts,
        total: payload.total,
        errors: null,
        loading: false
      };
    case GET_BANK_ACCOUNTS_FAIL:
      return {
        ...state,
        bankAccounts: [],
        total: 0,
        errors: payload.errors,
        loading: false
      };
    default:
      return state;
  }
};

/**
 * add 
 */
const initialStateAdd = {
  loading: false,
  bankAccount: null,
  errors: null,
};

export const addBankAccountReducer = (state = initialStateAdd, { payload, type }) => {
  switch (type) {
    case ADDING_BANK_ACCOUNT:
      return {
        ...state,
        loading: true
      };
    case ADDING_BANK_ACCOUNT_SUCCESS:
      return {
        bankAccount: payload.bankAccount,
        errors: null,
        loading: false
      };
    case ADDING_BANK_ACCOUNT_FAIL:
      return {
        bankAccount: null,
        errors: payload.errors,
        loading: false
      };
    case ADDING_BANK_ACCOUNT_CLEAR:
      return {
        ...state,
        bankAccount: null,
      }
    default:
      return state;
  }
};

/**
 * add balance
 */
const initialStateAddBalance = {
  loading: false,
  added: false,
  errors: {},
};

export const addBankAccountBalanceReducer = (state = initialStateAddBalance, { payload, type }) => {
  switch (type) {
    case ADDING_BANK_ACCOUNT_BALANCE:
      return {
        ...state,
        loading: true
      };
    case ADDING_BANK_ACCOUNT_BALANCE_SUCCESS:
      return {
        added: true,
        errors: {},
        loading: false
      };
    case ADDING_BANK_ACCOUNT_BALANCE_FAIL:
      return {
        added: false,
        errors: payload.errors,
        loading: false
      };
    case ADDING_BANK_ACCOUNT_BALANCE_CLEAR:
      return {
        ...state,
        added: false,
        errors: {},
      }
    default:
      return state;
  }
};