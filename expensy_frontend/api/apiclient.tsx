'use client'
import axios from 'axios';
const BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';
// BASE_URL= "http://localhost:8080";
console.log('BASE_URL', BASE_URL);
export const apiClient = axios.create({
  baseURL: BASE_URL,
  headers: {    
    'Content-Type': 'application/json',
  },
});

apiClient.interceptors.request.use(async config => {
    const apiKey= process.env.NEXT_APP_API_KEY||'fergdhkdskgldkdd';
 
  if (apiKey) {
    config.headers.Authorization = `Bearer ${apiKey}`;
  }
  return config;
}
);

export default apiClient;
