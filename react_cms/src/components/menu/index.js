import React from 'react';
import Button from '@material-ui/core/Button';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Grid from '@material-ui/core/Grid';
import {useHistory} from 'react-router-dom';
import { makeStyles } from '@material-ui/core/styles';
import MenuButton from '../../components/menu_button';
import { useDispatch } from 'react-redux';
import { logOut } from '../../redux/actions/auth';


const useStyles = makeStyles((theme) => ({
  root: {
    display: 'flex',
  },
  paper: {
    marginRight: theme.spacing(2),
  },
  menuButton: {
    textTransform: 'none',
    fontWeight: 'bold'
  }
}));

const menuItemsData = [
  {
    title: "Users",
    route: "/users",
  },
  {
    title: "Transactions",
    route: "/transactions",
  },
  {
    title: "Interest Rates",
    route: "/interest-rates",
  },
  {
    title: "News",
    route: "/news-list",
  },
  {
    title: "Settings",
    route: "/settings",
  },
  {
    title: "Statistic",
    route: "/statistic",
    items: [
      {
        title: "Monthly",
        route: "/statistic/monthly"
      },
      {
        title: "Daily",
        route: "/statistic/daily"
      }
    ]
  },
  {
    title: "Block Chain",
    route: "/block chain",
    items: [
      {
        title: "Nodes",
        route: "/block-chain/node"
      },
      {
        title: "Transactions",
        route: "/block-chain/node"
      }
    ]
  },
  
];

export default function Menu(props) {
  const classes = useStyles();
  const history = useHistory();
  const [currentMenu, setCurrentMenu] = React.useState('none');
  const dispatch = useDispatch();
  const logOutClick = () => {
    dispatch(logOut());
    history.push('login');
  }

  const menuItems = menuItemsData.map( (item, idx) =>
    <MenuButton
      key={idx} 
      title={item.title}
      route={item.route}
      items={item.items}
      setCurrentMenu={setCurrentMenu}
      selected={currentMenu.includes(item.route)}
    />
  );

  return (
    <div className={classes.root}>
      <AppBar position="static">
        <Toolbar>
          <Grid
            justify="space-between"
            container
          >
              {menuItems}
              <Button
                color="inherit"
                onClick={logOutClick}
                className={classes.menuButton}
              >
                Logout
              </Button>
          </Grid>

        </Toolbar>
      </AppBar>
      
    </div>
  );
}