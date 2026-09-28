import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, TouchableOpacity, StyleSheet, ActivityIndicator } from 'react-native';
import api from '../api/axios';

export default function CustomerScreen({ navigation }) {
  const [customers, setCustomers] = useState([]);
  const [loading, setLoading] = useState(true);

  const fetchCustomers = async () => {
    try {
      setLoading(true);
      const response = await api.get('/customers');
      setCustomers(response.data);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const unsubscribe = navigation.addListener('focus', () => {
      fetchCustomers();
    });
    return unsubscribe;
  }, [navigation]);

  const renderItem = ({ item }) => (
    <TouchableOpacity 
      style={styles.itemContainer}
      onPress={() => navigation.navigate('CustomerDetail', { customerId: item._id })}
    >
      <View style={styles.infoContainer}>
        <Text style={styles.itemName}>Customer: {item.name}</Text>
        <Text style={styles.itemPhone}>Phone: {item.phone}</Text>
        <Text style={styles.itemMoney}>Total money: <Text style={styles.moneyAmount}>{item.totalSpent || 0} ₫</Text></Text>
      </View>
      <View style={styles.statusContainer}>
        <Text style={styles.loyaltyIcon}>👑</Text>
        <Text style={styles.loyaltyText}>{item.loyalty || 'Guest'}</Text>
      </View>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      {loading ? (
        <ActivityIndicator size="large" color="#E74C3C" />
      ) : (
        <FlatList
          data={customers}
          keyExtractor={(item) => item._id}
          renderItem={renderItem}
          contentContainerStyle={{ padding: 15 }}
        />
      )}
      <TouchableOpacity style={styles.fab} onPress={() => navigation.navigate('AddCustomer')}>
        <Text style={styles.fabText}>+</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  itemContainer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    padding: 15,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: '#eee',
    borderRadius: 8,
  },
  infoContainer: {
    flex: 1,
  },
  itemName: {
    fontSize: 14,
    fontWeight: 'bold',
  },
  itemPhone: {
    fontSize: 14,
    color: '#555',
    marginVertical: 4,
  },
  itemMoney: {
    fontSize: 14,
  },
  moneyAmount: {
    color: '#E74C3C',
    fontWeight: 'bold',
  },
  statusContainer: {
    justifyContent: 'center',
    alignItems: 'center',
    paddingLeft: 10,
  },
  loyaltyIcon: {
    fontSize: 24,
    color: '#E74C3C',
  },
  loyaltyText: {
    color: '#E74C3C',
    fontSize: 12,
    fontWeight: 'bold',
  },
  fab: {
    position: 'absolute',
    width: 56,
    height: 56,
    alignItems: 'center',
    justifyContent: 'center',
    right: 20,
    bottom: 20,
    backgroundColor: '#E74C3C',
    borderRadius: 28,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 3.84,
  },
  fabText: {
    fontSize: 24,
    color: '#fff',
    lineHeight: 28,
  },
});
