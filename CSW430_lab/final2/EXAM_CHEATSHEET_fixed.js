// ========================================================
// CSW430 FINAL CHEATSHEET - TÀI LIỆU ÔN TẬP TRƯỚC GIỜ THI
// Không mang vào phòng thi - đề đóng, chỉ được tra 6 trang docs cho phép.
// Tất cả chỗ cần đổi theo đề đều có dấu: ← ĐỔI
// ========================================================


// ████████████████████████████████████████████████████████
// █  PHẦN 0: PACKAGE.JSON - DEPENDENCIES CẦN CÀI         █
// ████████████████████████████████████████████████████████

/*
CÁCH 1 (khuyên dùng, an toàn hơn): mở tab "Dependencies" (icon package)
bên trái màn hình Snack, gõ từng tên package bên dưới vào ô search, bấm
để thêm. Snack tự chọn đúng version tương thích với SDK Expo hiện tại.

  @react-navigation/native
  @react-navigation/native-stack
  react-native-screens
  react-native-safe-area-context

CÁCH 2 (nếu tab Dependencies lỗi/không tìm ra): mở thẳng file package.json
có sẵn trong Snack, thêm 4 dòng vào "dependencies" (giữ nguyên các dòng
"expo"/"react"/"react-native" đã có sẵn, KHÔNG xóa chúng), dùng dấu "*"
để Snack tự chọn version tương thích, đỡ lo pin sai version:

{
  "dependencies": {
    "@react-navigation/native": "*",
    "@react-navigation/native-stack": "*",
    "react-native-screens": "*",
    "react-native-safe-area-context": "*"
  }
}

Lưu ý: App.js PHẢI là file gốc (entry file) Snack tự nhận diện - không
đổi tên file này. Các screen khác nên để trong thư mục screens/ (ví dụ
screens/ListScreen.js) và luôn có "export default function ..." ở đầu.
*/


// ████████████████████████████████████████████████████████
// █  PHẦN 1: APP.JS                                     █
// ████████████████████████████████████████████████████████


import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import ListScreen from './screens/ListScreen';           // ← ĐỔI tên file
import DetailScreen from './screens/DetailScreen';       // ← ĐỔI tên file
import AddScreen from './screens/AddScreen';             // ← ĐỔI tên file (nếu đề có Add)
import EditScreen from './screens/EditScreen';           // ← ĐỔI tên file (nếu đề có Edit)
// import CartScreen from './screens/CartScreen';        // ← Thêm nếu đề có screen phụ

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="List">
        <Stack.Screen name="List" component={ListScreen}
          options={{ title: 'Events' }} />               {/* ← ĐỔI title */}
<Stack.Screen name="Detail" component={DetailScreen}
  options={{ title: 'Event Detail' }} />          {/* ← ĐỔI title */ }
<Stack.Screen name="Add" component={AddScreen}
  options={{ title: 'Add Event' }} />             {/* ← ĐỔI title */ }
<Stack.Screen name="Edit" component={EditScreen}
  options={{ title: 'Edit Event' }} />            {/* ← ĐỔI title */ }
{/* <Stack.Screen name="Cart" component={CartScreen}
          options={{ title: 'Cart Detail' }} /> */}
      </Stack.Navigator >
    </NavigationContainer >
  );
}



// ████████████████████████████████████████████████████████
// █  PHẦN 2: LIST SCREEN - DẠNG CÓ CRUD (Add/Edit/Del) █
// █  Mẫu: đề Events                                    █
// ████████████████████████████████████████████████████████


import React, { useState, useCallback } from 'react';
import {
  View, Text, FlatList, Image,
  TouchableOpacity, ActivityIndicator, Alert, StyleSheet
} from 'react-native';
import { useFocusEffect } from '@react-navigation/native';

