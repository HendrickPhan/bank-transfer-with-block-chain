import {
  GETTING_NEWS,
  GET_NEWS_SUCCESS,
  GET_NEWS_FAIL,

  ADDING_NEWS, 
  ADD_NEWS_SUCCESS,
  ADD_NEWS_FAIL,
  ADD_NEWS_CLEAR
} from '../constants/news';

import { callApi } from "../../ultilities/api"

export const getNewsList = (page, limit, filter={}) => async (dispatch, getState) => {
  try {
    dispatch({type: GETTING_NEWS});

    let param = {
      page: page, 
      limit: limit,
      ...filter
    }

    const data = await callApi("get", "admin/news", param);
    dispatch({
      type: GET_NEWS_SUCCESS, payload: {
        total: data.total,
        newsList: data.data
      }
    });

  } catch (error) {
    dispatch({
      type: GET_NEWS_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

/**
 * add 
 */
export const addNews = (title, body) =>  async (dispatch, getState) => {
  try {
    dispatch({type: ADDING_NEWS});
    let param = {
      title: title, 
      body: body
    }

    const data = await callApi('post', `admin/news`, param);
    dispatch({
      type: ADD_NEWS_SUCCESS, payload: {
        news: data
      }
    });

  } catch (error) {
    dispatch({
      type: ADD_NEWS_FAIL, payload: {
        errors: error.response.data.errors,
      }
    });
  }
}

export const clearAddNewsResult = () => async (dispatch, getState) => {
  dispatch({
    type: ADD_NEWS_CLEAR, payload: {}
  });
}
