import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, FlatList, Image, TouchableOpacity, ActivityIndicator, StyleSheet } from 'react-native';

const avatarUrl = (id, gender) => {
  const n = (id % 99) + 1;
  return gender === 'male'
    ? `https://randomuser.me/api/portraits/men/${n}.jpg`
    : `https://randomuser.me/api/portraits/women/${n}.jpg`;
};

export default function UsersScreen({ navigation }) {
  const [users, setUsers] = useState([]);
  const [filtered, setFiltered] = useState([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);       
  const [errorMsg, setErrorMsg] = useState('');         

  useEffect(() => {                                     
    const data = async () => {
      try {
        setLoading(true);
        const res = await fetch('https://dummyjson.com/users');  
        const json = await res.json();
        setUsers(json.users);
        setFiltered(json.users);
      } catch (e) {
        setErrorMsg("Couldn't load data. Please check your connection and try again.");
      } finally {
        setLoading(false);
      }
    };
    data();
  }, []);

  
const handleSearch = (text) => {
  setSearch(text);
  setFiltered(
    users.filter(u =>
      `${u.firstName} ${u.lastName}`.toLowerCase().includes(text.toLowerCase())
    )
  );
};

  if (loading) return <ActivityIndicator />;      

  return (
    <View style = {{flex:1 }}>
      <TextInput
        placeholder="Search users..."
        value={search}
        onChangeText={handleSearch}
        style={styles.search}
      />
      <FlatList
        data={filtered}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => (
          <TouchableOpacity style={styles.row}  
          onPress = {()=> navigation.navigate('UserDetail', {id : item.id})} >
            <Image source={{ uri: avatarUrl(item.id, item.gender) }} style={styles.avatar} />
            <View>
              <Text style={styles.name}>{item.firstName} {item.lastName}</Text>
              <Text style={styles.sub}>{item.age} · {item.gender} · {item.email}</Text>
              <Text style={styles.sub}>City: {item.address.city}</Text>
            </View>
          </TouchableOpacity>
        )}
      />
    </View>
  );
}  

const styles = StyleSheet.create({
  search: { margin: 10, borderWidth: 1, borderColor: '#ccc', borderRadius: 8, padding: 10 },
  row: { flexDirection: 'row', gap: 12, padding: 10, alignItems: 'center', borderWidth:1 , borderColor: '#000', borderRadius: 10, margin: 10 },
  avatar: { width: 50, height: 50, borderRadius: 25 },
  name: { fontWeight: 'bold' },
  sub: { color: '#666', fontSize: 12 },
});







