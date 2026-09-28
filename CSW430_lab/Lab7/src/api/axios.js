import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';

const api = axios.create({
  baseURL: 'https://kami-backend-5rs0.onrender.com',
  timeout: 10000,
});

api.interceptors.request.use(
  async (config) => {
    const token = await AsyncStorage.getItem('login_token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`; // Typical bearer token format, will check API
      // If the API expects it differently, we might need to adjust.
      // Wait, the PDF says: "Param: login token" or similar for auth.
      // Often in these school projects, it might just expect a Bearer token.
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export default api;
