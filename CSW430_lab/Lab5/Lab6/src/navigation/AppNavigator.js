import React, { useEffect, useState } from "react";
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { View, ActivityIndicator } from "react-native";

import LoginScreen from "../screens/LoginScreen";
import HomeScreen from "../screens/HomeScreen";
import AddServiceScreen from "../screens/AddServiceScreen";
import ServiceDetailScreen from "../screens/ServiceDetailScreen";
import EditServiceScreen from "../screens/EditServiceScreen";
import { colors } from "../theme";

const Stack = createNativeStackNavigator();

export default function AppNavigator() {
  const [checking, setChecking] = useState(true);
  const [initialRoute, setInitialRoute] = useState("Login");

  useEffect(() => {
    AsyncStorage.getItem("token").then((token) => {
      setInitialRoute(token ? "Home" : "Login");
      setChecking(false);
    });
  }, []);

  if (checking) {
    return (
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
        <ActivityIndicator color={colors.primary} />
      </View>
    );
  }

  return (
    <NavigationContainer>
      <Stack.Navigator
        initialRouteName={initialRoute}
        screenOptions={{ headerShown: false }}
      >
        <Stack.Screen name="Login" component={LoginScreen} />
        <Stack.Screen name="Home" component={HomeScreen} />
        <Stack.Screen name="AddService" component={AddServiceScreen} />
        <Stack.Screen name="ServiceDetail" component={ServiceDetailScreen} />
        <Stack.Screen name="EditService" component={EditServiceScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
