import { createSlice, configureStore } from "@reduxjs/toolkit";
import {v4} from 'uuid';
import 'react-native-get-random-values';

export const mapContacts = (contact) => {
    const {name, picture, phone, cell, email} = contact;
    return{
        id : v4(),
        name: name.first + ' ' + name.last,
        avatar: picture.large,
        phone,
        cell,
        email,
        favorite: Math.random()< 0.1? true : false,
    };
};

const contactSlice = createSlice({
    name: 'contacts',
    initialState: {
        contacts: [],
    },
    reducers:{
        fetchContactsSuccess : (state, action)=>{
            state.contacts = action.payload;
        },
    },
});

export const {fetchContactsSuccess} = contactSlice.actions;
const store = configureStore({
    reducer: contactSlice.reducer,
});

export default store;