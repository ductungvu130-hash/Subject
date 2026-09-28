import api from "./api";

export const getCustomers = async () => {
    const res = await api.get("/customers");
    return res.data;
};

export const addCustomer = async (name, phone) => {
    const res = await api.post("/customers", { name, phone });
    return res.data;
};