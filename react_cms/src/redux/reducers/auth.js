import {
  AUTH_LOGIN_SUCCESS,
  AUTH_LOGIN_FAIL,
  GET_PROFILE_SUCCESS,
  GET_PROFILE_FAIL,
  LOG_OUT
} from '../constants/auth';

const initialState = {
  loggedIn: undefined,
  errors: {},
  profile: null
};

const authReducer = (state = initialState, { payload, type }) => {
  switch (type) {
    case AUTH_LOGIN_SUCCESS:
      return {
        loggedIn: true,
        errors: {},
      };
    case AUTH_LOGIN_FAIL:
      return {
        loggedIn: false,
        errors: payload.errors,
      };
    case GET_PROFILE_SUCCESS:
      return {
        loggedIn: true,
        profile: payload.profile,
        errors: {}
      };
    case GET_PROFILE_FAIL:
      return {
        loggedIn: false,
        profile: null,
        errors: {}
      };
    case LOG_OUT: 
      return {
        loggedIn: false,
        profile: null,
        errors: {}
      };
    default:
      return state;
  }
};

export default authReducer;
