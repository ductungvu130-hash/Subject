import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import api from '../api/axios';

export default function AddServiceScreen({ navigation }) {
  const [name, setName] = useState('');
  const [price, setPrice] = useState('');

  const handleAdd = async () => {
    if (!name || !price) {
      Alert.alert('Error', 'Please fill all fields');
      return;
    }
    
    try {
      await api.post('/services', { name, price });
      Alert.alert('Success', 'Service added successfully');
      navigation.goBack();
    } catch (error) {
      console.error(error);
      Alert.alert('Error', 'Failed to add service');
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.label}>Service name *</Text>
      <TextInput
        style={styles.input}
        placeholder="Input a service name"
        value={name}
        onChangeText={setName}
      />
      
      <Text style={styles.label}>Price *</Text>
      <TextInput
        style={styles.input}
        placeholder="0"
        value={price}
        onChangeText={setPrice}
        keyboardType="numeric"
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
