import React from 'react';
import {useState, useEffect, useCallback} from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';
import ListTable from './components/listTable'
import UpdateForm from './components/updateForm'
import { useHistory } from "react-router-dom";


const useStyles = makeStyles((theme) => ({
  root: {
    '& > *': {
      margin: theme.spacing(1),
    },
  },
  extendedIcon: {
    marginRight: theme.spacing(1),
  },
}));

export default function InterestRatePage() {
  const classes = useStyles();
  const [openModal, setOpenModal] = React.useState(false);
  const [updateData, setUpdateData] = React.useState({
    id: 0,
    type_text:  '',
    rate: 0 
  });

  const handleCloseModal = () => {
    setOpenModal(false);
  }

  return (
    <div className={classes.root}>
      <UpdateForm
        open={openModal}
        handleClose={handleCloseModal}
        updateData={updateData}
        setUpdateData={setUpdateData}
      />
      <ListTable
        setOpenModal={setOpenModal}
        setUpdateData={setUpdateData}
      />
    </div>
  );
}