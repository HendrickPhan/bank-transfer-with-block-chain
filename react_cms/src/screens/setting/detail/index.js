import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { getSetting, updateSetting, clearUpdateResult } from '../../../redux/actions/setting';
import RenderSettingDetailPage from './render';
import { useHistory, useParams } from "react-router-dom";

export default function SettingDetailPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const settingData = useSelector(state => state.setting);
  const { loading, setting, errors, updated } = settingData;

  const [key, setKey] = useState(setting?.key);
  const [value, setValue] = useState(setting?.value);
  
  let { settingId } = useParams();

  const handleSubmit = (e) => {
    e.preventDefault();
    dispatch(
      updateSetting(
        settingId, 
        value      
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
      getSetting(settingId)
    );
  }

  useEffect(() => {
    fetchData();
  }, []);

  useEffect(() => {
    setKey(setting?.key)  
    setValue(setting?.value)  
  }, [settingData]);

  return (
    <RenderSettingDetailPage
      keyProp={key}
      setKey={setKey}
      value={value}
      setValue={setValue}
      handleSubmit={handleSubmit}
      handleClearResult={handleClearResult}
      updated={updated}
      errors={errors}
      
    />
  );
}