import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) => ({
  filter: {
    display: "flex",
    alignItems: "center",
    padding: theme.spacing(2),
  },
  paper: {
    margin: theme.spacing(2),
  },
  table: {
    minWidth: 650,
  },
  textField: {
    margin: theme.spacing(2),
    width: '100ch',
    color: 'black'
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