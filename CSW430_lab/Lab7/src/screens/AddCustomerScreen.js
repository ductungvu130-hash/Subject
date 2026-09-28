import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import api from '../api/axios';

export default function AddCustomerScreen({ navigation }) {
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');

  const handleAdd = async () => {
    if (!name || !phone) {
      Alert.alert('Error', 'Please fill all fields');
      return;
    }
    
    try {
      await api.post('/customers', { name, phone });
      Alert.alert('Success', 'Customer added successfully');
      navigation.goBack();
    } catch (error) {
      console.error(error);
      Alert.alert('Error', 'Failed to add customer');
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.label}>Customer name *</Text>
      <TextInput
        style={styles.input}
        placeholder="Input your customer's name"
        value={name}
        onChangeText={setName}
      />
      
      <Text style={styles.label}>Phone *</Text>
      <TextInput
        style={styles.input}
        placeholder="Input phone number"
        value={phone}
        onChangeText={setPhone}
        keyboardType="phone-pad"
      />

      <TouchableOpacity style={styles.button} onPress={handleAdd}>
        <Text style={styles.buttonText}>Add</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 15,
    backgroundColor: '#fff',
  },
  label: {
    fontSize: 14,
    fontWeight: 'bold',
    marginBottom: 5,
    marginTop: 15,
  },
  input: {
    backgroundColor: '#F5F5F5',
    borderRadius: 8,
    padding: 12,
    fontSize: 16,
  },
  button: {
    backgroundColor: '#E74C3C',
    borderRadius: 8,
    height: 50,
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 30,
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
});
