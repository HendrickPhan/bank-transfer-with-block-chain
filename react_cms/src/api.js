exports.Get = async (path) => {
  let token = localStorage.getItem('token');
  let headers = {};
  if (token) {
    headers = {
      'Authorization': 'Bearer ' + token,
      'Accept': 'application/json'
    }
  }

  return fetch(path, {
    method: 'GET', // or 'PUT'
    headers: headers,
  })
    .then(response => {
      if (response.status !== 200) {
        throw new Error('Err');
      }
      response.json()
    });
}

exports.post = (path) => {
  let token = localStorage.getItem('token');
  let headers = {};
  if (token) {
    headers = {
      'Authorization': 'Bearer ' + token
    }
  }

  fetch(path, {
    method: 'GET', // or 'PUT'
    headers: headers,
  })
    .then(response => response.json());
}