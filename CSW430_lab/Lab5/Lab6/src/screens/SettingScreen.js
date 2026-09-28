import React from "react";
import { View, Text, TouchableOpacity, StyleSheet } from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { colors } from "../theme";

export default function SettingScreen({ navigation }) {
  const handleLogout = async () => {
    
    await AsyncStorage.removeItem("token");
    
    
    navigation.reset({ index: 0, routes: [{ name: "Login" }] });
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Setting</Text>
      </View>
      
      <View style={styles.body}>
        <TouchableOpacity style={styles.logoutBtn} onPress={handleLogout}>
          <Text style={styles.logoutText}>Logout</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  header: { 
    backgroundColor: colors.primary, 
    paddingTop: 50, 
    paddingBottom: 16, 
    paddingHorizontal: 16 
  },
  headerTitle: { color: colors.white, fontSize: 18, fontWeight: "bold" },
  body: { flex: 1, padding: 20, paddingTop: 40 },
  logoutBtn: { 
    backgroundColor: colors.primary, 
    paddingVertical: 14, 
    borderRadius: 6, 
    alignItems: "center" 
  },
  logoutText: { color: colors.white, fontWeight: "bold", fontSize: 16 }
});