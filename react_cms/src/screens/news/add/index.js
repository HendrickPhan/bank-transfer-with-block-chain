import React from 'react';
import { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { addNews, clearAddNewsResult } from '../../../redux/actions/news';
import RenderAddNewsPage from './render';
import { EditorState, convertToRaw } from 'draft-js';
import { useHistory, useParams } from "react-router-dom";

export default function AddNewsPage() {
  const dispatch = useDispatch();
  const history = useHistory();
  
  const [editorState, setEditorState] = React.useState(
    () => EditorState.createEmpty(),
  );

  const addNewsData = useSelector(state => state.addNews);
  const { loading, news, errors } = addNewsData;

  const [title, setTitle] = useState('');
  
  const handleSubmit = (e) => {
    e.preventDefault();
    const contentState = editorState.getCurrentContent();
    let rawBody = JSON.stringify(convertToRaw(contentState))
    
    dispatch(
      addNews(
        title, 
        rawBody      
      )
    );
    setTitle('');
    setEditorState('');
  }

  const handleClearNews = () => {
    dispatch(
      clearAddNewsResult()
    );
  }

  return (
    <RenderAddNewsPage
      title={title}
      setTitle={setTitle}
      editorState={editorState}
      setEditorState={setEditorState}
      handleSubmit={handleSubmit}
      handleClearNews={handleClearNews}
      news={news}
      errors={errors}
    />
  );
}