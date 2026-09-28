import React, { useCallback, useState } from "react";
import {
  View,
  Text,
  FlatList,
  TouchableOpacity,
  StyleSheet,
  RefreshControl,
  ActivityIndicator,
} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";
import { useFocusEffect } from "@react-navigation/native";
import { getServices } from "../api/serviceApi";
import { colors } from "../theme";

const CACHE_KEY = "services_cache";

const formatPrice = (price) => `${Number(price).toLocaleString("vi-VN")} đ`;

export default function HomeScreen({ navigation }) {
  const [services, setServices] = useState([]);
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);

  const loadFromCache = async () => {
    const cached = await AsyncStorage.getItem(CACHE_KEY);
    if (cached) setServices(JSON.parse(cached));
  };

  const fetchServices = async () => {
    try {
      const data = await getServices();
      setServices(data);
      await AsyncStorage.setItem(CACHE_KEY, JSON.stringify(data));
    } catch (err) {
      // nếu lỗi mạng thì giữ nguyên dữ liệu cache đã load
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  useFocusEffect(
    useCallback(() => {
      loadFromCache().then(fetchServices);
    }, [])
  );

  const onRefresh = () => {
    setRefreshing(true);
    fetchServices();
  };

  const renderItem = ({ item }) => (
    <TouchableOpacity
      style={styles.item}
      onPress={() => navigation.navigate("ServiceDetail", { id: item._id })}
    >
      <Text style={styles.itemName} numberOfLines={1}>
        {item.name}
      </Text>
      <Text style={styles.itemPrice}>{formatPrice(item.price)}</Text>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>HUYỀN TRINH</Text>
        <View style={styles.avatar}>
          <Text style={{ color: colors.white }}>👤</Text>
        </View>
      </View>

      <Text style={styles.logo}>💮 KAMI SPA</Text>

      <View style={styles.listHeader}>
        <Text style={styles.listTitle}>Danh sách dịch vụ</Text>
        <TouchableOpacity
          style={styles.addBtn}
          onPress={() => navigation.navigate("AddService")}
        >
          <Text style={styles.addBtnText}>+</Text>
        </TouchableOpacity>
      </View>

      {loading ? (
        <ActivityIndicator style={{ marginTop: 40 }} color={colors.primary} />
      ) : (
        <FlatList
          data={services}
          keyExtractor={(item) => item._id}
          renderItem={renderItem}
          contentContainerStyle={{ padding: 16 }}
          refreshControl={
            <RefreshControl refreshing={refreshing} onRefresh={onRefresh} />
          }
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  header: {
    backgroundColor: colors.primary,
    paddingTop: 50,
    paddingBottom: 16,
    paddingHorizontal: 20,
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  headerTitle: { color: colors.white, fontSize: 18, fontWeight: "bold" },
  avatar: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: "rgba(255,255,255,0.3)",
    justifyContent: "center",
    alignItems: "center",
  },
  logo: {
    textAlign: "center",
    fontSize: 20,
    fontWeight: "bold",
    color: colors.primary,
    marginVertical: 12,
  },
  listHeader: {
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
    paddingHorizontal: 16,
  },
  listTitle: { fontWeight: "bold", fontSize: 14 },
  addBtn: {
    width: 28,
    height: 28,
    borderRadius: 14,
    backgroundColor: colors.primary,
    justifyContent: "center",
    alignItems: "center",
  },
  addBtnText: { color: colors.white, fontSize: 18, marginTop: -2 },
  item: {
    backgroundColor: colors.white,
    borderRadius: 8,
    borderWidth: 1,
    borderColor: colors.border,
    padding: 14,
    marginBottom: 10,
    flexDirection: "row",
    justifyContent: "space-between",
    alignItems: "center",
  },
  itemName: { flex: 1, fontWeight: "600", fontSize: 13, marginRight: 8 },
  itemPrice: { fontWeight: "600", fontSize: 13 },
});
