import { configureStore } from '@reduxjs/toolkit'
import authReducer from './reducers/auth'
import {
  usersReducer,
  userReducer,
  addUserReducer
} from './reducers/user'
import {transactionsReducer} from './reducers/transaction'
import {bankAccountsReducer, 
  addBankAccountReducer,
  addBankAccountBalanceReducer
} from './reducers/bankAccount'
import {interestRatesReducer} from './reducers/interestRate'
import {
  newsListReducer,
  addNewsReducer
} from './reducers/news'
import {
  settingsReducer,
  settingReducer
} from './reducers/setting'
import {
  statisticReducer
} from './reducers/statistic'

export default configureStore({
  reducer: {
    auth: authReducer,
    users: usersReducer,
    user: userReducer,
    addUser: addUserReducer,
    transactions: transactionsReducer,
    
    bankAccounts: bankAccountsReducer,
    addBankAccount: addBankAccountReducer,
    addBankAccountBalance: addBankAccountBalanceReducer,
    
    newsList: newsListReducer,
    addNews: addNewsReducer,
    
    settings: settingsReducer,
    setting: settingReducer,

    interestRates: interestRatesReducer,

    statistic: statisticReducer
  }
})