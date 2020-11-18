import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { addUser, clearAddUserResult } from '../../../redux/actions/user';
import RenderAddUserPage from './render';
import { useHistory, useParams } from "react-router-dom";

export default function AddUserPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const addUserData = useSelector(state => state.addUser);
  const { loading, user, errors } = addUserData;

  const [name, setName] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    dispatch(
      addUser(
        name, 
        phoneNumber      
      )
    );
    setName('');
    setPhoneNumber('');
  }

  const handleClearUser = () => {
    dispatch(
      clearAddUserResult()
    );
  }

  return (
    <RenderAddUserPage
      name={name}
      setName={setName}
      phoneNumber={phoneNumber}
      setPhoneNumber={setPhoneNumber}
      handleSubmit={handleSubmit}
      handleClearUser={handleClearUser}
      user={user}
      errors={errors}
    />
  );
}