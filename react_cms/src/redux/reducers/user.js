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
  UPDATE_USER_CLEAR
} from '../constants/user';

/**
 * list
 */
const initialStateList = {
  loading: false,
  users: [],
  total: 0,
  errors: null,
};

export const usersReducer = (state = initialStateList, { payload, type }) => {
  switch (type) {
    case GETTING_USERS:
      return {
        ...state,
        loading: true
      };
    case GET_USERS_SUCCESS:
      return {
        ...state,
        users: payload.users,
        total: payload.total,
        errors: null,
        loading: false
      };
    case GET_USERS_FAIL:
      return {
        ...state,
        users: [],
        total: 0,
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
  user: {},
  errors: {},
};

export const addUserReducer = (state = initialStateAdd, { payload, type }) => {
  switch (type) {
    case ADDING_USER:
      return {
        ...state,
        loading: true
      };
    case ADD_USER_SUCCESS:
      return {
        user: payload.user,
        errors: {},
        loading: false
      };
    case ADD_USER_FAIL:
      return {
        user: {},
        errors: payload.errors,
        loading: false
      };
    case ADD_USER_CLEAR:
      return {
        user: {},
        errors: {},
        loading: false
      };
    default:
      return state;
  }
};


/**
 * detail
 */
const initialStateDetail = {
  loading: false,
  user: {},
  errors: {},
  updated: false
};

export const userReducer = (state = initialStateDetail, { payload, type }) => {
  switch (type) {
    case GETTING_USER:
    case UPDATING_USER:
        return {
        ...state,
        loading: true
      };
    case GET_USER_SUCCESS:
      return {
        ...state,
        user: payload.user,
        errors: {},
        loading: false
      };
    case GET_USER_FAIL:
      return {
        ...state,
        user: {},
        errors: payload.errors,
        loading: false
      };

    case UPDATE_USER_SUCCESS:
      return {
        ...state,
        updated: true,
        user: payload.user,
        errors: {},
        loading: false
      };

    case UPDATE_USER_FAIL:
      return {
        ...state,
        updated: false,
        errors: payload.errors,
        loading: false
      };

    case UPDATE_USER_CLEAR:
      return {
        ...state,
        updated: false,
      };
    default:
      return state;
  }
};