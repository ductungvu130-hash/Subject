import { StyleSheet, Dimensions } from 'react-native';

const buttonSize = (Dimensions.get('window').width / 4) - 16; 

export default StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
    justifyContent: 'flex-end',
  },
  displayContainer: {
    padding: 20,
    alignItems: 'flex-end',
    justifyContent: 'flex-end',
    flex: 1,
  },
  displayText: {
    fontSize: 60,
    color: '#333',
    fontWeight: '300',
  },
  keypad: {
    padding: 8,
    backgroundColor: '#F5F5F5',
  },
  row: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 8,
  },
  button: {
    width: buttonSize,
    height: buttonSize,
    borderRadius: buttonSize / 2,
    backgroundColor: '#FFFFFF',
    justifyContent: 'center',
    alignItems: 'center',
    elevation: 2, 
  },
  buttonZero: {
    width: (buttonSize * 2) + 8,
    alignItems: 'center',
  },
  buttonClear: {
    width: '100%',
    height: 60,
    borderRadius: 30,
    marginTop: 8,
  },
  buttonEqual: {
    backgroundColor: '#FF8C00',
  },
  text: {
    fontSize: 28,
    color: '#333',
  },
  operatorText: {
    color: '#FF8C00',
    fontSize: 28,
  },
  equalText: {
    color: '#FFF',
  }
});