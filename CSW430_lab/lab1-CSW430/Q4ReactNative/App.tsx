import React from 'react';
import { SafeAreaView, ScrollView, StyleSheet, Text } from 'react-native';
import Employee from './components/Employee';
import SumDigits from './components/SumDigits';
import FindMin from './components/FindMin';
import Hailstone from './components/Hailstone';

export default function App() {
  return (
    <SafeAreaView style={styles.container}>
      <ScrollView contentContainerStyle={styles.scroll}>
        <Text style={styles.header}>LAB 1 - QUESTION 6</Text>
        
        <Employee fullName="Nguyen Van A" age={20} occupation="Sinh viên CNTT" />
        
       
        <SumDigits />
        <FindMin />
        <Hailstone />
        
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff' },
  scroll: { padding: 20 },
  header: { fontSize: 22, fontWeight: 'bold', textAlign: 'center', marginBottom: 20 }
});