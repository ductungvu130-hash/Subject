import React, { useState } from 'react';
import { StyleSheet, View } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import ContactThum from './ContactThum';
import DetailListItem from './DetailListItem';
import { IconButton } from 'react-native-paper';

const ProfileContact = ({ route }) => {
  const { contact } = route.params;
  const { id, avatar, name, email, phone, cell } = contact;

  const [isFavorite, setIsFavorite] = useState(contact.favorite);

  const toggleFavorite = async () => {
    try {
      const newFavStatus = !isFavorite;
      setIsFavorite(newFavStatus);

      const storedContacts = await AsyncStorage.getItem('contacts');
      if (storedContacts !== null) {
        let contactsArray = JSON.parse(storedContacts);

        const contactIndex = contactsArray.findIndex(c => c.id === id);
        if (contactIndex > -1) {
          contactsArray[contactIndex].favorite = newFavStatus;

          await AsyncStorage.setItem('contacts', JSON.stringify(contactsArray));
        }
      }
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.avatarSection}>
        <ContactThum avatar={avatar} name={name} phone={phone} />
      </View>
      <View style={styles.detailsSection}>
        <DetailListItem icon="mail" title="Email" subtitle={email} />
        <DetailListItem icon="phone" title="Work" subtitle={phone} />
        <DetailListItem icon="smartphone" title="Personal" subtitle={cell} />
        <View style={{ alignItems: 'center', marginTop: 10 }}>
          <IconButton
            icon={isFavorite ? "star" : "star-outline"}
            iconColor="#663399"
            size={40}
            onPress={toggleFavorite} 
          />
        </View>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  avatarSection: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'blue',
  },
  detailsSection: {
    flex: 1,
    backgroundColor: 'white',
  },
});

export default ProfileContact;