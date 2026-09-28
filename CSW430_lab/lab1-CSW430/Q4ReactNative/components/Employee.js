import React from 'react';
import { View, Text, Button, Alert, StyleSheet } from 'react-native';

export default function Employee({ fullName, age, occupation }) {
  const handleUpdate = () => {
    Alert.alert("Thành công", "Đã cập nhật thông tin nhân viên!");
  };

  return (
    <View style={styles.card}>
      <Text style={styles.title}>1. Thông tin nhân viên</Text>
      <Text>Họ tên: {fullName}</Text>
      <Text>Tuổi: {age}</Text>
      <Text>Nghề nghiệp: {occupation}</Text>
      <View style={{ marginTop: 10 }}>
        <Button title="Cập nhật" onPress={handleUpdate} />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  card: { padding: 15, marginVertical: 10, backgroundColor: '#eef', borderRadius: 8 },
  title: { fontSize: 16, fontWeight: 'bold', marginBottom: 5 }
});