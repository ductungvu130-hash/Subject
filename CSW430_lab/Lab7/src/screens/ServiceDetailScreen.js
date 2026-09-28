import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, ActivityIndicator, Alert } from 'react-native';
import { Menu, MenuOptions, MenuOption, MenuTrigger } from 'react-native-popup-menu';
import api from '../api/axios';

export default function ServiceDetailScreen({ route, navigation }) {
  const { serviceId } = route.params;
  const [service, setService] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    navigation.setOptions({
      headerRight: () => (
        <Menu>
          <MenuTrigger text="⋮" customStyles={{ triggerText: { fontSize: 24, color: '#fff', paddingHorizontal: 10 } }} />
          <MenuOptions>
            <MenuOption onSelect={() => navigation.navigate('EditService', { service })} text="Edit" />
            <MenuOption onSelect={confirmDelete} text="Delete" />
          </MenuOptions>
        </Menu>
      ),
    });
  }, [navigation, service]);

  const fetchServiceDetail = async () => {
    try {
      setLoading(true);
      const response = await api.get(`/services/${serviceId}`);
      setService(response.data);
    } catch (error) {
      console.error(error);
      Alert.alert('Error', 'Could not load service details');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const unsubscribe = navigation.addListener('focus', () => {
      fetchServiceDetail();
    });
    return unsubscribe;
  }, [navigation, serviceId]);

  const confirmDelete = () => {
    Alert.alert(
      'Warning',
      'Are you sure you want to remove this service? This operation cannot be returned',
      [
        { text: 'CANCEL', style: 'cancel' },
        { text: 'DELETE', onPress: handleDelete }
      ]
    );
  };

  const handleDelete = async () => {
    try {
      await api.delete(`/services/${serviceId}`);
      Alert.alert('Success', 'Service deleted');
      navigation.goBack();
    } catch (error) {
      console.error(error);
      Alert.alert('Error', 'Failed to delete service');
    }
  };

  if (loading || !service) {
    return <ActivityIndicator size="large" color="#E74C3C" style={{ marginTop: 20 }} />;
  }

  return (
    <View style={styles.container}>
      <Text style={styles.detailText}><Text style={styles.label}>Service name: </Text>{service.name}</Text>
      <Text style={styles.detailText}><Text style={styles.label}>Price: </Text>{service.price} ₫</Text>
      <Text style={styles.detailText}><Text style={styles.label}>Creator: </Text>{service.createdBy?.name || service.createdBy}</Text>
      <Text style={styles.detailText}><Text style={styles.label}>Time: </Text>{new Date(service.createdAt).toLocaleString()}</Text>
      <Text style={styles.detailText}><Text style={styles.label}>Final update: </Text>{new Date(service.updatedAt).toLocaleString()}</Text>
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
