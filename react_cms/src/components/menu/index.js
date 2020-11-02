import React from 'react';
import Button from '@material-ui/core/Button';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Grid from '@material-ui/core/Grid';
import { makeStyles } from '@material-ui/core/styles';
import MenuButton from '../../components/menu_button';

const useStyles = makeStyles((theme) => ({
  root: {
    display: 'flex',
  },
  paper: {
    marginRight: theme.spacing(2),
  },
}));

const menuItemsData = [
  {
    title: "User",
    route: "/user",
  },
  {
    title: "Transaction",
    route: "/transaction",
  },
  {
    title: "Interest Rate",
    route: "/interest-rate",
  },
  {
    title: "News",
    route: "/news",
  },
  {
    title: "Setting",
    route: "/setting",
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

export default function Menu() {
  const classes = useStyles();
  const [currentMenu, setCurrentMenu] = React.useState('none');
  const menuItems = menuItemsData.map( (item, idx) =>
    <MenuButton
      key={idx} 
      title={item.title}
      route={item.route}
      items={item.items}
      setCurrentMenu={setCurrentMenu}
      color={currentMenu.includes(item.route) ? 'secondary' : 'default'} 
    />
  );

  return (
    <div className={classes.root}>
      <AppBar position="static">
        <Toolbar>
          <Grid
            justify="space-between" // Add it here :)
            container
          >
              {menuItems}
              <Button
                color="inherit"
              >
                Login
              </Button>
          </Grid>

        </Toolbar>
      </AppBar>
      
    </div>
  );
}