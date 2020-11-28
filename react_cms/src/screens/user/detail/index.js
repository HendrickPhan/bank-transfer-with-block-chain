import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getUser, updateUser, clearUpdateResult } from '../../../redux/actions/user';
import RenderUserDetailPage from './render';
import { useParams } from "react-router-dom";

export default function UserDetailPage() {
  const dispatch = useDispatch();
  
  const userData = useSelector(state => state.user);
  const { loading, user, errors, updated } = userData;

  const [name, setName] = useState(user?.name);
  const [phoneNumber, setPhoneNumber] = useState(user?.phone_number);
  const [password, setPassword] = useState('');
  
  let { userId } = useParams();

  const handleSubmit = (e) => {
    e.preventDefault();
    dispatch(
      updateUser(
        userId, 
        name, 
        phoneNumber,
        password      
      )
    );
    setTimeout(() => {
      dispatch(
        clearUpdateResult()
      );
    }, 5000)
  }

  const handleClearResult = () => {
    dispatch(
      clearUpdateResult()
    );
  }

  const fetchData =  ()  => {
    dispatch(
      getUser(userId)
    );
  }

  useEffect(() => {
    fetchData();
  }, []);

  useEffect(() => {
    setName(user?.name)  
    setPhoneNumber(user?.phone_number)  
  }, [userData]);

  return (
    <RenderUserDetailPage
      name={name}
      setName={setName}
      phoneNumber={phoneNumber}
      setPhoneNumber={setPhoneNumber}
      password={password}
      setPassword={setPassword}
      handleSubmit={handleSubmit}
      handleClearResult={handleClearResult}
      updated={updated}
      errors={errors}
    />
  );
}