import 'react-native-gesture-handler';
import React, { useState, useCallback } from 'react';
import { StyleSheet, View, FlatList, Text } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useFocusEffect } from '@react-navigation/native';
import ContactThumbnail from './ContactThum';

const keyExtractor = ({ phone }) => phone;

const Favorites = ({ navigation }) => {
  const [favorites, setFavorites] = useState([]);

  const loadFavorites = async () => {
    try {
      const storedContacts = await AsyncStorage.getItem('contacts');
      if (storedContacts !== null) {
        const contactsArray = JSON.parse(storedContacts);
        const favs = contactsArray.filter((contact) => contact.favorite === true);
        setFavorites(favs);
      }
    } catch (error) {
      console.error(error);
    }
  };

  useFocusEffect(
    useCallback(() => {
      loadFavorites();
    }, [])
  );

  const renderFavoriteThumbnail = ({ item }) => {
    const { avatar } = item;
    return (
      <ContactThumbnail
        avatar={avatar}
        onPress={() => navigation.navigate('ProfileContact', { contact: item })}
      />
    );
  };

  return (
    <View style={styles.container}>
      <FlatList
        data={favorites}
        keyExtractor={keyExtractor}
        numColumns={3}
        contentContainerStyle={styles.list}
        renderItem={renderFavoriteThumbnail}
        showsVerticalScrollIndicator={false}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: "white",
    justifyContent: 'center',
    flex: 1,
  },
  list: {
    alignItems: 'center',
  },
});

export default Favorites;