export default function ListScreen({ navigation }) {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useFocusEffect(
    useCallback(() => { fetchData(); }, [])
  );

  const fetchData = async () => {
    try {
      setLoading(true);
      setError('');
      const res = await fetch('https://dummyjson.com/posts');  // ← ĐỔI API URL
      if (!res.ok) throw new Error();
      const json = await res.json();
      setItems(json.posts);                                    // ← ĐỔI field: json.posts / json.users / json.products
    } catch (e) {
      setError("Couldn't load data. Please check your connection and try again.");  // ← ĐỔI message nếu đề cho
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = (id) => {
    Alert.alert('Confirm', 'Delete this event?', [             // ← ĐỔI message
      { text: 'CANCEL', style: 'cancel' },
      {
        text: 'DELETE', style: 'destructive',
        onPress: async () => {
          try {
            await fetch(`https://dummyjson.com/posts/${id}`, { method: 'DELETE' });  // ← ĐỔI API URL
            fetchData();
          } catch (e) {
            Alert.alert('Error', "Couldn't save. Please check your connection and try again.");
          }
        },
      },
    ]);
  };

  if (loading) return <ActivityIndicator size="large" style={{ flex: 1 }} />;
  if (error) return <Text style={{ color: 'red', textAlign: 'center', marginTop: 40 }}>{error}</Text>;

  return (
    <View style={{ flex: 1 }}>
      <Text style={s.header}>Event Management</Text>          {/* ← ĐỔI tiêu đề */}
<FlatList
  data={items}
  keyExtractor={(item) => item.id.toString()}
  renderItem={({ item }) => (
    <View style={s.card}>
      <Image
        source={{ uri: `https://picsum.photos/seed/${item.id}/600/360` }}  // ← ĐỔI image URL
        style={s.img} />
      <Text style={s.title}>{item.title}</Text>          {/* ← ĐỔI field hiển thị */}
      <Text style={s.tags}>                              {/* ← ĐỔI field hiển thị */}
        {(item.tags || []).join(' · ')}
      </Text>
      <View style={s.btnRow}>
        <TouchableOpacity style={s.btn}
          onPress={() => navigation.navigate('Detail', { id: item.id })}>
          <Text>Details</Text>
        </TouchableOpacity>
        <TouchableOpacity style={s.btn}
          onPress={() => navigation.navigate('Edit', { id: item.id })}>
          <Text>Edit</Text>
        </TouchableOpacity>
        <TouchableOpacity style={[s.btn, { backgroundColor: '#e74c3c' }]}
          onPress={() => handleDelete(item.id)}>
          <Text style={{ color: '#fff' }}>Delete</Text>
        </TouchableOpacity>
      </View>
    </View>
  )}
  ListFooterComponent={
    <TouchableOpacity style={s.addBtn}
      onPress={() => navigation.navigate('Add')}>
      <Text style={{ color: '#fff', fontSize: 24 }}>+</Text>
    </TouchableOpacity>
  }
/>
    </View >
  );
}

const s = StyleSheet.create({
  header: { fontSize: 22, fontWeight: 'bold', padding: 16 },
  card: { margin: 10, borderRadius: 10, backgroundColor: '#fff', borderWidth: 1, borderColor: '#ddd', overflow: 'hidden' },
  img: { width: '100%', height: 180 },
  title: { fontWeight: 'bold', fontSize: 15, paddingHorizontal: 10, paddingTop: 8 },
  tags: { color: '#888', paddingHorizontal: 10, fontSize: 12, paddingBottom: 4 },
  btnRow: { flexDirection: 'row', gap: 8, padding: 10 },
  btn: { borderWidth: 1, borderColor: '#ccc', borderRadius: 6, paddingVertical: 6, paddingHorizontal: 14 },
  addBtn: { backgroundColor: '#333', margin: 10, width: 50, height: 50, borderRadius: 25, justifyContent: 'center', alignItems: 'center', alignSelf: 'center' },
});



// ████████████████████████████████████████████████████████
// █  PHẦN 3: LIST SCREEN - DẠNG CHỈ XEM (Search+Tap)   █
// █  Mẫu: đề Users                                     █
// ████████████████████████████████████████████████████████


import React, { useState, useEffect } from 'react';
import {
  View, Text, TextInput, FlatList, Image,
  TouchableOpacity, ActivityIndicator, StyleSheet
} from 'react-native';

// ← ĐỔI hàm này nếu đề cho cách tạo avatar khác
const avatarUrl = (id, gender) => {
  const n = (id % 99) + 1;
  return gender === 'male'
    ? `https://randomuser.me/api/portraits/men/${n}.jpg`     // ← ĐỔI nếu đề cho URL khác
    : `https://randomuser.me/api/portraits/women/${n}.jpg`;  // ← ĐỔI nếu đề cho URL khác
};

export default function ListScreen({ navigation }) {
  const [items, setItems] = useState([]);
  const [filtered, setFiltered] = useState([]);
  const [search, setSearch] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    (async () => {
      try {
        setLoading(true);
        const res = await fetch('https://dummyjson.com/users');  // ← ĐỔI API URL
        if (!res.ok) throw new Error();
        const json = await res.json();
        setItems(json.users);                                    // ← ĐỔI field: json.users / json.posts
        setFiltered(json.users);                                 // ← ĐỔI field (giống trên)
      } catch (e) {
        setError("Couldn't load data. Please check your connection and try again.");
      } finally {
        setLoading(false);
      }
    })();
  }, []);

  const handleSearch = (text) => {
    setSearch(text);
    setFiltered(
      items.filter(u =>
        `${u.firstName} ${u.lastName}`                           // ← ĐỔI field search: firstName+lastName / title / name
          .toLowerCase().includes(text.toLowerCase())
      )
    );
  };

  if (loading) return <ActivityIndicator size="large" style={{ flex: 1 }} />;
  if (error) return <Text style={{ color: 'red', textAlign: 'center', marginTop: 40 }}>{error}</Text>;

  return (
    <View style={{ flex: 1 }}>
      <TextInput placeholder="Search users..."                  // ← ĐỔI placeholder
        value={search} onChangeText={handleSearch} style={s.search} />
      <View style={s.headerRow}>
        <Text>All users</Text>                                   {/* ← ĐỔI text */}
<Text>Total {filtered.length}</Text>
      </View >
  <FlatList
    data={filtered}
    keyExtractor={(item) => item.id.toString()}
    renderItem={({ item }) => (
      <TouchableOpacity style={s.row}
        onPress={() => navigation.navigate('Detail', { id: item.id })}>
        <Image source={{ uri: avatarUrl(item.id, item.gender) }} style={s.avatar} />
        <View>
          <Text style={s.name}>                              {/* ← ĐỔI fields hiển thị */}
            {item.firstName} {item.lastName}
          </Text>
          <Text style={s.sub}>                               {/* ← ĐỔI fields hiển thị */}
            {item.age} · {item.gender} · {item.email}
          </Text>
          <Text style={s.sub}>City: {item.address.city}</Text> {/* ← ĐỔI fields hiển thị */}
        </View>
      </TouchableOpacity>
    )}
    ListEmptyComponent={
      <Text style={{ textAlign: 'center', marginTop: 20 }}>No users found.</Text>  // ← ĐỔI message
    }
  />
    </View >
  );
}

