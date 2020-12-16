import React from 'react';
import { Switch, Route, Redirect, BrowserRouter as Router } from 'react-router-dom';
import AdminRoute from './adminRoutes';

import Home from "../screens/home"
import Login from '../screens/login';
import Users from '../screens/user/list';
import AddUser from '../screens/user/add';
import User from '../screens/user/detail';
import Transactions from '../screens/transaction';
import BankAccounts from '../screens/bankAccount/list';
import AddBankAccount from '../screens/bankAccount/add';
import AddBankAccountBalance from '../screens/bankAccount/addBalance';
import InterestRates from '../screens/interestRate';
import NewsList from '../screens/news/list';
import AddNews from '../screens/news/add';
import Settings from '../screens/setting/list';
import Setting from '../screens/setting/detail';
import BankAccountsPage from '../screens/statistic';
import BlockchainBlocksPage from '../screens/blockchainBlock/list';
import BlockchainBlockDetailPage from '../screens/blockchainBlock/detail';
import BlockchainTransactionsPage from '../screens/blockchainTransaction/list';
import BlockchainTransactionDetaiPage from '../screens/blockchainTransaction/detail';

import Menu from "../components/menu"

const Routes = (props) => {
    return (
        <Router>
            <Switch>
                {props.loggedIn !== undefined && (props.loggedIn ?
                    <>
                        <Menu />
                        <AdminRoute exact path="/">
                            {/* <Home /> */}
                            <Users />

                        </AdminRoute>

                        <AdminRoute exact path="/users">
                            <Users />
                        </AdminRoute>
                        <AdminRoute exact path="/users/add">
                            <AddUser />
                        </AdminRoute>
                        
                        <AdminRoute exact path="/user/:userId">
                            <User />
                        </AdminRoute>
                        <AdminRoute exact path="/user/:userId/bank-accounts">
                            <BankAccounts />
                        </AdminRoute>
                        <AdminRoute exact path="/user/:userId/bank-account/add">
                            <AddBankAccount />
                        </AdminRoute>
                        <AdminRoute exact path="/bank-account/:accountNumber/add-balance">
                            <AddBankAccountBalance />
                        </AdminRoute>

                        <AdminRoute exact path="/bank-account/:accountNumber/transactions">
                            <Transactions />
                        </AdminRoute>
                        <AdminRoute exact path="/transactions">
                            <Transactions />
                        </AdminRoute>

                        <AdminRoute exact path="/interest-rates">
                            <InterestRates />
                        </AdminRoute>

                        <AdminRoute exact path="/news-list">
                            <NewsList />
                        </AdminRoute>
                        <AdminRoute exact path="/news/add">
                            <AddNews />
                        </AdminRoute>

                        <AdminRoute exact path="/settings">
                            <Settings />
                        </AdminRoute>
                        <AdminRoute exact path="/setting/:settingId">
                            <Setting />
                        </AdminRoute>

                        <AdminRoute exact path="/statistic">
                            <BankAccountsPage />
                        </AdminRoute>

                        <AdminRoute exact path="/blockchain/blocks">
                            <BlockchainBlocksPage />
                        </AdminRoute>
                        <AdminRoute exact path="/blockchain/blocks/:blockId">
                            <BlockchainBlockDetailPage />
                        </AdminRoute>

                        <AdminRoute exact path="/blockchain/transactions">
                            <BlockchainTransactionsPage />
                        </AdminRoute>
                        <AdminRoute exact path="/blockchain/transactions/:transactionId">
                            <BlockchainTransactionDetaiPage />
                        </AdminRoute>

                        <Route exact path="/login">
                            <Redirect to={{pathname: '/home'}}/>
                        </Route>
                    </> 
                    :
                    <Route path="/">
                        <Login />
                    </Route>
                )}
            </Switch>
        </Router>
    );
};

export default Routes;
