import React from 'react';
import { useState, useEffect, useCallback } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';
import ListTable from './components/listTable'
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

export default function TransactionPage(props) {
  const classes = useStyles();
  const history = useHistory();
  const [openModal, setOpenModal] = React.useState(false);
  const [needReload, setNeedReload] = React.useState(false);
  useEffect(() => {
    // logs 'useEffect inside handlers
    // logs the active ticker currently shown (by querying the DOM)
  }, [openModal]);

  return (
    <div className={classes.root}>
      <Fab
        color="primary"
        aria-label="add"
        onClick={() => setOpenModal(true)}
      >
        <AddIcon />
      </Fab>
      <ListTable />
    </div>
  );
}