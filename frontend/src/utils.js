export const BASE_API_URL = "http://localhost:3000/api/v1";

export const request = async (url, method = 'GET', params = null) => {
  const requestOptions = {
    method,
    headers: {
      'Content-Type': 'application/json',
    },
  }

  if (params) requestOptions["body"] = JSON.stringify(params);

  let response = await fetch(url, requestOptions);
  response = await response.json();

  return response;
}