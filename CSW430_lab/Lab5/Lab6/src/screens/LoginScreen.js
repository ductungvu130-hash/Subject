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
import AsyncStorage from "@react-native-async-storage/async-storage";
import { login } from "../api/authApi";
import { colors } from "../theme";

export default function LoginScreen({ navigation }) {
  const [phone, setPhone] = useState("");
  const [password, setPassword] = useState("");
  const [showPass, setShowPass] = useState(false);
  const [loading, setLoading] = useState(false);

  const handleLogin = async () => {
    if (!phone || !password) {
      Alert.alert("Thông báo", "Vui lòng nhập đầy đủ số điện thoại và mật khẩu");
      return;
    }
    try {
      setLoading(true);
      const data = await login(phone, password);
      // backend trả về login token, tuỳ field name thực tế: token / accessToken
      const token = data.token || data.accessToken;
      if (!token) throw new Error("Không nhận được token");
      await AsyncStorage.setItem("token", token);
      navigation.reset({ index: 0, routes: [{ name: "Main" }] });
    } catch (err) {
      Alert.alert("Đăng nhập thất bại", "Sai số điện thoại hoặc mật khẩu");
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Login</Text>

      <TextInput
        style={styles.input}
        placeholder="Phone"
        keyboardType="phone-pad"
        value={phone}
        onChangeText={setPhone}
      />

      <View style={styles.passwordWrap}>
        <TextInput
          style={styles.passwordInput}
          placeholder="Password"
          secureTextEntry={!showPass}
          value={password}
          onChangeText={setPassword}
        />
        <TouchableOpacity onPress={() => setShowPass(!showPass)}>
          <Text style={styles.eye}>{showPass ? "🙈" : "👁"}</Text>
        </TouchableOpacity>
      </View>

      <TouchableOpacity style={styles.button} onPress={handleLogin} disabled={loading}>
        {loading ? (
          <ActivityIndicator color={colors.white} />
        ) : (
          <Text style={styles.buttonText}>Login</Text>
        )}
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
    justifyContent: "center",
    paddingHorizontal: 30,
  },
  title: {
    fontSize: 36,
    fontWeight: "bold",
    color: colors.primary,
    textAlign: "center",
    marginBottom: 40,
  },
  input: {
    backgroundColor: colors.white,
    borderRadius: 8,
    paddingHorizontal: 16,
    paddingVertical: 14,
    marginBottom: 16,
    fontSize: 15,
    borderWidth: 1,
    borderColor: colors.border,
  },
  passwordWrap: {
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: colors.white,
    borderRadius: 8,
    paddingHorizontal: 16,
    marginBottom: 24,
    borderWidth: 1,
    borderColor: colors.border,
  },
  passwordInput: {
    flex: 1,
    paddingVertical: 14,
    fontSize: 15,
  },
  eye: {
    fontSize: 18,
  },
  button: {
    backgroundColor: colors.primary,
    borderRadius: 25,
    paddingVertical: 14,
    alignItems: "center",
  },
  buttonText: {
    color: colors.white,
    fontSize: 16,
    fontWeight: "bold",
  },
});
