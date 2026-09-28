import React, { useState, useCallback } from "react";
import { View, Text, FlatList, TouchableOpacity, StyleSheet, ActivityIndicator } from "react-native";
import { useFocusEffect } from "@react-navigation/native";
import { getCustomers } from "../api/customerApi";
import { colors } from "../theme";

const formatPrice = (price) => `${Number(price || 0).toLocaleString("vi-VN")} đ`;

export default function CustomerScreen({ navigation }) {
  const [customers, setCustomers] = useState([]);
  const [loading, setLoading] = useState(true);

  useFocusEffect(
    useCallback(() => {
      getCustomers()
        .then((data) => setCustomers(data))
        .catch(() => {})
        .finally(() => setLoading(false));
    }, [])
  );

  const renderItem = ({ item }) => (
    <View style={styles.card}>
      <View style={styles.info}>
        <Text style={styles.text}><Text style={styles.bold}>Customer:</Text> {item.name}</Text>
        <Text style={styles.text}><Text style={styles.bold}>Phone:</Text> {item.phone}</Text>
        <Text style={styles.text}>
          <Text style={styles.bold}>Total money:</Text> <Text style={styles.price}>{formatPrice(item.totalSpent)}</Text>
        </Text>
      </View>
      <View style={styles.loyalty}>
        <Text style={styles.crown}>👑</Text>
        <Text style={styles.loyaltyText}>{item.loyalty || "Guest"}</Text>
      </View>
    </View>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Customer</Text>
      </View>
      {loading ? <ActivityIndicator style={{ marginTop: 20 }} color={colors.primary} /> : (
        <FlatList data={customers} keyExtractor={(item) => item._id} renderItem={renderItem} contentContainerStyle={{ padding: 16 }} />
      )}
      <TouchableOpacity style={styles.fab} onPress={() => navigation.navigate("AddCustomer")}>
        <Text style={styles.fabIcon}>+</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  header: { backgroundColor: colors.primary, paddingTop: 50, paddingBottom: 16, paddingHorizontal: 16 },
  headerTitle: { color: colors.white, fontSize: 18, fontWeight: "bold" },
  card: { backgroundColor: colors.white, padding: 16, borderRadius: 8, marginBottom: 12, flexDirection: "row", borderWidth: 1, borderColor: colors.border },
  info: { flex: 1 },
  text: { fontSize: 14, marginBottom: 4 },
  bold: { fontWeight: "bold" },
  price: { color: colors.primary, fontWeight: "bold" },
  loyalty: { justifyContent: "center", alignItems: "center", paddingLeft: 10 },
  crown: { fontSize: 24, color: colors.primary },
  loyaltyText: { fontSize: 12, color: colors.primary, fontWeight: "bold", textTransform: "capitalize" },
  fab: { position: "absolute", bottom: 20, right: 20, backgroundColor: colors.primary, width: 56, height: 56, borderRadius: 28, justifyContent: "center", alignItems: "center" },
  fabIcon: { color: colors.white, fontSize: 24, fontWeight: "bold" }
});