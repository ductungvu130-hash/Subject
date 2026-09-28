import React, { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet } from 'react-native';

export default function Hailstone() {
  const [nStr, setNStr] = useState('');
  const [sequence, setSequence] = useState([]);

  const generateSequence = () => {
    let n = parseInt(nStr);
    if (isNaN(n) || n <= 0) return;
    
    let arr = [n];
    while (n > 1) {
      if (n % 2 === 0) {
        n = n / 2;
      } else {
        n = (n * 3) + 1;
      }
      arr.push(n);
    }
    setSequence(arr);
  };

  return (
    <View style={styles.card}>
      <Text style={styles.title}>4. Chuỗi Hailstone (n {'>'} 0)</Text>
      <TextInput 
        style={styles.input} 
        placeholder="Nhập số dương n..." 
        keyboardType="numeric"
        value={nStr}
        onChangeText={setNStr}
      />
      <Button title="Tạo chuỗi" onPress={generateSequence} />
      {sequence.length > 0 && (
        <Text style={styles.result}>Chuỗi: {sequence.join(' -> ')}</Text>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  card: { padding: 15, marginVertical: 10, backgroundColor: '#ffe', borderRadius: 8 },
  title: { fontSize: 16, fontWeight: 'bold', marginBottom: 5 },
  input: { borderWidth: 1, borderColor: '#ccc', padding: 8, marginBottom: 10, borderRadius: 4 },
  result: { marginTop: 10, fontWeight: 'bold', color: '#b8860b' }
});