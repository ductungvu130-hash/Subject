import React, { useCallback, useState } from "react";
import { View, Text, StyleSheet, Alert, ActivityIndicator } from "react-native";
import { useFocusEffect } from "@react-navigation/native";
import {
  Menu,
  MenuOptions,
  MenuOption,
  MenuTrigger,
} from "react-native-popup-menu";
import { getServiceById, deleteService } from "../api/serviceApi";
import { colors } from "../theme";

const formatDate = (iso) => {
  if (!iso) return "";
  const d = new Date(iso);
  return d.toLocaleString("vi-VN");
};

const formatPrice = (price) => `${Number(price).toLocaleString("vi-VN")} đ`;

export default function ServiceDetailScreen({ route, navigation }) {
  const { id } = route.params;
  const [service, setService] = useState(null);
  const [loading, setLoading] = useState(true);

  const load = async () => {
    try {
      const data = await getServiceById(id);
      setService(data);
    } catch (err) {
      Alert.alert("Lỗi", "Không tải được dữ liệu dịch vụ");
    } finally {
      setLoading(false);
    }
  };

  useFocusEffect(
    useCallback(() => {
      load();
    }, [id])
  );

  const handleDelete = () => {
    Alert.alert(
      "Warning",
      "Are you sure you want to remove this service? This operation cannot be returned",
      [
        { text: "CANCEL", style: "cancel" },
        {
          text: "DELETE",
          style: "destructive",
          onPress: async () => {
            try {
              await deleteService(id);
              navigation.goBack();
            } catch (err) {
              Alert.alert("Lỗi", "Không thể xoá dịch vụ");
            }
          },
        },
      ]
    );
  };

  if (loading) {
    return (
      <View style={styles.center}>
        <ActivityIndicator color={colors.primary} />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.back} onPress={() => navigation.goBack()}>
          {"←"}
        </Text>
        <Text style={styles.headerTitle}>Service detail</Text>

        <Menu>
          <MenuTrigger>
            <Text style={styles.dots}>⋮</Text>
          </MenuTrigger>
          <MenuOptions>
            <MenuOption
              onSelect={() => navigation.navigate("EditService", { service })}
              text="Edit"
            />
            <MenuOption onSelect={handleDelete} text="Delete" />
          </MenuOptions>
        </Menu>
      </View>

      {service && (
        <View style={styles.body}>
          <Text style={styles.row}>
            <Text style={styles.label}>Service name: </Text>
            {service.name}
          </Text>
          <Text style={styles.row}>
            <Text style={styles.label}>Price: </Text>
            {formatPrice(service.price)}
          </Text>
          <Text style={styles.row}>
            <Text style={styles.label}>Creator: </Text>
            {service.createdBy}
          </Text>
          <Text style={styles.row}>
            <Text style={styles.label}>Time: </Text>
            {formatDate(service.createdAt)}
          </Text>
          <Text style={styles.row}>
            <Text style={styles.label}>Final update: </Text>
            {formatDate(service.updatedAt)}
          </Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.background },
  center: { flex: 1, justifyContent: "center", alignItems: "center" },
  header: {
    backgroundColor: colors.primary,
    paddingTop: 50,
    paddingBottom: 16,
    paddingHorizontal: 16,
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-between",
  },
  back: { color: colors.white, fontSize: 22 },
  headerTitle: { color: colors.white, fontSize: 17, fontWeight: "bold" },
  dots: { color: colors.white, fontSize: 20, fontWeight: "bold" },
  body: { padding: 20 },
  row: { fontSize: 13, marginBottom: 10, lineHeight: 18 },
  label: { fontWeight: "bold" },
});
