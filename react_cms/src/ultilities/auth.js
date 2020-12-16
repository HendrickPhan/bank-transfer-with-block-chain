import { callApi } from "./api"

export const Auth = {
  isAuthenticated: false,

  async authenticate() {
    try {
      await callApi("get", "profile");
      this.isAuthenticated = true;
    } catch (error) {
      this.isAuthenticated = false;
    }
  },
  logout() {
    this.isAuthenticated = false;
    localStorage.removeItem('token');
  },
};

export const checkAuth = () => {
  return Auth.authenticate();
};