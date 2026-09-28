import api from "./api";

export const getTransactions = async () =>{
    const res = await api.get("/transactions");
    return res.data;
};

export const getTransactionById = async (id) => {
    const res = await api.get(`/transactions/${id}`);
    return res.data;
};