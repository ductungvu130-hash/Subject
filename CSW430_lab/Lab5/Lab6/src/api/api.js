import axios from "axios";
import AsyncStorage from "@react-native-async-storage/async-storage";

const BASE_URL = "https://kami-backend-5rs0.onrender.com";

const api = axios.create({
  baseURL: BASE_URL,
  timeout: 15000,
});

// tự động gắn token vào header nếu đã lưu trong AsyncStorage
api.interceptors.request.use(async (config) => {
  const token = await AsyncStorage.getItem("token");
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export default api;
