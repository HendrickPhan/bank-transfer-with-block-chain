import {
  GETTING_SETTINGS,
  GET_SETTINGS_SUCCESS,
  GET_SETTINGS_FAIL,

  GETTING_SETTING,
  GET_SETTING_SUCCESS,
  GET_SETTING_FAIL,
  
  UPDATING_SETTING,
  UPDATE_SETTING_SUCCESS,
  UPDATE_SETTING_FAIL,
  UPDATE_SETTING_CLEAR
} from '../constants/setting';

import { callApi } from "../../ultilities/api"

export const getSettings = (page, limit, filter={}) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_SETTINGS});

    let param = {
      page: page, 
      limit: limit,
      ...filter
    }
    
    const data = await callApi("get", "admin/setting", param);
    dispatch({
      type: GET_SETTINGS_SUCCESS, payload: {
        total: data.total,
        settings: data.data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_SETTINGS_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const getSetting = (id) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_SETTING});
    
    const data = await callApi("get", `admin/setting/${id}`);
    dispatch({
      type: GET_SETTING_SUCCESS, payload: {
        setting: data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_SETTING_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}


export const updateSetting = (id, value) => async (dispatch, getState) => {
  try {
    dispatch({type: UPDATING_SETTING});

    let param = {
      value: value, 
    }
    
    const data = await callApi("put", `admin/setting/${id}`, param);
    dispatch({
      type: UPDATE_SETTING_SUCCESS, payload: {
        setting: data
      }
    });

  } catch (error) {
    dispatch({
      type: UPDATE_SETTING_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const clearUpdateResult = () => async (dispatch, getState) => {
  dispatch({
    type: UPDATE_SETTING_CLEAR
  });
}