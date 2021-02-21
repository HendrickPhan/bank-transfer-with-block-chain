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
  ADD_BILL_CLEAR
} from '../constants/bill';

/**
 * list 
 */
const initialState = {
  loading: false,
  bills: [],
  bill: null,
  total: 0,
  errors: {},
};

export const billReducer = (state = initialState, { payload, type }) => {
  switch (type) {
    // list
    case GETTING_BILLS:
      return {
        ...state,
        loading: true
      };
    case GET_BILLS_SUCCESS:
      return {
        ...state,
        bills: payload.bills,
        total: payload.total,
        errors: {},
        loading: false
      };
    case GET_BILLS_FAIL:
      return {
        ...state,
        bankAccounts: [],
        total: 0,
        errors: payload.errors,
        loading: false
      };
    
    // detail
    case GETTING_BILL:
      return {
        ...state,
        loading: true
      };
    case GET_BILL_SUCCESS:
      return {
        ...state,
        bill: payload.bill,
        errors: {},
        loading: false
      };
    case GET_BILL_FAIL:
      return {
        ...state,
        bill: null,
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
  bill: {},
  errors: {},
};

export const addBillReducer = (state = initialStateAdd, { payload, type }) => {
  switch (type) {
    case ADDING_BILL:
      return {
        ...state,
        loading: true
      };
    case ADD_BILL_SUCCESS:
      return {
        bill: payload.bill,
        errors: {},
        loading: false
      };
    case ADD_BILL_FAIL:
      return {
        bill: {},
        errors: payload.errors,
        loading: false
      };
    case ADD_BILL_CLEAR:
      return {
        bill: {},
        errors: {},
        loading: false
      };
    default:
      return state;
  }
};