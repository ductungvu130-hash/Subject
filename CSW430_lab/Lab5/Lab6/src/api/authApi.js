import api from "./api";

export const login = async (phone, password) => {
  const res = await api.post("/auth", { phone, password });
  return res.data; // { token: "..." }
};
