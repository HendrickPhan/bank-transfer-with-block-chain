import {
  GETTING_STATISTIC,
  GET_STATISTIC_SUCCESS,
  GET_STATISTIC_FAIL
} from '../constants/statistic';

import { callApi } from "../../ultilities/api"

export const getStatistic = (fromDate, toDate) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_STATISTIC});

    let param = {
      from_date: fromDate, 
      to_date: toDate
    }

    const dataDailly = await callApi("get", "admin/statistic/daily", param);
    const dataMonthly = await callApi("get", "admin/statistic/monthly", param);
    
    dispatch({
      type: GET_STATISTIC_SUCCESS, payload: {
        daily: dataDailly,
        monthly: dataMonthly
      }
    });

  } catch (error) {
    dispatch({
      type: GET_STATISTIC_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}