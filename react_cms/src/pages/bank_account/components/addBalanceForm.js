import React from 'react';
import { useState } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import TextField from '@material-ui/core/TextField';
import Modal from '@material-ui/core/Modal';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import Settings from '../../../settings';
import MenuItem from '@material-ui/core/MenuItem';
import Select from '@material-ui/core/Select';
import InputLabel from '@material-ui/core/InputLabel';
import { useHistory } from "react-router-dom";

const useStyles = makeStyles((theme) => ({
  root: {
  },
  textField: {
    marginLeft: theme.spacing(1),
    marginRight: theme.spacing(1),
    marginBottom: theme.spacing(2),
  },
  modal: {
    position: 'absolute',
    width: 850,
    backgroundColor: theme.palette.background.paper,  
    border: '2px solid #000',
    boxShadow: theme.shadows[5],
    padding: theme.spacing(2, 4, 3),
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
  }
}));

export default function AddBalanceForm(props) {
  const classes = useStyles();
  const history = useHistory();
  const [errors, setErrors] = useState({});
  const [isLoaded, setIsLoaded] = useState(false);
  
  const [amount, setAmount] = useState(0);
  
  const fetchData = () => {
    fetch(Settings.API_URL + `transaction/cash-in`, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        amount: amount, 
        account_number: props.accountNumber, 
      })
    })
      .then(res => res.json())
      .then(
        (result) => {
          setIsLoaded(true);
          if(result.errors) {
            setErrors(result.errors);
          } else {
            setErrors({});
            history.go(0)
          }
        },
        // Note: it's important to handle errors here
        // instead of a catch() block so that we don't swallow
        // exceptions from actual bugs in components.
        (errors) => {
          setIsLoaded(true);
          setErrors(errors);
        }
      )
      .catch( (e) => {
        console.log(e);
      })
  };

  const handleSubmit = (event) => {
    //TODO: validate
    fetchData();
    event.preventDefault();
  }

  const handleRendered = () => {
    setAmount(0);
    setErrors({});
  }

  return (
    <div className={classes.root}>
      <Modal
        open={props.open}
        onClose={props.handleClose}
        onRendered={handleRendered}
      >
        <div className={classes.modal}>
          <Typography variant="h3">
            Add Balance
          </Typography>
          <form className={classes.root} autoComplete="off" onSubmit={handleSubmit}>
            <TextField
              label="Amount"
              value={amount}
              fullWidth
              required={true}
              type="number"
              className={classes.textField}
              InputLabelProps={{
                shrink: true,
              }}
              onChange={(event) => setAmount(event.target.value)}
            />
          
            <Button
              variant="contained"
              // onClick={() => handleActionClick(action.path, {id: data[0]})}
              color='primary'
              className={classes.button}
              type="submit"
            >
              Add
            </Button>
          </form>
        </div>
      </Modal>
      
    </div>
  )
}