const s = StyleSheet.create({
  search: { margin: 10, borderWidth: 1, borderColor: '#ccc', borderRadius: 8, padding: 10, backgroundColor: '#fff' },
  headerRow: { flexDirection: 'row', justifyContent: 'space-between', paddingHorizontal: 14, paddingVertical: 6 },
  row: { flexDirection: 'row', gap: 12, padding: 10, alignItems: 'center', borderWidth: 1, borderColor: '#000', borderRadius: 10, margin: 10, backgroundColor: '#fff' },
  avatar: { width: 50, height: 50, borderRadius: 25 },
  name: { fontWeight: 'bold' },
  sub: { color: '#666', fontSize: 12 },
});



// ████████████████████████████████████████████████████████
// █  PHẦN 4: DETAIL SCREEN - DẠNG ĐƠN GIẢN             █
// █  Mẫu: đề Events (ảnh + text + reactions)            █
// ████████████████████████████████████████████████████████


import React, { useState, useEffect } from 'react';
import { View, Text, Image, ScrollView, ActivityIndicator } from 'react-native';

export default function DetailScreen({ route }) {
  const { id } = route.params;
  const [item, setItem] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    (async () => {
      try {
        setLoading(true);
        const res = await fetch(`https://dummyjson.com/posts/${id}`);  // ← ĐỔI API URL
        if (!res.ok) throw new Error();
        setItem(await res.json());
      } catch (e) {
        setError('Event information not available.');                   // ← ĐỔI message
      } finally {
        setLoading(false);
      }
    })();
  }, [id]);

  if (loading) return <ActivityIndicator size="large" style={{ flex: 1 }} />;
  if (error || !item) return <Text style={{ color: 'red', textAlign: 'center', marginTop: 40 }}>{error}</Text>;

  return (
    <ScrollView style={{ padding: 16 }}>
      <Image
        source={{ uri: `https://picsum.photos/seed/${item.id}/600/360` }}  // ← ĐỔI image URL
        style={{ width: '100%', height: 200, borderRadius: 10 }} />
      <Text style={{ fontSize: 20, fontWeight: 'bold', marginTop: 12 }}>
        {item.title}                                                       {/* ← ĐỔI field */}
      </Text >
  <Text style={{ color: '#888', marginTop: 4 }}>
    {(item.tags || []).join(' · ')}                                    {/* ← ĐỔI field */}
  </Text>

{/* reactions: có thể là object {likes,dislikes} hoặc number */ }
{
  typeof item.reactions === 'object' && item.reactions !== null    /* ← typeof null cũng ra 'object', phải check thêm !== null */
  ? <Text style={{ marginTop: 8 }}>
    Likes: {item.reactions.likes} · Dislikes: {item.reactions.dislikes}
  </Text>
  : <Text style={{ marginTop: 8 }}>Reactions: {item.reactions}</Text>
}

<Text style={{ marginTop: 12, lineHeight: 22 }}>
  {item.body}                                                        {/* ← ĐỔI field */}
</Text>
    </ScrollView >
  );
}



