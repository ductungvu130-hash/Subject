import React, { useState, useEffect } from 'react';
import { View, Text, StyleSheet, SafeAreaView, ScrollView } from 'react-native';
import { Card, Button } from 'react-native-paper';

const Product_Detail = () => {
  const [data, setData] = useState(null);
  const filePath = 'https://dummyjson.com/products/2';

  useEffect(() => {
    fetch(filePath)
      .then((response) => {
        if (!response.ok) {
          throw new Error('Network response was not ok');
        }
        return response.json();
      })
      .then((d) => {
        setData(d);
      })
      .catch((error) => {
        console.error('Error fetching data:', error);
      });
  }, []);

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.header}>Product Detail</Text>
        
        {data && (
          <Card style={styles.card}>
            <Card.Cover source={{ uri: data.thumbnail }} style={styles.image} />
            
            <Card.Content style={styles.content}>
              <Text style={styles.title}>Title: {data.title}</Text>
              <Text style={styles.description}>Description: {data.description}</Text>
              <Text style={styles.text}>Price: ${data.price}</Text>
              <Text style={styles.text}>Discount: {data.discountPercentage}%</Text>
              <Text style={styles.text}>Rating: {data.rating} stars</Text>
              <Text style={styles.text}>Stock: {data.stock} units</Text>
              <Text style={styles.text}>Brand: {data.brand}</Text>
              <Text style={styles.text}>Category: {data.category}</Text>
            </Card.Content>
            
            <Card.Actions style={styles.actions}>
              <Button mode="contained" onPress={() => {}} style={styles.button}>
                Delete
              </Button>
              <Button mode="contained" onPress={() => {}} style={styles.button}>
                Cancel
              </Button>
            </Card.Actions>
          </Card>
        )}
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
    padding: 16,
  },
  header: {
    fontSize: 16,
    color: '#333',
    marginBottom: 12,
  },
  card: {
    backgroundColor: '#FFF',
    borderRadius: 8,
    overflow: 'hidden',
  },
  image: {
    height: 250,
    borderRadius: 0,
    backgroundColor: '#000', 
  },
  content: {
    paddingTop: 16,
    paddingBottom: 8,
  },
  title: {
    fontSize: 26,
    color: '#333',
    marginBottom: 8,
  },
  description: {
    fontSize: 14,
    color: '#666',
    marginBottom: 4,
  },
  text: {
    fontSize: 14,
    color: '#333',
    marginBottom: 2,
  },
  actions: {
    justifyContent: 'flex-end',
    paddingRight: 16,
    paddingBottom: 16,
  },
  button: {
    backgroundColor: '#673AB7', 
    marginLeft: 8,
    borderRadius: 20,
  },
});

export default Product_Detail;