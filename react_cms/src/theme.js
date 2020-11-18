import { createMuiTheme } from '@material-ui/core/styles';
import blue from '@material-ui/core/colors/blue';
import green from '@material-ui/core/colors/green';

const Theme = createMuiTheme({
  palette: {
    primary: {
      light: '#334E68',
      main: '#243B53',
      dark: '#102A43',
      contrastText: '#fff',
    },
    background: {
      default: "#D9E2EC"
    },
    secondary: {
      main: green[500],
      contrastText: '#fff',
    },
  },
});

export default Theme;