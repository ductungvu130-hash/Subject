import React, { useState, useEffect } from 'react';
import { View, Text, FlatList, Image, StyleSheet, TouchableOpacity, SafeAreaView } from 'react-native';

const ProductList = () => {
  const [data, setData] = useState([]);
  const filePath = 'https://dummyjson.com/products/';

  useEffect(() => {
    fetch(filePath)
      .then((response) => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();
      })
      .then((d) => {
        setData(d.products);
      })
      .catch((error) => {
        console.error('Error fetching data:', error);
      });
  }, []);

  const renderItem = ({ item }) => (
    <View style={styles.card}>
      
      <Image source={{ uri: item.thumbnail }} style={styles.image} />
      
      
      <View style={styles.infoContainer}>
        <Text style={styles.title}>Title: {item.title}</Text>
        <Text style={styles.description} numberOfLines={4}>Description: {item.description}</Text>
        <Text style={styles.text}>Price: {item.price}</Text>
        <Text style={styles.discount}>Discount: {item.discountPercentage} off</Text>
        <Text style={styles.text}>Rating: {item.rating}</Text>
        <Text style={styles.text}>Stock: {item.stock}</Text>
        <Text style={styles.text}>Brand: {item.brand}</Text>
        <Text style={styles.text}>Category: {item.category}</Text>
        
        {/* Hàng nút bấm */}
        <View style={styles.buttonRow}>
          <TouchableOpacity style={styles.button}>
            <Text style={styles.buttonText}>DETAIL</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.button}>
            <Text style={styles.buttonText}>ADD</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.button}>
            <Text style={styles.buttonText}>DELETE</Text>
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.headerTitle}>Product list</Text>
      <FlatList
        data={data}
        keyExtractor={(item) => item.id.toString()}
        renderItem={renderItem}
        showsVerticalScrollIndicator={false}
      />
    </SafeAreaView>
  );
};

// --- CSS STYLE ---
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    paddingHorizontal: 16,
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#808080',
    marginTop: 16,
    marginBottom: 16,
  },
  card: {
    flexDirection: 'row',
    backgroundColor: '#F9F9F9',
    marginBottom: 16,
    padding: 10,
  },
  image: {
    width: 100,
    height: 100,
    marginRight: 12,
    resizeMode: 'cover',
  },
  infoContainer: {
    flex: 1,
  },
  title: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
  },
  description: {
    fontSize: 14,
    color: '#666',
    marginVertical: 4,
  },
  text: {
    fontSize: 14,
    color: '#666',
  },
  discount: {
    fontSize: 14,
    color: '#2E7D32', 
    fontWeight: '500',
  },
  buttonRow: {
    flexDirection: 'row',
    marginTop: 8,
  },
  button: {
    backgroundColor: '#2196F3',
    paddingVertical: 6,
    paddingHorizontal: 12,
    marginRight: 8,
    borderRadius: 2,
  },
  buttonText: {
    color: '#FFF',
    fontSize: 12,
    fontWeight: 'bold',
  },
});

export default ProductList;