import React from 'react';
import Button from '@material-ui/core/Button';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';

import Grid from '@material-ui/core/Grid';
import { useHistory } from 'react-router-dom';
import { makeStyles } from '@material-ui/core/styles';
import MenuButton from '../../components/menu_button';
import { useDispatch } from 'react-redux';
import { logOut } from '../../redux/actions/auth';

import SaveIcon from '@material-ui/icons/Save';
import PeopleIcon from '@material-ui/icons/People';
import ReceiptIcon from '@material-ui/icons/Receipt';
import DescriptionIcon from '@material-ui/icons/Description';
import TrendingUpIcon from '@material-ui/icons/TrendingUp';
import AnnouncementIcon from '@material-ui/icons/Announcement';
import SettingsIcon from '@material-ui/icons/Settings';
import AssessmentIcon from '@material-ui/icons/Assessment';
import MonetizationOnIcon from '@material-ui/icons/MonetizationOn';

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
    startIcon: <PeopleIcon/>
  },
  {
    title: "Transactions",
    route: "/transactions",
    startIcon: <DescriptionIcon/>
  },
  {
    title: "Interest Rates",
    route: "/interest-rates",
    startIcon: <TrendingUpIcon/>
  },
  {
    title: "News",
    route: "/news-list",
    startIcon: <AnnouncementIcon/>
  },
  {
    title: "Bill",
    route: "/bills",
    startIcon: <ReceiptIcon/>
  },
  {
    title: "Settings",
    route: "/settings",
    startIcon: <SettingsIcon/>
  },
  {
    title: "Statistic",
    route: "/statistic",
    startIcon: <AssessmentIcon/>,
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
    startIcon: <MonetizationOnIcon/>,
    items: [
      {
        title: "Blocks",
        route: "/blockchain/blocks"
      },
      {
        title: "Transactions",
        route: "/blockchain/transactions"
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

  const menuItems = menuItemsData.map((item, idx) =>
    <MenuButton
      key={idx}
      idx={idx}
      title={item.title}
      route={item.route}
      items={item.items}
      setCurrentMenu={setCurrentMenu}
      selected={currentMenu === idx}
      startIcon={item.startIcon}
    />
  );

  return (
    <div >
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
    </div>
  );
}