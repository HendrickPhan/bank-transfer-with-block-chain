import {
  GETTING_INTEREST_RATES,
  GET_INTEREST_RATES_SUCCESS,
  GET_INTEREST_RATES_FAIL
} from '../constants/interestRate';

const initialStateList = {
  loading: false,
  interestRates: [],
  total: 0,
  errors: null,
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
        errors: null,
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
    default:
      return state;
  }
};