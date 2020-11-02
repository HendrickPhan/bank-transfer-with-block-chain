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

export default function AddForm(props) {
  const classes = useStyles();
  const history = useHistory();
  const [errors, setErrors] = useState({});
  const [isLoaded, setIsLoaded] = useState(false);
  
  const [type, setType] = useState(0);
  const [phoneNumber, setPhoneNumber] = useState('');
  
  const fetchData = () => {
    fetch(Settings.API_URL + `bank-account/${props.userId}`, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        type: type 
      })
    })
      .then(res => res.json())
      .then(
        (result) => {
          console.log(result)
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
    setType(0);
    setPhoneNumber('');
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
            Add Bank Account
          </Typography>
          <form className={classes.root} autoComplete="off" onSubmit={handleSubmit}>
          <InputLabel id="type-select-label">Type</InputLabel>
          <Select
            className={classes.textField}
            fullWidth
            labelId="type-select-label"
            id="type-select"
            value={type}
            onChange={ (event) => setType(event.target.value)}
          >
            <MenuItem value={0}>Tài khoản giao dịch</MenuItem>
            <MenuItem value={1}>Tài khoản tiết kiệm 1 tháng</MenuItem>
            <MenuItem value={2}>Tài khoản tiết kiệm 3 tháng</MenuItem>
            <MenuItem value={3}>Tài khoản tiết kiệm 6 tháng</MenuItem>
            <MenuItem value={4}>Tài khoản tiết kiệm 12 tháng</MenuItem>
          </Select>
            {
              Object.keys(errors).map((field) => {
                return (
                  errors[field].map((err, idx) => {
                    return (
                      <Typography 
                        color="error"
                        key={idx}
                      >
                        {err}
                      </Typography>
                    )
                  }) 
                )
              })
            }
          
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