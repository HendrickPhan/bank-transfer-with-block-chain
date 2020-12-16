import Axios from "axios";
import Settings from "../settings"

export const callApi = async (method, path, requestData = {}, headers = {}) => {
  let token = localStorage.getItem('token');
  if( token !== undefined ) {
    headers.Authorization = "Bearer " + token;
  }
  
  const {data} = await Axios({
    method: method,
    url: Settings.BASE_URL + path,
    data: method === "get" ? null : requestData,
    headers: headers,
    params: method === "get" ? requestData : null
  });
  
  return data;
}