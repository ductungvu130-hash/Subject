import React, { useState, useEffect, useLayoutEffect } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, ScrollView, Alert } from 'react-native';
import { Menu, MenuOptions, MenuOption, MenuTrigger } from 'react-native-popup-menu';
import AsyncStorage from '@react-native-async-storage/async-storage';
import api from '../api/axios';

export default function TransactionDetailScreen({ route, navigation }) {
  const { transactionId } = route.params;
  const [transaction, setTransaction] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchTransactionDetail = async () => {
      try {
        const response = await api.get(`/transactions/${transactionId}`);
        setTransaction(response.data);
      } catch (error) {
        console.error(error);
      } finally {
        setLoading(false);
      }
    };

    fetchTransactionDetail();
  }, [transactionId]);

  const handleCancel = async () => {
    Alert.alert(
      'Warning',
      'Are you sure you want to cancel this transaction? This will affect the customer transaction information',
      [
        {
          text: 'YES',
          onPress: async () => {
            try {
              const token = await AsyncStorage.getItem('login_token');
              await api.delete(`/transactions/${transactionId}`, {
                headers: {
                  Authorization: `Bearer ${token}`
                }
              });
              Alert.alert('Success', 'Transaction cancelled');
              navigation.goBack();
            } catch (error) {
              console.error(error);
              Alert.alert('Error', 'Could not cancel transaction');
            }
          }
        },
        {
          text: 'CANCEL',
          style: 'cancel'
        }
      ]
    );
  };

  useLayoutEffect(() => {
    navigation.setOptions({
      headerRight: () => (
        <Menu>
          <MenuTrigger>
            <Text style={{ color: '#fff', fontSize: 24, paddingRight: 15 }}>⋮</Text>
          </MenuTrigger>
          <MenuOptions>
            <MenuOption onSelect={handleCancel} text="Cancel transaction" />
          </MenuOptions>
        </Menu>
      ),
    });
  }, [navigation, transactionId]);

  if (loading || !transaction) {
    return <ActivityIndicator size="large" color="#E74C3C" style={{ marginTop: 20 }} />;
  }

  return (
    <ScrollView style={styles.container}>
      <View style={styles.card}>
        <Text style={styles.sectionTitle}>General information</Text>
        <View style={styles.row}>
          <Text style={styles.label}>Transaction code</Text>
          <Text style={styles.value}>{transaction._id}</Text>
        </View>
        <View style={styles.row}>
          <Text style={styles.label}>Customer</Text>
          <Text style={styles.value}>{transaction.customer?.name} - {transaction.customer?.phone}</Text>
        </View>
        <View style={styles.row}>
          <Text style={styles.label}>Creation time</Text>
          <Text style={styles.value}>{new Date(transaction.createdAt).toLocaleString()}</Text>
        </View>
      </View>

      <View style={styles.card}>
        <Text style={styles.sectionTitle}>Services list</Text>
        {transaction.services?.map((svc, index) => (
          <View key={index} style={styles.serviceRow}>
            <Text style={styles.serviceName}>{svc.name}</Text>
            <Text style={styles.serviceQuantity}>x{svc.quantity || 1}</Text>
            <Text style={styles.servicePrice}>{svc.price} ₫</Text>
          </View>
        ))}
        <View style={[styles.row, { marginTop: 15, borderTopWidth: 1, borderTopColor: '#eee', paddingTop: 10 }]}>
          <Text style={[styles.label, { color: '#000' }]}>Total</Text>
          <Text style={[styles.value, { fontWeight: 'bold' }]}>{transaction.priceBeforePromotion || transaction.price} ₫</Text>
        </View>
      </View>

      <View style={styles.card}>
        <Text style={styles.sectionTitle}>Cost</Text>
        <View style={styles.row}>
          <Text style={styles.label}>Amount of money</Text>
          <Text style={[styles.value, { fontWeight: 'bold' }]}>{transaction.priceBeforePromotion || transaction.price} ₫</Text>
        </View>
        <View style={styles.row}>
          <Text style={styles.label}>Discount</Text>
          <Text style={[styles.value, { fontWeight: 'bold' }]}>
            -{(transaction.priceBeforePromotion || transaction.price) - transaction.price} ₫
          </Text>
        </View>
        <View style={[styles.row, { marginTop: 15, borderTopWidth: 1, borderTopColor: '#eee', paddingTop: 10 }]}>
          <Text style={[styles.label, { color: '#000', fontWeight: 'bold', fontSize: 16 }]}>Total payment</Text>
          <Text style={[styles.value, { fontWeight: 'bold', fontSize: 16, color: '#E74C3C' }]}>{transaction.price} ₫</Text>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  card: {
    backgroundColor: '#fff',
    padding: 15,
    margin: 10,
    borderRadius: 8,
  },
  sectionTitle: {
    color: '#E74C3C',
    fontWeight: 'bold',
    fontSize: 16,
    marginBottom: 15,
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 10,
  },
  label: {
    color: '#777',
    fontSize: 14,
  },
  value: {
    color: '#333',
    fontSize: 14,
    fontWeight: '500',
  },
  serviceRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  serviceName: {
    flex: 2,
    fontSize: 14,
    color: '#333',
  },
  serviceQuantity: {
    flex: 1,
    textAlign: 'center',
    color: '#777',
    fontSize: 14,
  },
  servicePrice: {
    flex: 1,
    textAlign: 'right',
    fontWeight: 'bold',
    fontSize: 14,
  },
});