// ████████████████████████████████████████████████████████
// █  PHẦN 5: DETAIL SCREEN - DẠNG CÓ DATA PHỤ          █
// █  Mẫu: đề Users (info + cart section)                █
// ████████████████████████████████████████████████████████


import React, { useState, useEffect } from 'react';
import { View, Text, Image, TouchableOpacity, ScrollView, ActivityIndicator, StyleSheet } from 'react-native';

const avatarUrl = (id, gender) => {                       // ← ĐỔI nếu đề cho avatar URL khác
  const n = (id % 99) + 1;
  return gender === 'male'
    ? `https://randomuser.me/api/portraits/men/${n}.jpg`
    : `https://randomuser.me/api/portraits/women/${n}.jpg`;
};

export default function DetailScreen({ route, navigation }) {
  const { id } = route.params;
  const [item, setItem] = useState(null);
  const [extra, setExtra] = useState(null);               // ← ĐỔI tên: cart / transactions / orders
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    (async () => {
      try {
        setLoading(true);
        // Fetch chính
        const res = await fetch(`https://dummyjson.com/users/${id}`);          // ← ĐỔI API URL
        if (!res.ok) throw new Error();
        setItem(await res.json());

        // Fetch phụ (cart/order/transaction)
        const extraRes = await fetch(`https://dummyjson.com/users/${id}/carts`);  // ← ĐỔI API URL phụ
        const extraJson = await extraRes.json();
        setExtra(extraJson.carts?.[0] || null);                                   // ← ĐỔI field: .carts / .orders
      } catch (e) {
        setError('User information not available.');                               // ← ĐỔI message
      } finally {
        setLoading(false);
      }
    })();
  }, [id]);

  if (loading) return <ActivityIndicator size="large" style={{ flex: 1 }} />;
  if (error || !item) return <Text style={{ color: 'red', textAlign: 'center', marginTop: 40 }}>{error || 'Information not available.'}</Text>;

  return (
    <ScrollView style={{ padding: 16 }}>
      {/* --- Thông tin chính --- */}
<View style={s.card}>
  <Image source={{ uri: avatarUrl(item.id, item.gender) }} style={s.avatar} />
  <View>
    <Text style={s.name}>{item.firstName} {item.lastName}</Text>     {/* ← ĐỔI fields */}
    <Text style={s.line}>{item.age} · {item.gender} · @{item.username}</Text>  {/* ← ĐỔI fields */}
    <Text style={s.line}>{item.email}</Text>                          {/* ← ĐỔI fields */}
    <Text style={s.line}>{item.phone}</Text>                          {/* ← ĐỔI fields */}
    <Text style={s.line}>City: {item.address.city}</Text>             {/* ← ĐỔI fields */}
    <Text style={s.line}>{item.company.name} - {item.company.title}</Text>  {/* ← ĐỔI fields */}
  </View>
</View>

{/* --- Data phụ (Carts / Orders / Transactions) --- */ }
<Text style={{ paddingTop: 20, fontSize: 20, fontWeight: 'bold' }}>
  Carts                                                               {/* ← ĐỔI tiêu đề */}
</Text>
{
  extra ? (
    <View style={s.extraBox}>
      <Text style={{ fontWeight: 'bold' }}>Cart #{extra.id}</Text>      {/* ← ĐỔI fields */}
      <Text style={s.line}>
        totalProducts: {extra.totalProducts} · totalQuantity: {extra.totalQuantity}  {/* ← ĐỔI fields */}
      </Text>
      <Text style={s.line}>
        total: {extra.total} · discountedTotal: {extra.discountedTotal}              {/* ← ĐỔI fields */}
      </Text>
      <TouchableOpacity
        onPress={() => navigation.navigate('Cart', { userId: item.id })}>           {/* ← ĐỔI screen name + param */}
        <Text style={{ color: '#2f6f4f', marginTop: 10 }}>Tap to view products →</Text>
      </TouchableOpacity>
    </View>
  ) : (
    <Text style={{ marginTop: 10 }}>No cart available.</Text>           // ← ĐỔI message
  )
}
    </ScrollView >
  );
}

