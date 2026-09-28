import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { Text } from 'react-native'; // Placeholder for icons if vector-icons is not used

import HomeScreen from '../screens/HomeScreen';
import AddServiceScreen from '../screens/AddServiceScreen';
import ServiceDetailScreen from '../screens/ServiceDetailScreen';
import EditServiceScreen from '../screens/EditServiceScreen';

import CustomerScreen from '../screens/CustomerScreen';
import AddCustomerScreen from '../screens/AddCustomerScreen';
import CustomerDetailScreen from '../screens/CustomerDetailScreen';
import EditCustomerScreen from '../screens/EditCustomerScreen';

import TransactionScreen from '../screens/TransactionScreen';
import TransactionDetailScreen from '../screens/TransactionDetailScreen';
import AddTransactionScreen from '../screens/AddTransactionScreen';

import SettingScreen from '../screens/SettingScreen';

const Tab = createBottomTabNavigator();
const Stack = createNativeStackNavigator();

function HomeStack() {
  return (
    <Stack.Navigator screenOptions={{ headerStyle: { backgroundColor: '#E74C3C' }, headerTintColor: '#fff' }}>
      <Stack.Screen name="HomeMain" component={HomeScreen} options={{ title: 'HUYỀN TRINH' }} />
      <Stack.Screen name="AddService" component={AddServiceScreen} options={{ title: 'Add Service' }} />
      <Stack.Screen name="ServiceDetail" component={ServiceDetailScreen} options={{ title: 'Service detail' }} />
      <Stack.Screen name="EditService" component={EditServiceScreen} options={{ title: 'Edit Service' }} />
    </Stack.Navigator>
  );
}

function TransactionStack() {
  return (
    <Stack.Navigator screenOptions={{ headerStyle: { backgroundColor: '#E74C3C' }, headerTintColor: '#fff' }}>
      <Stack.Screen name="TransactionMain" component={TransactionScreen} options={{ title: 'Transaction' }} />
      <Stack.Screen name="TransactionDetail" component={TransactionDetailScreen} options={{ title: 'Transaction detail' }} />
      <Stack.Screen name="AddTransaction" component={AddTransactionScreen} options={{ title: 'Add transaction' }} />
    </Stack.Navigator>
  );
}

function CustomerStack() {
  return (
    <Stack.Navigator screenOptions={{ headerStyle: { backgroundColor: '#E74C3C' }, headerTintColor: '#fff' }}>
      <Stack.Screen name="CustomerMain" component={CustomerScreen} options={{ title: 'Customer' }} />
      <Stack.Screen name="AddCustomer" component={AddCustomerScreen} options={{ title: 'Add customer' }} />
      <Stack.Screen name="CustomerDetail" component={CustomerDetailScreen} options={{ title: 'Customer detail' }} />
      <Stack.Screen name="EditCustomer" component={EditCustomerScreen} options={{ title: 'Edit customer' }} />
    </Stack.Navigator>
  );
}

export default function MainTabNavigator() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarActiveTintColor: '#E74C3C',
        tabBarInactiveTintColor: 'gray',
        tabBarIcon: ({ color }) => {
          let iconName;
          if (route.name === 'Home') iconName = '🏠';
          else if (route.name === 'Transaction') iconName = '💵';
          else if (route.name === 'Customer') iconName = '👥';
          else if (route.name === 'Setting') iconName = '⚙️';
          return <Text style={{ color, fontSize: 20 }}>{iconName}</Text>;
        }
      })}
    >
      <Tab.Screen name="Home" component={HomeStack} />
      <Tab.Screen name="Transaction" component={TransactionStack} />
      <Tab.Screen name="Customer" component={CustomerStack} />
      <Tab.Screen name="Setting" component={SettingScreen} />
    </Tab.Navigator>
  );
}
