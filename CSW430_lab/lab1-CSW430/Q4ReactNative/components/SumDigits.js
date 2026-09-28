import React, { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet } from 'react-native';

export default function SumDigits() {
  const [numberStr, setNumberStr] = useState('');
  const [result, setResult] = useState(null);

  const calculateSum = () => {
    if (numberStr.length > 0) {
      const firstDigit = parseInt(numberStr[0]);
      const lastDigit = parseInt(numberStr[numberStr.length - 1]);
      setResult(firstDigit + lastDigit);
    }
  };

  return (
    <View style={styles.card}>
      <Text style={styles.title}>2. Tổng chữ số đầu & cuối</Text>
      <TextInput 
        style={styles.input} 
        placeholder="Nhập một số..." 
        keyboardType="numeric"
        value={numberStr}
        onChangeText={setNumberStr}
      />
      <Button title="Tính tổng" onPress={calculateSum} />
      {result !== null && <Text style={styles.result}>Kết quả: {result}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  card: { padding: 15, marginVertical: 10, backgroundColor: '#efe', borderRadius: 8 },
  title: { fontSize: 16, fontWeight: 'bold', marginBottom: 5 },
  input: { borderWidth: 1, borderColor: '#ccc', padding: 8, marginBottom: 10, borderRadius: 4 },
  result: { marginTop: 10, fontWeight: 'bold', color: 'green' }
});