const s = StyleSheet.create({
  card: { flexDirection: 'row', borderWidth: 1, borderColor: '#2f6f4f', borderRadius: 8, padding: 10, backgroundColor: '#fff' },
  avatar: { width: 90, height: 90, borderRadius: 45, marginRight: 15, alignSelf: 'center' },
  name: { fontSize: 18, fontWeight: 'bold' },
  line: { color: '#444', marginTop: 4 },
  extraBox: { borderWidth: 1, borderColor: '#000', borderRadius: 10, padding: 12, marginTop: 10, backgroundColor: '#fff' },
});



// ████████████████████████████████████████████████████████
// █  PHẦN 6: ADD SCREEN (form + POST + validation)      █
// ████████████████████████████████████████████████████████


import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, ActivityIndicator, Alert, ScrollView, StyleSheet } from 'react-native';

export default function AddScreen({ navigation }) {
  const [field1, setField1] = useState('');    // ← ĐỔI: title / name
  const [field2, setField2] = useState('');    // ← ĐỔI: description / price / body
  const [field3, setField3] = useState('');    // ← ĐỔI: tags / phone (nếu có)
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState({});

  // --- VALIDATION (Q3 - 10 điểm) ---
  const validate = () => {
    const e = {};
    if (!field1.trim() || field1.trim().length < 3) e.field1 = 'Title must be at least 3 characters';  // ← ĐỔI rule + message (nhớ .trim() tránh pass validate với chuỗi toàn dấu cách)
    if (!field2.trim() || field2.trim().length < 10) e.field2 = 'Description must be at least 10 characters';  // ← ĐỔI rule + message
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const handleAdd = async () => {
    if (!validate()) return;
    try {
      setLoading(true);
      const res = await fetch('https://dummyjson.com/posts/add', {  // ← ĐỔI API URL
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          title: field1,                                             // ← ĐỔI field names theo API
          body: field2,                                              // ← ĐỔI field names theo API
          tags: field3.split(',').map(t => t.trim()).filter(Boolean), // ← ĐỔI hoặc bỏ nếu không cần
          userId: 1,                                                 // ← ĐỔI nếu API cần userId khác
        }),
      });
      if (!res.ok) throw new Error();
      navigation.navigate('List');                                   // ← ĐỔI tên screen chính
    } catch (e) {
      Alert.alert('Error', "Couldn't save. Please check your connection and try again.");  // ← ĐỔI message nếu đề cho
    } finally {
      setLoading(false);
    }
  };

  return (
    <ScrollView style={{ padding: 16 }}>
      <Text style={f.h}>Event Info</Text>                           {/* ← ĐỔI tiêu đề */}

<Text style={f.l}>Title *</Text>                              {/* ← ĐỔI label */ }
<TextInput style={[f.i, errors.field1 && f.ie]}
  value={field1} onChangeText={setField1}
  placeholder="Tech Conference 2025" />                        {/* ← ĐỔI placeholder */ }
{ errors.field1 && <Text style={f.e}>{errors.field1}</Text> }

<Text style={f.l}>Description *</Text>                        {/* ← ĐỔI label */ }
<TextInput style={[f.i, f.ta, errors.field2 && f.ie]}
  value={field2} onChangeText={setField2}
  placeholder="Annual event focusing on innovations..."        // ← ĐỔI placeholder
  multiline numberOfLines={4} />
{ errors.field2 && <Text style={f.e}>{errors.field2}</Text> }

<Text style={f.l}>Tags (comma-separated)</Text>               {/* ← ĐỔI label */ }
<TextInput style={f.i}
  value={field3} onChangeText={setField3}
  placeholder="Technology, Conference" />                       {/* ← ĐỔI placeholder */ }

{
  loading ? <ActivityIndicator style={{ marginTop: 20 }} /> : (
    <TouchableOpacity style={f.btn} onPress={handleAdd}>
      <Text style={f.btnT}>Add Event</Text>                     {/* ← ĐỔI text nút */}
    </TouchableOpacity>
  )
}
    </ScrollView >
  );
}

