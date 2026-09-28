import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, FlatList, StyleSheet, SafeAreaView } from 'react-native';
import { Card } from 'react-native-paper';

const Product_Search = () => {
  const [data, setData] = useState([]);
  const [value, setValue] = useState('');

  const searchProduct = () => {
    let filePath = 'https://dummyjson.com/products';
    
    if (value !== '') {
      filePath = 'https://dummyjson.com/products/search?q=' + value;
    }
    
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
  };

  const renderItem = ({ item }) => (
    <Card style={styles.card}>
      <Text style={styles.productDetailHeader}>Product Detail</Text>
      <Card.Cover source={{ uri: item.thumbnail }} style={styles.image} />
      
      <Card.Content style={styles.content}>
        <Text style={styles.title}>Title: {item.title}</Text>
        <Text style={styles.description}>Description: {item.description}</Text>
        <Text style={styles.text}>Price: ${item.price}</Text>
        <Text style={styles.text}>Discount: {item.discountPercentage}%</Text>
        <Text style={styles.text}>Rating: {item.rating} stars</Text>
        <Text style={styles.text}>Stock: {item.stock} units</Text>
        <Text style={styles.text}>Brand: {item.brand}</Text>
        <Text style={styles.text}>Category: {item.category}</Text>
      </Card.Content>
    </Card>
  );

  return (
    <SafeAreaView style={styles.container}>
      <Text style={styles.header}>Search Products</Text>
      
      <TextInput
        style={styles.input}
        placeholder="Nhập tên sản phẩm (VD: iphone)"
        value={value}
        onChangeText={setValue}
      />
      
      <TouchableOpacity style={styles.button} onPress={searchProduct}>
        <Text style={styles.buttonText}>SEARCH</Text>
      </TouchableOpacity>

      <FlatList
        data={data}
        keyExtractor={(item) => item.id.toString()}
        renderItem={renderItem}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={styles.listContainer}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
    padding: 16,
  },
  header: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#333',
  },
  input: {
    borderWidth: 0, 
    borderBottomWidth: 1, 
    borderBottomColor: '#E0E0E0',
    paddingVertical: 8,
    marginBottom: 12,
    fontSize: 16,
    color: '#333',
  },
  button: {
    backgroundColor: '#2196F3',
    padding: 12,
    alignItems: 'center',
    borderRadius: 2,
    marginBottom: 16,
  },
  buttonText: {
    color: '#FFF',
    fontSize: 14,
    fontWeight: 'bold',
  },
  listContainer: {
    paddingBottom: 20,
  },
  card: {
    marginBottom: 16,
    backgroundColor: '#FFF',
    borderRadius: 8,
    overflow: 'hidden',
  },
  productDetailHeader: {
    padding: 12,
    fontSize: 14,
    color: '#333',
    borderBottomWidth: 1,
    borderBottomColor: '#F0F0F0',
  },
  image: {
    height: 180,
    borderRadius: 0,
  },
  content: {
    paddingTop: 12,
  },
  title: {
    fontSize: 20,
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
    marginBottom: 2,
  },
});

export default Product_Search;