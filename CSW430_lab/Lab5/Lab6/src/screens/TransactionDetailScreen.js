import React, { useState, useCallback } from "react";
import { View, Text, StyleSheet, ActivityIndicator, ScrollView } from "react-native";
import { useFocusEffect } from "@react-navigation/native";
import { getTransactionById } from "../api/transactionApi";
import { colors } from "../theme";

const formatPrice = (price) => `${Number(price || 0).toLocaleString("vi-VN")} đ`;
const formatDate = (iso) => iso ? new Date(iso).toLocaleString("vi-VN") : "";

export default function TransactionDetailScreen({ route, navigation }) {
  const { id } = route.params;
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);

  useFocusEffect(
    useCallback(() => {
      getTransactionById(id)
        .then(setData)
        .catch(() => {})
        .finally(() => setLoading(false));
    }, [id])
  );

  if (loading || !data) return <View style={styles.center}><ActivityIndicator color={colors.primary} /></View>;

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.back} onPress={() => navigation.goBack()}>←</Text>
        <Text style={styles.headerTitle}>Transaction detail</Text>
        <Text style={styles.dots}>⋮</Text>
      </View>

      <ScrollView style={styles.body}>
        <Text style={styles.sectionTitle}>General information</Text>
        <View style={styles.row}><Text>Transaction code</Text><Text style={styles.bold}>{data.id || data._id}</Text></View>
        <View style={styles.row}><Text>Customer</Text><Text style={styles.bold}>{data.customer?.name} - {data.customer?.phone}</Text></View>
        <View style={styles.row}><Text>Creation time</Text><Text style={styles.bold}>{formatDate(data.createdAt)}</Text></View>

        <Text style={styles.sectionTitle}>Services list</Text>
        {data.services?.map((srv, idx) => (
          <View key={idx} style={styles.row}>
            <Text style={{ flex: 1 }}>{srv.name}</Text>
            <Text>x{srv.quantity || 1}</Text>
            <Text style={styles.bold}>{formatPrice(srv.price)}</Text>
          </View>
        ))}
        <View style={[styles.row, { borderTopWidth: 1, borderColor: "#ccc", paddingTop: 10 }]}>
          <Text>Total</Text><Text style={styles.bold}>{formatPrice(data.priceBeforePromotion)}</Text>
        </View>

        <Text style={styles.sectionTitle}>Cost</Text>
        <View style={styles.row}><Text>Amount of money</Text><Text style={styles.bold}>{formatPrice(data.priceBeforePromotion)}</Text></View>
        <View style={styles.row}><Text>Discount</Text><Text style={styles.bold}>{formatPrice((data.priceBeforePromotion || 0) - (data.price || 0))}</Text></View>
        
        <View style={[styles.row, { borderTopWidth: 1, borderColor: "#ccc", paddingTop: 10, marginTop: 10 }]}>
          <Text style={styles.bold}>Total payment</Text>
          <Text style={[styles.bold, { color: colors.primary, fontSize: 16 }]}>{formatPrice(data.price)}</Text>
        </View>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  center: { flex: 1, justifyContent: "center", alignItems: "center" },
  header: { backgroundColor: colors.primary, paddingTop: 50, paddingBottom: 16, paddingHorizontal: 16, flexDirection: "row", justifyContent: "space-between" },
  back: { color: colors.white, fontSize: 22 },
  headerTitle: { color: colors.white, fontSize: 17, fontWeight: "bold" },
  dots: { color: colors.white, fontSize: 20, fontWeight: "bold" },
  body: { padding: 16, backgroundColor: colors.white, margin: 10, borderRadius: 8 },
  sectionTitle: { color: colors.primary, fontWeight: "bold", fontSize: 15, marginTop: 16, marginBottom: 10 },
  row: { flexDirection: "row", justifyContent: "space-between", marginBottom: 12 },
  bold: { fontWeight: "bold" }
});