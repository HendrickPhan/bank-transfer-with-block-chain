import {
  GETTING_NEWS,
  GET_NEWS_SUCCESS,
  GET_NEWS_FAIL,

  ADDING_NEWS, 
  ADD_NEWS_SUCCESS,
  ADD_NEWS_FAIL,
  ADD_NEWS_CLEAR
} from '../constants/news';

const initialStateList = {
  loading: false,
  newsList: [],
  total: 0,
  errors: {},
};

export const newsListReducer = (state = initialStateList, { payload, type }) => {
  switch (type) {
    case GETTING_NEWS:
      return {
        ...state,
        loading: true
      };
    case GET_NEWS_SUCCESS:
      return {
        ...state,
        newsList: payload.newsList,
        total: payload.total,
        errors: {},
        loading: false
      };
    case GET_NEWS_FAIL:
      return {
        ...state,
        newsList: [],
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
  news: null,
  errors: {},
};

export const addNewsReducer = (state = initialStateAdd, { payload, type }) => {
  switch (type) {
    case ADDING_NEWS:
      return {
        ...state,
        loading: true
      };
    case ADD_NEWS_SUCCESS:
      return {
        news: payload.news,
        errors: {},
        loading: false
      };
    case ADD_NEWS_FAIL:
      return {
        news: null,
        errors: payload.errors,
        loading: false
      };
    case ADD_NEWS_CLEAR:
      return {
        news: null,
        errors: {},
        loading: false
      };
    default:
      return state;
  }
};