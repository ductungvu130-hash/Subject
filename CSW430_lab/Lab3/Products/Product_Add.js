import React, { useState } from 'react';
import { View, Text, TextInput, Alert, StyleSheet, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';

const Product_Add = () => {

  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [price, setPrice] = useState('');
  const [discountPercentage, setDiscountPercentage] = useState('');
  const [rating, setRating] = useState('');
  const [stock, setStock] = useState('');
  const [brand, setBrand] = useState('');
  const [category, setCategory] = useState('');
  const [images, setImages] = useState('');


  const handleSubmit = () => {
    fetch('https://dummyjson.com/products/add', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: title,
        description: description,
        price: price,
        discountPercentage: discountPercentage,
        rating: rating,
        stock: stock,
        brand: brand,
        category: category,
        images: images,
      }),
    })
      .then((res) => res.json())
      .then(console.log);
      

    Alert.alert("Add sucessfull");
  };


  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.container} showsVerticalScrollIndicator={false}>
        <Text style={styles.headerTitle}>Add a Product</Text>

        <Text style={styles.label}>Title</Text>
        <TextInput style={styles.input} placeholder="Enter title" value={title} onChangeText={setTitle} />

        <Text style={styles.label}>Description</Text>
        <TextInput style={styles.input} placeholder="Enter description" value={description} onChangeText={setDescription} />

        <Text style={styles.label}>Price</Text>
        <TextInput style={styles.input} placeholder="Enter price" keyboardType="numeric" value={price} onChangeText={setPrice} />

        <Text style={styles.label}>Discount Percentage</Text>
        <TextInput style={styles.input} placeholder="Enter discount percentage" keyboardType="numeric" value={discountPercentage} onChangeText={setDiscountPercentage} />

        <Text style={styles.label}>Rating</Text>
        <TextInput style={styles.input} placeholder="Enter rating" keyboardType="numeric" value={rating} onChangeText={setRating} />

        <Text style={styles.label}>Stock</Text>
        <TextInput style={styles.input} placeholder="Enter stock" keyboardType="numeric" value={stock} onChangeText={setStock} />

        <Text style={styles.label}>Brand</Text>
        <TextInput style={styles.input} placeholder="Enter brand" value={brand} onChangeText={setBrand} />

        <Text style={styles.label}>Category</Text>
        <TextInput style={styles.input} placeholder="Enter category" value={category} onChangeText={setCategory} />

        <Text style={styles.label}>Images</Text>
        <TextInput style={styles.input} placeholder="Enter images URL(s)" value={images} onChangeText={setImages} />

        <TouchableOpacity style={styles.button} onPress={handleSubmit}>
          <Text style={styles.buttonText}>SUBMIT</Text>
        </TouchableOpacity>
      </ScrollView>
    </SafeAreaView>
  );
};


const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#FFFFFF',
  },
  container: {
    padding: 16,
    paddingBottom: 40, 
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#00008B', 
    marginBottom: 20,
  },
  label: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 4,
  },
  input: {
    fontSize: 14,
    color: '#333',
    marginBottom: 16,
    paddingVertical: 4, 
  },
  button: {
    backgroundColor: '#2196F3',
    padding: 12,
    alignItems: 'center',
    borderRadius: 4,
    marginTop: 10,
  },
  buttonText: {
    color: '#FFF',
    fontSize: 16,
    fontWeight: 'bold',
  },
});

export default Product_Add;