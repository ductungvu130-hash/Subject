import api from "./api";

export const getServices = async () => {
  const res = await api.get("/services");
  return res.data;
};

export const getServiceById = async (id) => {
  const res = await api.get(`/services/${id}`);
  return res.data;
};

export const addService = async (name, price) => {
  const res = await api.post("/services", { name, price });
  return res.data;
};

export const updateService = async (id, name, price) => {
  const res = await api.put(`/services/${id}`, { name, price });
  return res.data;
};

export const deleteService = async (id) => {
  const res = await api.delete(`/services/${id}`);
  return res.data;
};
