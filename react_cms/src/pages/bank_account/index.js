import React from 'react';
import {useState, useEffect, useCallback} from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Fab from '@material-ui/core/Fab';
import AddIcon from '@material-ui/icons/Add';
import ListTable from './components/listTable'
import AddForm from './components/addForm'
import AddBalanceForm from './components/addBalanceForm'
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

export default function BankAccountPage(props) {
  const classes = useStyles();
  const history = useHistory();
  const [openModal, setOpenModal] = React.useState(false);
  const [needReload, setNeedReload] = React.useState(false);
  useEffect(() => {
    // logs 'useEffect inside handlers
    // logs the active ticker currently shown (by querying the DOM)
  }, [openModal]);

  const [openAddBalanceModal, setOpenAddBalanceModal] = React.useState(false);
  const [addBalanceAccountNumber, setAddBalanceAccountNumber] = React.useState(0);

  const handleCloseModal = () => {
    setOpenModal(false);
    if(needReload) {
      history.go(0)
    }
  }

  const handleCloseAddBalanceModal = () => {
    setOpenAddBalanceModal(false);
    history.go(0)
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
        userId={history.location.state.userId}
      />
      <AddBalanceForm
        open={openAddBalanceModal}
        accountNumber={addBalanceAccountNumber}
        handleClose={handleCloseAddBalanceModal}
      />
      <ListTable
        userId={history.location.state.userId}
        setOpenAddBalanceModal={setOpenAddBalanceModal}
        setAddBalanceAccountNumber={setAddBalanceAccountNumber}
      />
    </div>
  );
}