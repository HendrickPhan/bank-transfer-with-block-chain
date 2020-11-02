import React from 'react';
import { useState } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import TextField from '@material-ui/core/TextField';
import Modal from '@material-ui/core/Modal';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import Settings from '../../../settings';

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
  const [errors, setErrors] = useState({});
  const [isLoaded, setIsLoaded] = useState(false);
  
  const [name, setName] = useState('');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [password, setPassword] = useState('');
  
  const fetchData = () => {
    fetch(Settings.API_URL + 'user', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        name: name, 
        phone_number: phoneNumber
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
            setPassword(result);
            props.setNeedReload(true);
          }
          console.log(errors);
        },
        // Note: it's important to handle errors here
        // instead of a catch() block so that we don't swallow
        // exceptions from actual bugs in components.
        (errors) => {
          setIsLoaded(true);
          setErrors(errors);
        }

      )
  };

  const handleSubmit = (event) => {
    //TODO: validate
    fetchData();
    event.preventDefault();
  }

  const handleRendered = () => {
    setName('');
    setPhoneNumber('');
    setPassword('');
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
            Add User
          </Typography>
          <form className={classes.root} autoComplete="off" onSubmit={handleSubmit}>
            <TextField
              label="Name"
              placeholder="Nguyễn Văn A"
              fullWidth
              required={true}
              className={classes.textField}
              margin="normal"
              InputLabelProps={{
                shrink: true,
              }}
              onChange={(event) => setName(event.target.value)}
            />
            <TextField
              label="Phone Number"
              placeholder="0960000000"
              fullWidth
              required={true}
              type="number"
              className={classes.textField}
              InputLabelProps={{
                shrink: true,
              }}
              onChange={(event) => setPhoneNumber(event.target.value)}
            />
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
            {
              password && 
              <TextField
                label="Password"
                value={password}
                fullWidth
                className={classes.textField}
                InputLabelProps={{
                  shrink: true,
                }}
              />
            }
            {
              password
              ? <Button
                  variant="contained"
                  onClick={() => props.handleClose()}
                  color='primary'
                  className={classes.button}
                >
                  Close
              </Button>

              : <Button
                  variant="contained"
                  // onClick={() => handleActionClick(action.path, {id: data[0]})}
                  color='primary'
                  className={classes.button}
                  type="submit"
                >
                  Add
                </Button>
            }
            
          </form>
        </div>
      </Modal>
      
    </div>
  )
}