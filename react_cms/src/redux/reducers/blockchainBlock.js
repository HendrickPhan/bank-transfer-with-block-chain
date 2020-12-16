import {
  GETTING_BLOCKCHAIN_BLOCKS,
  GET_BLOCKCHAIN_BLOCKS_SUCCESS,
  GET_BLOCKCHAIN_BLOCKS_FAIL,
  GETTING_BLOCKCHAIN_BLOCK,
  GET_BLOCKCHAIN_BLOCK_SUCCESS,
  GET_BLOCKCHAIN_BLOCK_FAIL,
} from '../constants/blockchainBlock';

/**
 * list 
 */
const initialState = {
  loading: false,
  blocks: [],
  block: null,
  total: 0,
  errors: {},
};

export const blockchainBlockReducer = (state = initialState, { payload, type }) => {
  switch (type) {
    // list
    case GETTING_BLOCKCHAIN_BLOCKS:
      return {
        ...state,
        loading: true
      };
    case GET_BLOCKCHAIN_BLOCKS_SUCCESS:
      return {
        ...state,
        blocks: payload.blocks,
        total: payload.total,
        errors: {},
        loading: false
      };
    case GET_BLOCKCHAIN_BLOCKS_FAIL:
      return {
        ...state,
        bankAccounts: [],
        total: 0,
        errors: payload.errors,
        loading: false
      };
    
    // detail
    case GETTING_BLOCKCHAIN_BLOCK:
      return {
        ...state,
        loading: true
      };
    case GET_BLOCKCHAIN_BLOCK_SUCCESS:
      return {
        ...state,
        block: payload.block,
        errors: {},
        loading: false
      };
    case GET_BLOCKCHAIN_BLOCK_FAIL:
      return {
        ...state,
        block: null,
        errors: payload.errors,
        loading: false
      };
  
    default:
      return state;
  }
};

