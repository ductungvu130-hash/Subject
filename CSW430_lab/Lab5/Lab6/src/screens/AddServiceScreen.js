import React, { useState } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  Alert,
  ActivityIndicator,
} from "react-native";
import { addService } from "../api/serviceApi";
import { colors } from "../theme";

export default function AddServiceScreen({ navigation }) {
  const [name, setName] = useState("");
  const [price, setPrice] = useState("0");
  const [loading, setLoading] = useState(false);

  const handleAdd = async () => {
    if (!name.trim()) {
      Alert.alert("Thông báo", "Vui lòng nhập tên dịch vụ");
      return;
    }
    try {
      setLoading(true);
      await addService(name.trim(), Number(price) || 0);
      navigation.goBack();
    } catch (err) {
      Alert.alert("Lỗi", "Không thể thêm dịch vụ, thử lại sau");
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Text style={styles.back}>{"←"}</Text>
        </TouchableOpacity>
        <Text style={styles.headerTitle}>Service</Text>
        <View style={{ width: 20 }} />
      </View>

      <View style={styles.form}>
        <Text style={styles.label}>Service name *</Text>
        <TextInput
          style={styles.input}
          placeholder="Input a service name"
          value={name}
          onChangeText={setName}
        />

        <Text style={styles.label}>Price *</Text>
        <TextInput
          style={styles.input}
          value={price}
          onChangeText={setPrice}
          keyboardType="numeric"
        />

        <TouchableOpacity style={styles.button} onPress={handleAdd} disabled={loading}>
          {loading ? (
            <ActivityIndicator color={colors.white} />
          ) : (
            <Text style={styles.buttonText}>Add</Text>
          )}
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
    paddingHorizontal: 16,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  back: { color: colors.white, fontSize: 22 },
  headerTitle: { color: colors.white, fontSize: 17, fontWeight: "bold" },
  form: { padding: 20 },
  label: { fontWeight: "600", fontSize: 12, marginBottom: 6, marginTop: 12 },
  input: {
    backgroundColor: colors.white,
    borderRadius: 6,
    borderWidth: 1,
    borderColor: colors.border,
    paddingHorizontal: 14,
    paddingVertical: 12,
    fontSize: 14,
  },
  button: {
    backgroundColor: colors.primary,
    borderRadius: 6,
    paddingVertical: 14,
    alignItems: "center",
    marginTop: 24,
  },
  buttonText: { color: colors.white, fontWeight: "bold", fontSize: 15 },
});
