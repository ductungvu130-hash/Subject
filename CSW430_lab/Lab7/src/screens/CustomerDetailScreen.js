import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, Alert } from 'react-native';
import { Menu, MenuOptions, MenuOption, MenuTrigger } from 'react-native-popup-menu';
import api from '../api/axios';

export default function CustomerDetailScreen({ route, navigation }) {
  const { customerId } = route.params;
  const [customer, setCustomer] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    navigation.setOptions({
      headerRight: () => (
        <Menu>
          <MenuTrigger text="⋮" customStyles={{ triggerText: { fontSize: 24, color: '#fff', paddingHorizontal: 10 } }} />
          <MenuOptions>
            <MenuOption onSelect={() => navigation.navigate('EditCustomer', { customer })} text="Edit" />
            <MenuOption onSelect={confirmDelete} text="Delete" />
          </MenuOptions>
        </Menu>
      ),
    });
  }, [navigation, customer]);

  const fetchCustomerDetail = async () => {
    try {
      setLoading(true);
      const response = await api.get(`/customers/${customerId}`);
      setCustomer(response.data);
    } catch (error) {
      console.error(error);
      Alert.alert('Error', 'Could not load customer details');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const unsubscribe = navigation.addListener('focus', () => {
      fetchCustomerDetail();
    });
    return unsubscribe;
  }, [navigation, customerId]);

  const confirmDelete = () => {
    Alert.alert(
      'Warning',
      'Are you sure you want to remove this customer? This operation cannot be returned',
      [
        { text: 'CANCEL', style: 'cancel' },
        { text: 'DELETE', onPress: handleDelete }
      ]
    );
  };

  const handleDelete = async () => {
    try {
      await api.delete(`/customers/${customerId}`);
      Alert.alert('Success', 'Customer deleted');
      navigation.goBack();
    } catch (error) {
      console.error(error);
      Alert.alert('Error', 'Failed to delete customer');
    }
  };

  if (loading || !customer) {
    return <ActivityIndicator size="large" color="#E74C3C" style={{ marginTop: 20 }} />;
  }

  return (
    <View style={styles.container}>
      <Text style={styles.detailText}><Text style={styles.label}>Customer name: </Text>{customer.name}</Text>
      <Text style={styles.detailText}><Text style={styles.label}>Phone: </Text>{customer.phone}</Text>
      <Text style={styles.detailText}><Text style={styles.label}>Total Spent: </Text>{customer.totalSpent || 0} ₫</Text>
      <Text style={styles.detailText}><Text style={styles.label}>Loyalty: </Text>{customer.loyalty || 'Guest'}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 15,
    backgroundColor: '#fff',
  },
  detailText: {
    fontSize: 16,
    marginBottom: 10,
    color: '#333',
  },
  label: {
    fontWeight: 'bold',
    color: '#000',
  },
});
