import React, { useState } from "react";
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert, ActivityIndicator } from "react-native";
import { addCustomer } from "../api/customerApi";
import { colors } from "../theme";

export default function AddCustomerScreen({ navigation }) {
  const [name, setName] = useState("");
  const [phone, setPhone] = useState("");
  const [loading, setLoading] = useState(false);

  const handleAdd = async () => {
    if (!name || !phone) return Alert.alert("Thông báo", "Vui lòng nhập đủ thông tin");
    try {
      setLoading(true);
      await addCustomer(name, phone);
      navigation.goBack();
    } catch (err) {
      Alert.alert("Lỗi", "Không thể thêm khách hàng");
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}><Text style={styles.back}>←</Text></TouchableOpacity>
        <Text style={styles.headerTitle}>Add customer</Text>
        <View style={{ width: 20 }} />
      </View>
      <View style={styles.form}>
        <Text style={styles.label}>Customer name *</Text>
        <TextInput style={styles.input} placeholder="Input your customer's name" value={name} onChangeText={setName} />
        <Text style={styles.label}>Phone *</Text>
        <TextInput style={styles.input} placeholder="Input phone number" value={phone} onChangeText={setPhone} keyboardType="phone-pad" />
        <TouchableOpacity style={styles.button} onPress={handleAdd} disabled={loading}>
          {loading ? <ActivityIndicator color={colors.white} /> : <Text style={styles.buttonText}>Add</Text>}
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  header: { backgroundColor: colors.primary, paddingTop: 50, paddingBottom: 16, paddingHorizontal: 16, flexDirection: "row", justifyContent: "space-between", alignItems: "center" },
  back: { color: colors.white, fontSize: 22 },
  headerTitle: { color: colors.white, fontSize: 17, fontWeight: "bold" },
  form: { padding: 20 },
  label: { fontWeight: "600", fontSize: 13, marginBottom: 8, marginTop: 12 },
  input: { backgroundColor: colors.white, borderRadius: 6, borderWidth: 1, borderColor: colors.border, padding: 12, fontSize: 14 },
  button: { backgroundColor: colors.primary, padding: 14, borderRadius: 6, alignItems: "center", marginTop: 24 },
  buttonText: { color: colors.white, fontWeight: "bold", fontSize: 16 }
});