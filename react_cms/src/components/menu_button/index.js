import React from 'react';
import Button from '@material-ui/core/Button';
import Typography from '@material-ui/core/Typography';
import Paper from '@material-ui/core/Paper';
import Popper from '@material-ui/core/Popper';
import MuiMenuItem from '@material-ui/core/MenuItem';
import MenuList from '@material-ui/core/MenuList';
import { useHistory } from "react-router-dom";
import { withStyles } from "@material-ui/core/styles";

const MenuItem = withStyles({
  root: {
    justifyContent: "center"
  }
})(MuiMenuItem);


export default function MenuButton(props) {
  const history = useHistory();
  const [open, setOpen] = React.useState(false);
  const anchorRef = React.useRef(null);

  function handleListKeyDown(event) {
    if (event.key === 'Tab') {
      event.preventDefault();
      setOpen(false);
    }
  }

  function handleClick(route) {
    if(route) {
      props.setCurrentMenu(route);
      history.push(route);
    }
  }

  const items = props.items ? props.items.map((item, key) =>
    <MenuItem 
      onClick={() => handleClick(item.route)}
      key={key}
      style={{
        minWidth: '100px',
        textAlign: 'center'
      }}
    >
      {item.title}
    </MenuItem>
  ) : null;
  return (
      <div>
        <Button
          ref={anchorRef}
          aria-controls={open ? 'menu-list-grow' : undefined}
          aria-haspopup="true"
          onClick={() => handleClick(props.route)}
          onMouseOver={() => setOpen(true)}
          onMouseLeave={() => setOpen(false)}
          color={props.color ? props.color : 'default'} 
          style={{minWidth: '100px'}}

        >
          {props.title}
        </Button>
        { 
          props.items && props.items.length > 0 &&
          <Popper 
            open={open} 
            anchorEl={anchorRef.current} 
            role={undefined} 
            disablePortal 
            style={{
              minWidth: '100px',
              textAlign: 'center'
            }}
          >
            <Paper>
            <Typography
              onMouseEnter={() => setOpen(true)}
              onMouseLeave={() => setOpen(false)}
            >
                <MenuList 
                  autoFocusItem={open} 
                  id="menu-list-grow" 
                  onKeyDown={handleListKeyDown}
                >
                  {items}
                </MenuList>
              </Typography>
            </Paper>
          </Popper>
        }
      </div>
  );
}