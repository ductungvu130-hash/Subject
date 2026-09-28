import 'react-native-gesture-handler';
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { createDrawerNavigator } from '@react-navigation/drawer';
import Icon from 'react-native-vector-icons/MaterialIcons'; 

import Contacts from './src/Contact';
import ProfileContact from './src/ProfileContact';
import Favorites from './src/Favorites';

const Stack = createStackNavigator();
const Drawer = createDrawerNavigator();


function ContactsScreens({ navigation }) {
  return (
    <Stack.Navigator initialRouteName="ContactsList">
      <Stack.Screen 
        name="ContactsList" 
        component={Contacts} 
        options={{ 
          title: 'Contacts',
     
          headerLeft: () => (
            <Icon 
              name="menu" 
              size={28} 
              color="black" 
              style={{ marginLeft: 15 }} 
              onPress={() => navigation.toggleDrawer()} 
            />
          )
        }} 
      />
      <Stack.Screen name="ProfileContact" component={ProfileContact} options={{ title: 'Profile contact' }} />
    </Stack.Navigator>
  );
}

function FavoriteScreens({ navigation }) {
  return (
    <Stack.Navigator initialRouteName="FavoritesList">
      <Stack.Screen 
        name="FavoritesList" 
        component={Favorites} 
        options={{ 
          title: 'Favorites',
          headerLeft: () => (
            <Icon 
              name="menu" 
              size={28} 
              color="black" 
              style={{ marginLeft: 15 }} 
              onPress={() => navigation.toggleDrawer()} 
            />
          )
        }} 
      />
      <Stack.Screen name="ProfileContact" component={ProfileContact} options={{ title: 'Profile contact' }} />
    </Stack.Navigator>
  );
}

const App = () => {
  return (
    <NavigationContainer>
      <Drawer.Navigator initialRouteName="Contacts">
        <Drawer.Screen 
          name="Contacts" 
          component={ContactsScreens} 
          options={{ headerShown: false }} 
        />
        <Drawer.Screen 
          name="Favorites" 
          component={FavoriteScreens} 
          options={{ headerShown: false }} 
        />
      </Drawer.Navigator>
    </NavigationContainer>
  );
};

export default App;