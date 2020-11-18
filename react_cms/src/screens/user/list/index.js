import React from 'react';
import {useState, useEffect, useRef} from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getUsers } from '../../../redux/actions/user';
import RenderUsersPage from './users'
import { useHistory } from "react-router-dom";

export default function UsersPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  const usersData = useSelector(state => state.users);
  const { loading, users, total, errors } = usersData;

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

  const handleBankAccountClick = (userId) => {
    history.push({
      pathname: `/user/${userId}/bank-accounts`,
    })
  }

  const handleAddClick = (userId) => {
    history.push({
      pathname: `/user/add`,
    })
  }
  
  const fetchData =  ()  => {
    dispatch(
      getUsers(
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
      <RenderUsersPage
        total={total}
        users={users}
        page={page}
        rowsPerPage={rowsPerPage}
        handleChangePage={handleChangePage}
        handleChangeRowsPerPage={handleChangeRowsPerPage}
        handleBankAccountClick={handleBankAccountClick}
        handleAddClick={handleAddClick}
        filterKeyword={filterKeyword}
        setFilterKeyword={setFilterKeyword}
      />
  );
}