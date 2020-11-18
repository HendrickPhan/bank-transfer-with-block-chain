import {
  GETTING_STATISTIC,
  GET_STATISTIC_SUCCESS,
  GET_STATISTIC_FAIL
} from '../constants/statistic';

const initialState = {
  errors: {},
  loading: false,
  daily: [],
  monthly: []
};

export const statisticReducer = (state = initialState, { payload, type }) => {
  switch (type) {
    case GETTING_STATISTIC:
      return {
        ...state,
        loading: true,
        errors: {},
      };
    case GET_STATISTIC_SUCCESS:
      return {
        ...state,
        loading: false,
        daily: payload.daily,
        monthly: payload.monthly,
      };
    case GET_STATISTIC_FAIL:
      return {
        ...state,
        loading: false,
        errors: {}
      };
    default:
      return state;
  }
};
