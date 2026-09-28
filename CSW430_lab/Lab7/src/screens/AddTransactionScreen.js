import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, ScrollView, Alert, ActivityIndicator } from 'react-native';
import { Dropdown } from 'react-native-element-dropdown';
import BouncyCheckbox from 'react-native-bouncy-checkbox';
import AsyncStorage from '@react-native-async-storage/async-storage';
import api from '../api/axios';

export default function AddTransactionScreen({ navigation }) {
  const [customers, setCustomers] = useState([]);
  const [services, setServices] = useState([]);
  const [executors, setExecutors] = useState([]);
  
  const [customerId, setCustomerId] = useState(null);
  const [selectedServices, setSelectedServices] = useState({});
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        const [custRes, servRes, execRes] = await Promise.all([
          api.get('/customers'),
          api.get('/services'),
          api.get('/users') // Assuming /users gets executors
        ]);
        setCustomers(custRes.data);
        setServices(servRes.data);
        setExecutors(execRes.data);
      } catch (error) {
        console.error(error);
        Alert.alert('Error', 'Failed to load data');
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, []);

  const toggleService = (serviceId, isChecked) => {
    setSelectedServices(prev => {
      const newState = { ...prev };
      if (isChecked) {
        newState[serviceId] = { quantity: 1, userId: null };
      } else {
        delete newState[serviceId];
      }
      return newState;
    });
  };

  const updateQuantity = (serviceId, delta) => {
    setSelectedServices(prev => {
      if (!prev[serviceId]) return prev;
      const newQuantity = Math.max(1, prev[serviceId].quantity + delta);
      return { ...prev, [serviceId]: { ...prev[serviceId], quantity: newQuantity } };
    });
  };

  const updateExecutor = (serviceId, userId) => {
    setSelectedServices(prev => {
      if (!prev[serviceId]) return prev;
      return { ...prev, [serviceId]: { ...prev[serviceId], userId } };
    });
  };

  const getTotalPrice = () => {
    let total = 0;
    services.forEach(s => {
      if (selectedServices[s._id]) {
        total += s.price * selectedServices[s._id].quantity;
      }
    });
    return total;
  };

  const handleSubmit = async () => {
    if (!customerId) {
      Alert.alert('Error', 'Please select a customer');
      return;
    }
    
    const servicesPayload = Object.keys(selectedServices).map(id => ({
      _id: id,
      quantity: selectedServices[id].quantity,
      userID: selectedServices[id].userId
    }));

    if (servicesPayload.length === 0) {
      Alert.alert('Error', 'Please select at least one service');
      return;
    }

    // Ensure all selected services have an executor if required.
    // If not required, we can let it be null. Wait, instruction says: Services[{_id, quantity, userID}]

    try {
      const token = await AsyncStorage.getItem('login_token');
      await api.post('/transactions', 
        { 
          customerId: customerId, 
          services: servicesPayload 
        },
        { headers: { Authorization: `Bearer ${token}` } }
      );
      Alert.alert('Success', 'Transaction added successfully');
      navigation.goBack();
    } catch (error) {
      console.error(error);
      Alert.alert('Error', 'Failed to add transaction');
    }
  };

  if (loading) {
    return <ActivityIndicator size="large" color="#E74C3C" style={{ marginTop: 20 }} />;
  }

  const customerData = customers.map(c => ({ label: c.name, value: c._id }));
  const executorData = executors.map(e => ({ label: e.name, value: e._id }));

  return (
    <View style={styles.container}>
      <ScrollView style={{ padding: 15 }}>
        <Text style={styles.label}>Customer *</Text>
        <Dropdown
          style={styles.dropdown}
          data={customerData}
          labelField="label"
          valueField="value"
          placeholder="Select customer"
          value={customerId}
          onChange={item => setCustomerId(item.value)}
        />

        <View style={{ marginTop: 20 }}>
          {services.map(service => {
            const isSelected = !!selectedServices[service._id];
            return (
              <View key={service._id} style={styles.serviceItem}>
                <BouncyCheckbox
                  size={20}
                  fillColor="#E74C3C"
                  unFillColor="#FFFFFF"
                  text={service.name}
                  iconStyle={{ borderColor: "#E74C3C", borderRadius: 4 }}
                  innerIconStyle={{ borderWidth: 2, borderRadius: 4 }}
                  textStyle={{ textDecorationLine: "none", color: '#333' }}
                  onPress={(isChecked) => toggleService(service._id, isChecked)}
                />
                
                {isSelected && (
                  <View style={styles.serviceDetails}>
                    <View style={styles.row}>
                      <View style={styles.quantityContainer}>
                        <TouchableOpacity onPress={() => updateQuantity(service._id, -1)} style={styles.qtyBtn}>
                          <Text style={styles.qtyText}>-</Text>
                        </TouchableOpacity>
                        <Text style={styles.qtyValue}>{selectedServices[service._id].quantity}</Text>
                        <TouchableOpacity onPress={() => updateQuantity(service._id, 1)} style={styles.qtyBtn}>
                          <Text style={styles.qtyText}>+</Text>
                        </TouchableOpacity>
                      </View>
                      
                      <Dropdown
                        style={styles.execDropdown}
                        data={executorData}
                        labelField="label"
                        valueField="value"
                        placeholder="Executor"
                        value={selectedServices[service._id].userId}
                        onChange={item => updateExecutor(service._id, item.value)}
                      />
                    </View>
                    <Text style={styles.priceText}>Price: {service.price.toLocaleString('vi-VN')} ₫</Text>
                  </View>
                )}
              </View>
            );
          })}
        </View>
      </ScrollView>

      <View style={styles.footer}>
        <TouchableOpacity style={styles.submitButton} onPress={handleSubmit}>
          <Text style={styles.submitButtonText}>See summary: ({getTotalPrice().toLocaleString('vi-VN')} ₫)</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  label: {
    fontSize: 14,
    fontWeight: 'bold',
    marginBottom: 8,
    color: '#333',
  },
  dropdown: {
    height: 50,
    borderColor: '#ddd',
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 15,
  },
  serviceItem: {
    marginBottom: 20,
  },
  serviceDetails: {
    marginLeft: 32, // align with checkbox text
    marginTop: 10,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  quantityContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#ddd',
    borderRadius: 8,
  },
  qtyBtn: {
    paddingHorizontal: 12,
    paddingVertical: 5,
  },
  qtyText: {
    fontSize: 18,
    color: '#E74C3C',
  },
  qtyValue: {
    paddingHorizontal: 15,
    fontSize: 16,
    borderLeftWidth: 1,
    borderRightWidth: 1,
    borderColor: '#ddd',
  },
  execDropdown: {
    flex: 1,
    height: 40,
    marginLeft: 15,
    borderColor: '#ddd',
    borderWidth: 1,
    borderRadius: 8,
    paddingHorizontal: 10,
  },
  priceText: {
    marginTop: 8,
    fontSize: 14,
    color: '#E74C3C',
    fontWeight: 'bold',
  },
  footer: {
    padding: 15,
    borderTopWidth: 1,
    borderColor: '#eee',
    backgroundColor: '#fff',
  },
  submitButton: {
    backgroundColor: '#E74C3C',
    borderRadius: 8,
    height: 50,
    justifyContent: 'center',
    alignItems: 'center',
  },
  submitButtonText: {
    color: '#fff',
    fontSize: 16,
    fontWeight: 'bold',
  },
});
