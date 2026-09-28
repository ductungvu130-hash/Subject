import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

const DetailListItem = ({icon, title, subtitle}) =>{
    return(
        <View style = {styles.container}>
            <Icon name = {icon} size = {24} color = "black" style = {styles.icon}/>
            <View style = {styles.content}>
                <Text style = {styles.title}>{title}</Text>
                <Text style = {styles.subtitle}>{subtitle}</Text>
            </View>
        </View>
    );
};


const styles = StyleSheet.create({
    container: {
        flexDirection:'row',
        padding :16,
        borderBottomWidth: StyleSheet.hairlineWidth,
        borderBottomColor : 'grey',
        alignItems:'center',
    },

    icon:{
        marginRight:16,
    },

    content:{
        flex:1,
    },


    title:{
        fontSize:16,
        fontWeight: 'bold',
        color: 'black',
    },

    subtitle:{
        fontSize:14,
        color: 'blue',
        marginTop :4,
    },
});

export default DetailListItem;