import React from 'react';
import {useState, useEffect, useRef} from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getSettings } from '../../../redux/actions/setting';
import RenderSettingsPage from './render'
import { useHistory } from "react-router-dom";

export default function UsersPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  const settingsData = useSelector(state => state.settings);
  const { loading, settings, total, errors } = settingsData;

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

  const handleDetailClick = (settingId) => {
    history.push({
      pathname: `/setting/${settingId}`,
    })
  }

  const fetchData =  ()  => {
    dispatch(
      getSettings(
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
      <RenderSettingsPage
        total={total}
        settings={settings}
        page={page}
        rowsPerPage={rowsPerPage}
        handleChangePage={handleChangePage}
        handleChangeRowsPerPage={handleChangeRowsPerPage}
        filterKeyword={filterKeyword}
        setFilterKeyword={setFilterKeyword}        
        handleDetailClick={handleDetailClick}
      />
  );
}