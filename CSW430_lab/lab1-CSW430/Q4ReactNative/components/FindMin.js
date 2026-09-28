import React, { useState } from 'react';
import { View, Text, TextInput, Button, StyleSheet } from 'react-native';

export default function FindMin() {
  const [n1, setN1] = useState('');
  const [n2, setN2] = useState('');
  const [n3, setN3] = useState('');
  const [minVal, setMinVal] = useState(null);

  const findMinimum = () => {
    if (n1 && n2 && n3) {
      const min = Math.min(Number(n1), Number(n2), Number(n3));
      setMinVal(min);
    }
  };

  return (
    <View style={styles.card}>
      <Text style={styles.title}>3. Tìm số nhỏ nhất</Text>
      <View style={styles.row}>
        <TextInput style={styles.input} placeholder="Số 1" keyboardType="numeric" value={n1} onChangeText={setN1}/>
        <TextInput style={styles.input} placeholder="Số 2" keyboardType="numeric" value={n2} onChangeText={setN2}/>
        <TextInput style={styles.input} placeholder="Số 3" keyboardType="numeric" value={n3} onChangeText={setN3}/>
      </View>
      <Button title="Tìm Min" onPress={findMinimum} />
      {minVal !== null && <Text style={styles.result}>Số nhỏ nhất là: {minVal}</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  card: { padding: 15, marginVertical: 10, backgroundColor: '#fee', borderRadius: 8 },
  title: { fontSize: 16, fontWeight: 'bold', marginBottom: 5 },
  row: { flexDirection: 'row', justifyContent: 'space-between' },
  input: { borderWidth: 1, borderColor: '#ccc', padding: 8, marginBottom: 10, borderRadius: 4, width: '30%' },
  result: { marginTop: 10, fontWeight: 'bold', color: 'red' }
});