const f = StyleSheet.create({
  h: { fontSize: 20, fontWeight: 'bold', marginBottom: 12 },
  l: { fontWeight: 'bold', marginTop: 12, marginBottom: 4 },
  i: { borderWidth: 1, borderColor: '#ccc', borderRadius: 8, padding: 12, backgroundColor: '#fff' },
  ie: { borderColor: 'red' },
  ta: { height: 100, textAlignVertical: 'top' },
  e: { color: 'red', fontSize: 12, marginTop: 2 },
  btn: { backgroundColor: '#e74c3c', padding: 14, borderRadius: 8, alignItems: 'center', marginTop: 20 },
  btnT: { color: '#fff', fontWeight: 'bold', fontSize: 16 },
});



// ████████████████████████████████████████████████████████
// █  PHẦN 7: EDIT SCREEN (pre-fill + PUT + validation)  █
// █  Giống Add nhưng thêm: useEffect load data cũ       █
// ████████████████████████████████████████████████████████


import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, TouchableOpacity, ActivityIndicator, Alert, ScrollView, StyleSheet } from 'react-native';

export default function EditScreen({ route, navigation }) {
  const { id } = route.params;
  const [field1, setField1] = useState('');    // ← ĐỔI: title / name
  const [field2, setField2] = useState('');    // ← ĐỔI: description / price
  const [field3, setField3] = useState('');    // ← ĐỔI: tags / phone
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [errors, setErrors] = useState({});

  // PRE-FILL: load dữ liệu cũ từ API
  useEffect(() => {
    (async () => {
      try {
        const res = await fetch(`https://dummyjson.com/posts/${id}`);  // ← ĐỔI API URL
        if (!res.ok) throw new Error();
        const json = await res.json();
        setField1(json.title || '');                                    // ← ĐỔI field: json.title / json.name
        setField2(json.body || '');                                     // ← ĐỔI field: json.body / json.description
        setField3((json.tags || []).join(', '));                         // ← ĐỔI field: json.tags / json.phone
      } catch (e) {
        Alert.alert('Error', "Couldn't load data. Please check your connection and try again.");
        navigation.goBack();
      } finally {
        setLoading(false);
      }
    })();
  }, [id]);

  const validate = () => {
    const e = {};
    if (!field1.trim() || field1.trim().length < 3) e.field1 = 'Title must be at least 3 characters';  // ← ĐỔI rule + message (nhớ .trim() tránh pass validate với chuỗi toàn dấu cách)
    if (!field2.trim() || field2.trim().length < 10) e.field2 = 'Description must be at least 10 characters';  // ← ĐỔI rule + message
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const handleUpdate = async () => {
    if (!validate()) return;
    try {
      setSaving(true);
      const res = await fetch(`https://dummyjson.com/posts/${id}`, {  // ← ĐỔI API URL
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          title: field1,                                               // ← ĐỔI field names theo API
          body: field2,                                                // ← ĐỔI field names theo API
          tags: field3.split(',').map(t => t.trim()).filter(Boolean),   // ← ĐỔI hoặc bỏ nếu không cần
        }),
      });
      if (!res.ok) throw new Error();
      navigation.navigate('List');                                     // ← ĐỔI tên screen chính
    } catch (e) {
      Alert.alert('Error', "Couldn't save. Please check your connection and try again.");
    } finally {
      setSaving(false);
    }
  };

  if (loading) return <ActivityIndicator size="large" style={{ flex: 1 }} />;

  return (
    <ScrollView style={{ padding: 16 }}>
      <Text style={f.h}>Event Info</Text>                             {/* ← ĐỔI tiêu đề */}

<Text style={f.l}>Title *</Text>                                {/* ← ĐỔI label */ }
<TextInput style={[f.i, errors.field1 && f.ie]}
  value={field1} onChangeText={setField1} />
{ errors.field1 && <Text style={f.e}>{errors.field1}</Text> }

<Text style={f.l}>Description *</Text>                          {/* ← ĐỔI label */ }
<TextInput style={[f.i, f.ta, errors.field2 && f.ie]}
  value={field2} onChangeText={setField2}
  multiline numberOfLines={4} />
{ errors.field2 && <Text style={f.e}>{errors.field2}</Text> }

<Text style={f.l}>Tags (comma-separated)</Text>                 {/* ← ĐỔI label */ }
<TextInput style={f.i} value={field3} onChangeText={setField3} />

{
  saving ? <ActivityIndicator style={{ marginTop: 20 }} /> : (
    <TouchableOpacity style={f.btn} onPress={handleUpdate}>
      <Text style={f.btnT}>Update Event</Text>                    {/* ← ĐỔI text nút */}
    </TouchableOpacity>
  )
}
    </ScrollView >
  );
}

