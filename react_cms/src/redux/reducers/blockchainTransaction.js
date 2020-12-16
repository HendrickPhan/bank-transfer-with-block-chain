import {
  GETTING_BLOCKCHAIN_TRANSACTIONS,
  GET_BLOCKCHAIN_TRANSACTIONS_SUCCESS,
  GET_BLOCKCHAIN_TRANSACTIONS_FAIL,

  GETTING_BLOCKCHAIN_TRANSACTION,
  GET_BLOCKCHAIN_TRANSACTION_SUCCESS,
  GET_BLOCKCHAIN_TRANSACTION_FAIL,
} from '../constants/blockchainTransaction';

/**
 * list 
 */
const initialState = {
  loading: false,
  transactions: [],
  transaction: null,
  total: 0,
  errors: {},
};

export const blockchainTransactionReducer = (state = initialState, { payload, type }) => {
  switch (type) {
    // list
    case GETTING_BLOCKCHAIN_TRANSACTIONS:
      return {
        ...state,
        loading: true
      };
    case GET_BLOCKCHAIN_TRANSACTIONS_SUCCESS:
      return {
        ...state,
        transactions: payload.transactions,
        total: payload.total,
        errors: {},
        loading: false
      };
    case GET_BLOCKCHAIN_TRANSACTIONS_FAIL:
      return {
        ...state,
        bankAccounts: [],
        total: 0,
        errors: payload.errors,
        loading: false
      };
    
    // detail
    case GETTING_BLOCKCHAIN_TRANSACTION:
      return {
        ...state,
        loading: true
      };
    case GET_BLOCKCHAIN_TRANSACTION_SUCCESS:
      return {
        ...state,
        transaction: payload.transaction,
        errors: {},
        loading: false
      };
    case GET_BLOCKCHAIN_TRANSACTION_FAIL:
      return {
        ...state,
        transaction: null,
        errors: payload.errors,
        loading: false
      };
  
    default:
      return state;
  }
};

