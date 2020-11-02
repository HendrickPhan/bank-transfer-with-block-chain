import React from 'react';
import {useState, useEffect, useCallback} from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';
import ListTable from './components/listTable'
import AddForm from './components/addForm'
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

export default function UserPage() {
  const classes = useStyles();
  const history = useHistory();
  const [openModal, setOpenModal] = React.useState(false);
  const [needReload, setNeedReload] = React.useState(false);

  const [openUpdateModal, setOpenUpdateModal] = React.useState(false);
  const [updateData, setUpdateData] = React.useState({
    id: 0,
    phone_number:  '',
    name: '' 
  });

  useEffect(() => {
    // logs 'useEffect inside handlers
    // logs the active ticker currently shown (by querying the DOM)
  }, [openModal]);

  const handleCloseModal = () => {
    setOpenModal(false);
    if(needReload) {
      history.go(0)
    }
  }

  const handleCloseUpdateModal = () => {
    setOpenUpdateModal(false);
    if(needReload) {
      history.go(0)
    }
  }

  return (
    <div className={classes.root}>
      <Fab 
        color="primary" 
        aria-label="add"
        onClick={() => setOpenModal(true)}
      >
        <AddIcon/>
      </Fab>
      <AddForm
        open={openModal}
        handleClose={handleCloseModal}
        setNeedReload={setNeedReload}
      />
      <UpdateForm
        open={openUpdateModal}
        handleClose={handleCloseUpdateModal}
        updateData={updateData}
        setUpdateData={setUpdateData}
      />
      <ListTable
        setOpenUpdateModal={setOpenUpdateModal}
        setUpdateData={setUpdateData}
      />
    </div>
  );
}