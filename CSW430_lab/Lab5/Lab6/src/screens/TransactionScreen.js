import React, { useState, useCallback } from "react";
import { View, Text, FlatList, TouchableOpacity, StyleSheet, ActivityIndicator } from "react-native";
import { useFocusEffect } from "@react-navigation/native";
import { getTransactions } from "../api/transactionApi";
import { colors } from "../theme";

const formatPrice = (price) => `${Number(price || 0).toLocaleString("vi-VN")} đ`;
const formatDate = (iso) => iso ? new Date(iso).toLocaleString("vi-VN") : "";

export default function TransactionScreen({ navigation }) {
  const [transactions, setTransactions] = useState([]);
  const [loading, setLoading] = useState(true);

  useFocusEffect(
    useCallback(() => {
      getTransactions()
        .then(setTransactions)
        .catch(() => {})
        .finally(() => setLoading(false));
    }, [])
  );

  const renderItem = ({ item }) => {
    const isCancelled = item.status === "cancelled";
    return (
      <TouchableOpacity style={styles.card} onPress={() => navigation.navigate("TransactionDetail", { id: item._id })}>
        <View style={styles.rowBetween}>
          <Text style={styles.idText}>{item.id || item._id} - {formatDate(item.createdAt)}</Text>
          {isCancelled && <Text style={styles.cancelled}>Cancelled</Text>}
        </View>
        {item.services?.map((srv, idx) => (
          <Text key={idx} style={styles.serviceText} numberOfLines={1}>- {srv.name}</Text>
        ))}
        <View style={styles.rowBetween}>
          <Text style={styles.customerText}>Customer: {item.customer?.name || "Unknown"}</Text>
          <Text style={styles.price}>{formatPrice(item.price)}</Text>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}><Text style={styles.headerTitle}>Transaction</Text></View>
      {loading ? <ActivityIndicator style={{ marginTop: 20 }} color={colors.primary} /> : (
        <FlatList data={transactions} keyExtractor={(item) => item._id} renderItem={renderItem} contentContainerStyle={{ padding: 16 }} />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  header: { backgroundColor: colors.primary, paddingTop: 50, paddingBottom: 16, paddingHorizontal: 16 },
  headerTitle: { color: colors.white, fontSize: 18, fontWeight: "bold" },
  card: { backgroundColor: colors.white, padding: 16, borderRadius: 8, marginBottom: 12, borderWidth: 1, borderColor: colors.border },
  rowBetween: { flexDirection: "row", justifyContent: "space-between", marginBottom: 6 },
  idText: { fontWeight: "bold", fontSize: 12 },
  cancelled: { color: "red", fontWeight: "bold", fontSize: 12 },
  serviceText: { color: "#555", fontSize: 13, marginBottom: 2 },
  customerText: { color: "#777", fontSize: 12, marginTop: 8 },
  price: { color: colors.primary, fontWeight: "bold", fontSize: 14, marginTop: 8 }
});