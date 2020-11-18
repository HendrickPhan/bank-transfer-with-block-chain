import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) => ({
  root: {
    '& > *': {
      margin: theme.spacing(1),
    },
  },
  paper: {
    margin: theme.spacing(2),
  },
  filter: {
    display: "flex",
    alignItems: "center"
  },
  textField: {
    margin: theme.spacing(2),
    width: '50ch',
  },
  table: {
    minWidth: 650,
  },
  button: {
    margin: theme.spacing(1),
    verticalAlign: 'center',
    fontWeight: 'bold',
    textTransform: 'none'
  },
  addButton: {
    margin: theme.spacing(2),
    marginBottom: theme.spacing(0),
  }
}));

export default useStyles;