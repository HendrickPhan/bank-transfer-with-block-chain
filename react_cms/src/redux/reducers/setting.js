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
  UPDATE_SETTING_CLEAR,

} from '../constants/setting';

/**
 * list 
 */
const initialStateList = {
  loading: false,
  settings: [],
  total: 0,
  errors: null,
};

export const settingsReducer = (state = initialStateList, { payload, type }) => {
  switch (type) {
    case GETTING_SETTINGS:
      return {
        ...state,
        loading: true
      };
    case GET_SETTINGS_SUCCESS:
      return {
        ...state,
        settings: payload.settings,
        total: payload.total,
        errors: null,
        loading: false
      };
    case GET_SETTINGS_FAIL:
      return {
        ...state,
        settings: [],
        total: 0,
        errors: payload.errors,
        loading: false
      };
    default:
      return state;
  }
};

/**
 * detail 
 */

const initialDetailStateList = {
  loading: false,
  setting: {
    key: '',
    value: ''
  },
  errors: {},
  updated: false,
};

export const settingReducer = (state = initialDetailStateList, { payload, type }) => {
  switch (type) {
    case GETTING_SETTING:
    case UPDATING_SETTING:
      return {
        ...state,
        loading: true
      };
    case GET_SETTING_SUCCESS:
      return {
        ...state,
        setting: payload.setting,
        errors: null,
        loading: false
      };
    case GET_SETTING_FAIL:
      return {
        ...state,
        setting: null,
        errors: payload.errors,
        loading: false
      };

    case UPDATE_SETTING_SUCCESS:
      return {
        ...state,
        updated: true,
        setting: payload.setting,
        errors: null,
        loading: false
      };

    case UPDATE_SETTING_FAIL:
      return {
        ...state,
        updated: false,
        errors: payload.errors,
        loading: false
      };

    case UPDATE_SETTING_CLEAR:
      return {
        ...state,
        updated: false,
      };
    default:
      return state;
  }
};