const f = StyleSheet.create({
  h: { fontSize: 20, fontWeight: 'bold', marginBottom: 12 },
  l: { fontWeight: 'bold', marginTop: 12, marginBottom: 4 },
  i: { borderWidth: 1, borderColor: '#ccc', borderRadius: 8, padding: 12, backgroundColor: '#fff' },
  ie: { borderColor: 'red' },
  ta: { height: 100, textAlignVertical: 'top' },
  e: { color: 'red', fontSize: 12, marginTop: 2 },
  btn: { backgroundColor: '#e74c3c', padding: 14, borderRadius: 8, alignItems: 'center', marginTop: 20 },
  btnT: { color: '#fff', fontWeight: 'bold', fontSize: 16 },
});



// ████████████████████████████████████████████████████████
// █  PHẦN 8: SUB-LIST SCREEN (FlatList sản phẩm/items) █
// █  Mẫu: Cart Detail (đề Users)                       █
// ████████████████████████████████████████████████████████


import React, { useState, useEffect } from 'react';
import { View, Text, Image, FlatList, ActivityIndicator, StyleSheet } from 'react-native';

export default function SubListScreen({ route }) {
  const { userId } = route.params;                        // ← ĐỔI param name
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    (async () => {
      try {
        setLoading(true);
        const res = await fetch(`https://dummyjson.com/users/${userId}/carts`);  // ← ĐỔI API URL
        if (!res.ok) throw new Error();
        const json = await res.json();
        const data = json.carts?.[0];                                             // ← ĐỔI field
        if (data && data.products) {                                              // ← ĐỔI field
          setItems(data.products);                                                // ← ĐỔI field
        } else {
          setError('This cart has no products.');                                  // ← ĐỔI message
        }
      } catch (e) {
        setError("Couldn't load data. Please check your connection and try again.");
      } finally {
        setLoading(false);
      }
    })();
  }, [userId]);                                            // ← ĐỔI dependency

  if (loading) return <ActivityIndicator size="large" style={{ flex: 1 }} />;
  if (error) return <Text style={{ color: 'red', textAlign: 'center', marginTop: 40 }}>{error}</Text>;

  return (
    <View style={{ flex: 1 }}>
      <Text style={s.header}>Products</Text>               {/* ← ĐỔI tiêu đề */}
<FlatList
  data={items}
  keyExtractor={(item) => item.id.toString()}
  renderItem={({ item }) => (
    <View style={s.card}>
      <Image source={{ uri: item.thumbnail }} style={s.img} />  {/* ← ĐỔI image field */}
      <View style={{ flex: 1 }}>
        <Text style={{ fontWeight: 'bold', marginBottom: 4 }}>
          {item.title}                                           {/* ← ĐỔI field */}
        </Text>
        <View style={{ flexDirection: 'row', gap: 10 }}>
          <Text style={{ fontWeight: 'bold' }}>${item.price}</Text>      {/* ← ĐỔI field */}
          <Text style={{ color: '#888' }}>x{item.quantity}</Text>        {/* ← ĐỔI field */}
        </View>
        <Text style={{ color: '#666', fontSize: 12, marginTop: 4 }}>
          total: ${item.total}  discounted: ${item.discountedTotal}      {/* ← ĐỔI fields */}
        </Text>
      </View>
    </View>
  )}
/>
    </View >
  );
}

const s = StyleSheet.create({
  header: { fontSize: 18, fontWeight: 'bold', padding: 16 },
  card: { flexDirection: 'row', padding: 12, marginHorizontal: 10, marginBottom: 10, borderWidth: 1, borderColor: '#ddd', borderRadius: 8, backgroundColor: '#fff', gap: 12 },
  img: { width: 70, height: 70, borderRadius: 8 },
});



// ████████████████████████████████████████████████████████
// █  PHẦN 9: CÁC DẠNG BIẾN THỂ CÓ THỂ RA (chưa gặp ở 2   █
// █  đề cũ - nếu thấy đề khác khuôn, tra phần này)       █
// ████████████████████████████████████████████████████████

/*
--- 9.1. RESOURCE KHÁC CỦA dummyjson.com (không chỉ posts/users) ---
Công thức fetch/render giữ nguyên y hệt, chỉ đổi URL + tên field
theo đúng JSON mẫu đề cho.

products: { id, title, price, stock, rating, category, brand,
            thumbnail, images:[] }
todos:    { id, todo, completed, userId }
recipes:  { id, name, ingredients:[], instructions:[],
            prepTimeMinutes, image, rating }
comments: { id, body, postId, likes, user:{id, username} }

URL pattern giống hệt posts/users:
  GET  https://dummyjson.com/<resource>
  GET  https://dummyjson.com/<resource>/{id}
  POST https://dummyjson.com/<resource>/add
  PUT  https://dummyjson.com/<resource>/{id}
  DELETE https://dummyjson.com/<resource>/{id}
*/

