import React from 'react';
import {useState, useEffect, useRef} from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getNewsList } from '../../../redux/actions/news';
import RenderNewsListPage from './render'
import { useHistory } from "react-router-dom";

export default function UsersPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  const newsListData = useSelector(state => state.newsList);
  const { loading, newsList, total, errors } = newsListData;

  const fetchDataTimeOut = useRef();
  const [initalled, setInitalled] = useState(false);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  
  const [filterKeyword, setFilterKeyword] = useState('');
  
  const handleChangePage = (event, value) => {
    setPage(value);
  }
  
  const handleChangeRowsPerPage = (event) => {
    setPage(0)
    setRowsPerPage(event.target.value)
  }

  const handleAddClick = () => {
    history.push({
      pathname: `/news/add`,
    })
  }
  
  const handleDetailClick = (newsId) => {
    history.push({
      pathname: `/news/${newsId}`,
    })
  }

  const fetchData =  ()  => {
    dispatch(
      getNewsList(
        page + 1, rowsPerPage, {
          keyword: filterKeyword
        } 
      )
    );
  }

  useEffect(() => {
    setInitalled(true);
    fetchData();
  }, [
    page, 
    rowsPerPage
  ]);

  useEffect(() => {
    if(initalled) {
      clearTimeout(fetchDataTimeOut.current);
      fetchDataTimeOut.current = setTimeout(fetchData, 500);
    }
  }, [
    filterKeyword
  ]);

  return (
    // loading ? 
    //   <div>Loading</div> :
    // errors ? 
    //   <div>Err</div> :
      <RenderNewsListPage
        total={total}
        newsList={newsList}
        page={page}
        rowsPerPage={rowsPerPage}
        handleChangePage={handleChangePage}
        handleChangeRowsPerPage={handleChangeRowsPerPage}
        filterKeyword={filterKeyword}
        setFilterKeyword={setFilterKeyword}        
        handleAddClick={handleAddClick}
        handleDetailClick={handleDetailClick}
      />
  );
}