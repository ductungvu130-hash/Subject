import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import api from '../api/axios';

export default function LoginScreen({ navigation }) {
  const [phone, setPhone] = useState('0373007856'); // pre-filled for convenience based on lab
  const [password, setPassword] = useState('123');

  const handleLogin = async () => {
    try {
      const response = await api.post('/auth', { phone, password });
      if (response.data && response.data.token) {
        await AsyncStorage.setItem('login_token', response.data.token);
        navigation.replace('Main');
      } else {
        Alert.alert('Error', 'Login failed, no token received.');
      }
    } catch (error) {
      console.error(error);
      Alert.alert('Error', 'Invalid credentials or network error.');
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Login</Text>
      
      <View style={styles.inputContainer}>
        <TextInput
          style={styles.input}
          placeholder="Phone"
          value={phone}
          onChangeText={setPhone}
          keyboardType="phone-pad"
        />
      </View>
      
      <View style={styles.inputContainer}>
        <TextInput
          style={styles.input}
          placeholder="Password"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
        />
      </View>

      <TouchableOpacity style={styles.button} onPress={handleLogin}>
        <Text style={styles.buttonText}>Login</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    padding: 30,
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 40,
    fontWeight: 'bold',
    color: '#E74C3C',
    textAlign: 'center',
    marginBottom: 50,
  },
  inputContainer: {
    borderWidth: 1,
    borderColor: '#eee',
    borderRadius: 8,
    marginBottom: 15,
    paddingHorizontal: 15,
    backgroundColor: '#FAFAFA',
  },
  input: {
    height: 50,
    fontSize: 16,
  },
  button: {
    backgroundColor: '#E74C3C',
    borderRadius: 8,
    height: 50,
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 10,
  },
  buttonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: '600',
  },
});
