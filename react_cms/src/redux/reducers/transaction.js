import {
  GETTING_TRANSACTIONS,
  GET_TRANSACTIONS_SUCCESS,
  GET_TRANSACTIONS_FAIL
} from '../constants/transaction';

const initialStateList = {
  loading: false,
  transactions: [],
  total: 0,
  errors: null,
};

export const transactionsReducer = (state = initialStateList, { payload, type }) => {
  switch (type) {
    case GETTING_TRANSACTIONS:
      return {
        ...state,
        loading: true
      };
    case GET_TRANSACTIONS_SUCCESS:
      return {
        ...state,
        transactions: payload.transactions,
        total: payload.total,
        errors: null,
        loading: false
      };
    case GET_TRANSACTIONS_FAIL:
      return {
        ...state,
        transactions: [],
        total: 0,
        errors: payload.errors,
        loading: false
      };
    default:
      return state;
  }
};