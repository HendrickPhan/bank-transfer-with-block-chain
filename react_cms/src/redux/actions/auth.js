import { 
  AUTH_LOGIN_SUCCESS, 
  AUTH_LOGIN_FAIL,
  GET_PROFILE_SUCCESS,
  GET_PROFILE_FAIL,
  LOG_OUT,
} from "../constants/auth";
import { callApi } from "../../ultilities/api"

export const login = (phoneNumber, password) => async (dispatch, getState) => {
  try {
    const token = await callApi("post", "login", {
      phone_number: phoneNumber, 
      password: password
    });

    localStorage.setItem('token', token);

    dispatch({
      type: AUTH_LOGIN_SUCCESS, payload: {
        loggedIn: true,
      }
    });

  } catch (error) {
    dispatch({
      type: AUTH_LOGIN_FAIL, payload: {
        loggedIn: false,
        errors: error.response.data.errors,
      }
    });
  }
}

export const getProfile = () => async (dispatch, getState) => {
  try {
    const profile = await callApi("get", "profile");

    dispatch({
      type: GET_PROFILE_SUCCESS, payload: {
        loggedIn: true,
      }
    });

  } catch (error) {
    dispatch({
      type: GET_PROFILE_FAIL, payload: {
        loggedIn: false,
        errors: error.response.data.errors,
      }
    });
  }
}

export const logOut = () => async (dispatch, getState) => {
  localStorage.removeItem('token');
  dispatch({type: LOG_OUT});
}
