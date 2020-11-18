import {
  GETTING_USERS,
  GET_USERS_SUCCESS,
  GET_USERS_FAIL,

  GETTING_USER,
  GET_USER_SUCCESS,
  GET_USER_FAIL,

  ADDING_USER,
  ADD_USER_SUCCESS,
  ADD_USER_FAIL,
  ADD_USER_CLEAR,

  UPDATING_USER,
  UPDATE_USER_SUCCESS,
  UPDATE_USER_FAIL,
  UPDATE_USER_CLEAR,
} from '../constants/user';
import { callApi } from "../../ultilities/api"

export const getUsers = (page, limit, filter={}) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_USERS});

    let param = {
      page: page, 
      limit: limit,
      ...filter
    }

    const data = await callApi("get", "admin/user", param);

    dispatch({
      type: GET_USERS_SUCCESS, payload: {
        total: data.total,
        users: data.data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_USERS_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const getUser = (userId) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_USER});

    const data = await callApi("get", `admin/user/${userId}`);

    dispatch({
      type: GET_USER_SUCCESS, payload: {
        user: data.data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_USER_FAIL, payload: {
        error: error.response.data.errors,
      }
    });
  }
}

/**
 * add 
 */
export const addUser = (name, phoneNumber) =>  async (dispatch, getState) => {
  try {
    dispatch({type: ADDING_USER});
    let param = {
      name: name, 
      phone_number: phoneNumber
    }

    const data = await callApi('post', `admin/user`, param);
    dispatch({
      type: ADD_USER_SUCCESS, payload: {
        user: {
          name: name, 
          phone_number: phoneNumber,
          password: data 
        }
      }
    });

  } catch (error) {
    dispatch({
      type: ADD_USER_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const clearAddUserResult = () => async (dispatch, getState) => {
  dispatch({
    type: ADD_USER_CLEAR, payload: {}
  });
}


/**
 * update 
 */
export const updateUser = (userId, name, phoneNumber) =>  async (dispatch, getState) => {
  try {
    dispatch({type: UPDATING_USER});
    let param = {
      name: name, 
      phone_number: phoneNumber
    }

    const data = await callApi('post', `admin/user/${userId}`, param);
    dispatch({
      type: UPDATE_USER_SUCCESS, payload: {
        user: {
          name: name, 
          phone_number: phoneNumber
        }
      }
    });

  } catch (error) {
    dispatch({
      type: UPDATE_USER_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const clearUpdateUserResult = () => async (dispatch, getState) => {
  dispatch({
    type: UPDATE_USER_CLEAR, payload: {}
  });
}
