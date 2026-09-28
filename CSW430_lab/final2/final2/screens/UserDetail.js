import React, { useState, useEffect } from 'react';
import { View, Text, Image, TouchableOpacity, ActivityIndicator, StyleSheet } from 'react-native';

const avatarUrl = (id, gender) => {
  const n = (id % 99) + 1;
  return gender === 'male'
    ? `https://randomuser.me/api/portraits/men/${n}.jpg`
    : `https://randomuser.me/api/portraits/women/${n}.jpg`;
};

export default function UserDetail({ route, navigation }) {
  const { id } = route.params;
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [errorMsg, setErrorMsg] = useState('');
  const [cart, setCart] = useState(null);  

  useEffect(() => {
    const detail = async () => {
      try {
        setLoading(true);
        const res = await fetch(`https://dummyjson.com/users/${id}`);
        if (!res.ok) throw new Error();
        const json = await res.json();
        setUser(json);

      const cartRes = await fetch(`https://dummyjson.com/users/${id}/carts`);
      const cartJson = await cartRes.json();
      setCart(cartJson.carts?.[0] || null);

      } catch (e) {
        setErrorMsg('User information not available.');
      } finally {
        setLoading(false);
      }
    };
    detail();   // <-- gọi hàm
  }, [id]);

  if (loading) return <ActivityIndicator size="large" />;
  if (errorMsg || !user) return <Text style={styles.err}>{errorMsg || 'User information not available.'}</Text>;

  return (
    <View style={styles.container}>
    <View style={styles.card}>
      <Image source={{ uri: avatarUrl(user.id, user.gender) }} style={styles.avatar} />
        <View>
          <Text style={styles.name}>{user.firstName} {user.lastName}</Text>
          <Text style={styles.line}>{user.age} · {user.gender} · @{user.username}</Text>
          <Text style={styles.line}>{user.email}</Text>
          <Text style={styles.line}>{user.phone}</Text>
          <Text style={styles.line}>City: {user.address.city}</Text>
          <Text style={styles.line}>{user.company.name} - {user.company.title}</Text>
        </View>
    </View>
       <Text style={styles.head}>Carts</Text>

      {cart && (                                                 
        <View style={styles.cartInfo}>
          <Text style={styles.cartTitle}>Cart #{cart.id}</Text>
          <Text style={styles.line}>totalProducts: {cart.totalProducts} · totalQuantity: {cart.totalQuantity}</Text>
          <Text style={styles.line}>total: {cart.total} · discountedTotal: {cart.discountedTotal}</Text>
          <TouchableOpacity
            style={styles.cartBtn}
            onPress={() => navigation.navigate('CartDetail', { userId: user.id })}
          >
            <Text style={{ color: '#2f6f4f' }}>Tap to view products →</Text>
          </TouchableOpacity>
        </View>
      )}
   
    </View>
  );
}

const styles = StyleSheet.create({
  head: {paddingTop: 20, fontSize: 20, fontWeight: 'bold' },
  card : {flexDirection : 'row', borderWidth: 1, borderColor: '#2f6f4f', borderRadius: 8 ,padding: 10, backgroundColor: "#fff"},
  container: { padding: 16},
  avatar: { width: 90, height: 90, borderRadius: 45 , marginRight: 15, alignSelf : 'center'},
  name: { fontSize: 18, fontWeight: 'bold' },
  line: { color: '#444', marginTop: 4 },
  cartBtn: { marginTop: 10},
  err: { color: 'red', textAlign: 'center', marginTop: 40 },
  cartInfo: { borderWidth: 1, borderColor: '#000', borderRadius: 10, padding: 12, marginBottom: 20, marginTop: 10, backgroundColor: "#fff" },
  cartTitle: { fontWeight: 'bold', marginBottom: 4 },
});