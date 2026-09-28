import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, TouchableOpacity, StyleSheet, ActivityIndicator } from 'react-native';
import api from '../api/axios';

export default function TransactionScreen({ navigation }) {
  const [transactions, setTransactions] = useState([]);
  const [loading, setLoading] = useState(true);

  const fetchTransactions = async () => {
    try {
      setLoading(true);
      const response = await api.get('/transactions');
      setTransactions(response.data);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const unsubscribe = navigation.addListener('focus', () => {
      fetchTransactions();
    });
    return unsubscribe;
  }, [navigation]);

  const renderItem = ({ item }) => {
    // Assuming services is an array of objects
    const firstServiceName = item.services && item.services.length > 0 ? item.services[0].name : '';
    const otherServicesCount = item.services ? item.services.length - 1 : 0;
    const servicesText = otherServicesCount > 0 
      ? `- ${firstServiceName}\n- ...and ${otherServicesCount} other services`
      : `- ${firstServiceName}`;

    return (
      <TouchableOpacity
        style={styles.itemContainer}
        onPress={() => navigation.navigate('TransactionDetail', { transactionId: item._id })}
      >
        <View style={styles.topRow}>
          <Text style={styles.idText}>{item._id} - {new Date(item.createdAt).toLocaleString()}</Text>
          {item.status === 'Cancelled' ? (
            <Text style={styles.cancelledText}>- Cancelled</Text>
          ) : null}
        </View>

        <View style={styles.contentRow}>
          <View style={styles.servicesContainer}>
            <Text style={styles.servicesText}>{servicesText}</Text>
            <Text style={styles.customerText}>Customer: {item.customer?.name}</Text>
          </View>
          <Text style={styles.priceText}>{item.price} ₫</Text>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      {loading ? (
        <ActivityIndicator size="large" color="#E74C3C" />
      ) : (
        <FlatList
          data={transactions}
          keyExtractor={(item) => item._id}
          renderItem={renderItem}
          contentContainerStyle={{ padding: 15 }}
        />
      )}
      <TouchableOpacity 
        style={styles.fab} 
        onPress={() => navigation.navigate('AddTransaction')}
      >
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
  itemContainer: {
    padding: 15,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: '#eee',
    borderRadius: 8,
  },
  topRow: {
    flexDirection: 'row',
    marginBottom: 10,
  },
  idText: {
    fontSize: 12,
    fontWeight: 'bold',
  },
  cancelledText: {
    fontSize: 12,
    color: '#E74C3C',
    fontWeight: 'bold',
    marginLeft: 5,
  },
  contentRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  servicesContainer: {
    flex: 1,
  },
  servicesText: {
    fontSize: 14,
    color: '#333',
    marginBottom: 5,
  },
  customerText: {
    fontSize: 12,
    color: '#777',
  },
  priceText: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#E74C3C',
    alignSelf: 'center',
  },
});
