import React, { useState, useCallback } from 'react';
import { View, FlatList, StyleSheet } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useFocusEffect } from '@react-navigation/native';
import 'react-native-get-random-values';
import { v4 } from 'uuid';
import ContactListItem from './ContactListItem';

const keyExtractor = ({ phone }) => phone;

const mapContacts = (contact) => {
  const { name, picture, phone, cell, email } = contact;
  return {
    id: v4(),
    name: name.first + ' ' + name.last,
    avatar: picture.large,
    phone,
    cell,
    email,
    favorite: Math.random() < 0.1,
  };
};

const Contacts = ({ navigation }) => {
  const [contacts, setContacts] = useState([]);

  const loadContacts = async () => {
    try {
      const storedContacts = await AsyncStorage.getItem('contacts');
      if (storedContacts !== null) {
        setContacts(JSON.parse(storedContacts));
      } else {
        
        const response = await fetch("https://randomuser.me/api/?results=50");
        const data = await response.json();
        const formattedContacts = data.results.map(mapContacts);
        
       
        await AsyncStorage.setItem('contacts', JSON.stringify(formattedContacts));
        setContacts(formattedContacts);
      }
    } catch (error) {
      console.error("Lỗi khi tải dữ liệu: ", error);
    }
  };

  
  useFocusEffect(
    useCallback(() => {
      loadContacts();
    }, [])
  );

  const renderContacts = ({ item }) => {
    if (!item) return null;
    const { name, avatar, phone } = item;
    return (
      <ContactListItem
        name={name}
        avatar={avatar}
        phone={phone}
        onPress={() => navigation.navigate("ProfileContact", { contact: item })}
      />
    );
  };

  return (
    <View style={styles.container}>
      <FlatList
        data={contacts}
        keyExtractor={keyExtractor}
        renderItem={renderContacts}
        showsVerticalScrollIndicator={false}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    flex: 1,
    paddingLeft: 10,
    paddingRight: 10,
    backgroundColor: 'white',
  },
});

export default Contacts;