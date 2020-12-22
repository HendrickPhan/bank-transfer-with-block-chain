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

const initialStateList = {
  loading: false,
  updated: false,
  interestRates: [],
  interestRate: {},
  total: 0,
  errors: {},
};

export const interestRatesReducer = (state = initialStateList, { payload, type }) => {
  switch (type) {
    case GETTING_INTEREST_RATES:
      return {
        ...state,
        loading: true
      };
    case GET_INTEREST_RATES_SUCCESS:
      return {
        ...state,
        interestRates: payload.interestRates,
        total: payload.total,
        errors: {},
        loading: false
      };
    case GET_INTEREST_RATES_FAIL:
      return {
        ...state,
        interestRates: [],
        total: 0,
        errors: payload.errors,
        loading: false
      };
    //detail
    case GETTING_INTEREST_RATE:
      return {
        ...state,
        loading: true
      };
    case GET_INTEREST_RATE_SUCCESS:
      return {
        ...state,
        interestRate: payload.interestRate,
        errors: {},
        loading: false
      };
    case GET_INTEREST_RATE_FAIL:
      return {
        ...state,
        interestRate: {},
        errors: payload.errors,
        loading: false
      };
    //update
    case UPDATING_INTEREST_RATE:
      return {
        ...state,
        loading: true
      };
    case UPDATE_INTEREST_RATE_SUCCESS:
      return {
        ...state,
        interestRate: payload.interestRate,
        errors: {},
        updated: true,
        loading: false
      };
    case UPDATE_INTEREST_RATE_FAIL:
      return {
        ...state,
        errors: payload.errors,
        updated: false,
        loading: false
      };
      case CLEAR_UPDATE_INTEREST_RATE:
        return {
          ...state,
          updated: false,
        }
    default:
      return state;
  }
};