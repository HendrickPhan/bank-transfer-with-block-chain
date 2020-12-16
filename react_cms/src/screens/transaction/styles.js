import { makeStyles } from '@material-ui/core/styles';

const useStyles = makeStyles((theme) => ({
  filter: {
    display: "flex",
    alignItems: "center"
  },
  paper: {
    margin: theme.spacing(2),
  },
  table: {
    minWidth: 650,
  },
  textField: {
    margin: theme.spacing(2),
    width: '30ch',
  },
  button: {
    margin: theme.spacing(1),
    verticalAlign: 'center',
    fontWeight: 'bold',
    textTransform: 'none'
  },
}));

export default useStyles;