// --- 9.2. VALIDATE SỐ (Price, Stock, Rating...) - khác validate chuỗi ---
// if (isNaN(Number(price)) || Number(price) <= 0) e.price = 'Price must be a valid positive number';
// Nhớ đổi TextInput sang keyboardType="numeric" cho ô nhập số:
// <TextInput value={price} onChangeText={setPrice} keyboardType="numeric" />

// --- 9.3. TOGGLE / SWITCH (field kiểu true/false, VD "completed") ---
import { Switch } from 'react-native';
function ToggleExample() {
  const [done, setDone] = useState(false);
  return <Switch value={done} onValueChange={setDone} />;
  // Khi submit: body: JSON.stringify({ completed: done })
}

// --- 9.4. FILTER THEO CATEGORY (khác search theo tên chữ) ---
// Vẫn dùng đúng công thức "2 hộp items/filtered" như UsersScreen,
// chỉ đổi điều kiện lọc:
// const filterByCategory = (cat) => {
//   setFiltered(cat === 'all' ? items : items.filter(i => i.category === cat));
// };

// --- 9.5. PULL-TO-REFRESH (kéo xuống để tải lại) ---
// <FlatList
//   ...
//   refreshing={loading}
//   onRefresh={fetchData}   // gọi lại đúng hàm fetch đã có sẵn, không cần viết hàm mới
// />

// --- 9.6. PAGINATION / LOAD MORE (dummyjson hỗ trợ ?limit=&skip=) ---
// <FlatList
//   ...
//   onEndReached={loadMore}
//   onEndReachedThreshold={0.5}
// />
// const loadMore = async () => {
//   const res = await fetch(`https://dummyjson.com/posts?limit=10&skip=${items.length}`);
//   const json = await res.json();
//   setItems(prev => [...prev, ...json.posts]);   // nối thêm vào cuối list cũ
// };

/*
NHẮC LẠI: dù đề đổi resource/field/yêu cầu gì, quy trình vẫn không đổi:
đọc mô tả → vẽ cây UI → ráp state/useEffect/fetch theo đúng công thức
đã học → thêm validate/navigation cuối cùng. 5 mảnh ghép nền tảng
(Component, Props, State, useEffect, Navigation) áp dụng cho MỌI đề.
*/



// ████████████████████████████████████████████████████████
// █  PHẦN 10: TRA NHANH                                 █
// ████████████████████████████████████████████████████████

/*
=== SNIPPETS COPY NHANH ===

--- FETCH ---

const res = await fetch(URL);
const json = await res.json();

--- POST/PUT ---
const res = await fetch(URL, {
  method: 'POST',   // hoặc 'PUT'
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ key: value }),
});

--- DELETE ---
await fetch(`URL/${id}`, { method: 'DELETE' });

--- NAVIGATE ---
navigation.navigate('Screen', { id: item.id });
const { id } = route.params;
navigation.goBack();

--- ALERT CONFIRM ---
Alert.alert('Confirm', 'Delete?', [
  { text: 'CANCEL', style: 'cancel' },
  { text: 'DELETE', style: 'destructive', onPress: () => doIt() },
]);

--- LOADING/ERROR ---
if (loading) return <ActivityIndicator size="large" style={{flex:1}} />;
if (error) return <Text style={{color:'red',textAlign:'center',marginTop:40}}>{error}</Text>;

--- useFocusEffect (refresh khi quay về) ---
import { useFocusEffect } from '@react-navigation/native';
useFocusEffect(useCallback(() => { fetchData(); }, []));

=== ERROR MESSAGES (đề hay dùng) ===
Fetch fail:     "Couldn't load data. Please check your connection and try again."
POST/PUT fail:  "Couldn't save. Please check your connection and try again."
Not found:      "User information not available."  /  "Event information not available."
Empty list:     "No users found."  /  "No events found."
No products:    "This cart has no products."

=== DATA STRUCTURES ===
posts:  { id, title, body, tags:[], reactions:{likes,dislikes}, views, userId }
users:  { id, firstName, lastName, age, gender, email, phone, username,
          address:{city}, company:{name,title} }
carts:  { id, products:[{id, title, price, quantity, total, discountedTotal, thumbnail}],
          total, discountedTotal, totalProducts, totalQuantity }
*/
