import React from 'react';
import { Text } from 'react-native';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { MenuProvider } from 'react-native-popup-menu';
import { colors } from './src/theme';


import LoginScreen from './src/screens/LoginScreen';
import HomeScreen from './src/screens/HomeScreen';
import AddServiceScreen from './src/screens/AddServiceScreen';
import EditServiceScreen from './src/screens/EditServiceScreen';
import ServiceDetailScreen from './src/screens/ServiceDetailScreen';


import CustomerScreen from './src/screens/CustomerScreen';
import AddCustomerScreen from './src/screens/AddCustomerScreen';
import TransactionScreen from './src/screens/TransactionScreen';
import TransactionDetailScreen from './src/screens/TransactionDetailScreen';
import SettingScreen from './src/screens/SettingScreen';

const Stack = createNativeStackNavigator();
const Tab = createBottomTabNavigator();


function MainTabNavigator() {
  return (
    <Tab.Navigator
      screenOptions={({ route }) => ({
        headerShown: false, 
        tabBarActiveTintColor: colors.primary, 
        tabBarInactiveTintColor: 'gray',
        tabBarIcon: ({ color }) => {
          let iconName = '';
          if (route.name === 'Home') iconName = '🏠';
          else if (route.name === 'Transaction') iconName = '🧾';
          else if (route.name === 'Customer') iconName = '👥';
          else if (route.name === 'Setting') iconName = '⚙️';
          return <Text style={{ fontSize: 20, color: color }}>{iconName}</Text>;
        },
      })}
    >
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Transaction" component={TransactionScreen} />
      <Tab.Screen name="Customer" component={CustomerScreen} />
      <Tab.Screen name="Setting" component={SettingScreen} />
    </Tab.Navigator>
  );
}


export default function App() {
  return (
    <MenuProvider>
      <NavigationContainer>
        <Stack.Navigator screenOptions={{ headerShown: false }} initialRouteName="Login">
          
     
          <Stack.Screen name="Login" component={LoginScreen} />

         
          <Stack.Screen name="Main" component={MainTabNavigator} />

         
          <Stack.Screen name="AddService" component={AddServiceScreen} />
          <Stack.Screen name="EditService" component={EditServiceScreen} />
          <Stack.Screen name="ServiceDetail" component={ServiceDetailScreen} />
          
  
          <Stack.Screen name="AddCustomer" component={AddCustomerScreen} />
          <Stack.Screen name="TransactionDetail" component={TransactionDetailScreen} />
          
        </Stack.Navigator>
      </NavigationContainer>
    </MenuProvider>
  );
}