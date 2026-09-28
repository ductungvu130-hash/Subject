import React, { useState } from 'react';
import { View, Text, TouchableOpacity, SafeAreaView } from 'react-native';
import styles from './style'; // Đảm bảo file style.js vẫn nằm cùng thư mục

// --- ĐỊNH NGHĨA KIỂU DỮ LIỆU CHO TYPESCRIPT ---
interface ButtonProps {
  title: string;
  onPress: () => void;
  isOperator?: boolean;
  isEqual?: boolean;
  isZero?: boolean;
  isClear?: boolean;
}

const App = () => {
  // --- STATE VARIABLES ---
  const [displayValue, setDisplayValue] = useState<string>('0');
  const [operator, setOperator] = useState<string | null>(null);
  const [firstValue, setFirstValue] = useState<string>('');

  // --- FUNCTIONS ---
  const handleNumberInput = (num: string) => {
    if (displayValue === '0') {
      setDisplayValue(num);
    } else {
      setDisplayValue(displayValue + num);
    }
  };

  const handleOperatorInput = (op: string) => {
    setOperator(op);
    setFirstValue(displayValue);
    setDisplayValue('0');
  };

  const handleEqual = () => {
    const num1 = parseFloat(firstValue);
    const num2 = parseFloat(displayValue);

    // Bỏ qua nếu dữ liệu không phải là số
    if (isNaN(num1) || isNaN(num2)) return;

    let result = 0;
    if (operator === '+') {
      result = num1 + num2;
    } else if (operator === '-') {
      result = num1 - num2;
    } else if (operator === '*') {
      result = num1 * num2;
    } else if (operator === '/') {
      result = num1 / num2;
    }

    setDisplayValue(result.toString());
    setOperator(null);
    setFirstValue('');
  };

  const handleClear = () => {
    setDisplayValue('0');
    setOperator(null);
    setFirstValue('');
  };

  // --- COMPONENT NÚT BẤM (Đã fix lỗi TypeScript) ---
  const CalculatorButton = ({ title, onPress, isOperator, isEqual, isZero, isClear }: ButtonProps) => {
    return (
      <TouchableOpacity
        style={[
          styles.button,
          isZero && styles.buttonZero,
          isClear && styles.buttonClear,
          isEqual && styles.buttonEqual,
        ]}
        onPress={onPress}
      >
        <Text style={[
          styles.text,
          isOperator && styles.operatorText,
          isEqual && styles.equalText
        ]}>
          {title}
        </Text>
      </TouchableOpacity>
    );
  };

  // --- GIAO DIỆN (UI) ---
  return (
    <SafeAreaView style={styles.container}>
      {/* Khu vực hiển thị số */}
      <View style={styles.displayContainer}>
        <Text style={styles.displayText} numberOfLines={1} adjustsFontSizeToFit>
          {displayValue}
        </Text>
      </View>

      {/* Bàn phím máy tính */}
      <View style={styles.keypad}>
        <View style={styles.row}>
          <CalculatorButton title="7" onPress={() => handleNumberInput('7')} />
          <CalculatorButton title="8" onPress={() => handleNumberInput('8')} />
          <CalculatorButton title="9" onPress={() => handleNumberInput('9')} />
          <CalculatorButton title="÷" isOperator onPress={() => handleOperatorInput('/')} />
        </View>

        <View style={styles.row}>
          <CalculatorButton title="4" onPress={() => handleNumberInput('4')} />
          <CalculatorButton title="5" onPress={() => handleNumberInput('5')} />
          <CalculatorButton title="6" onPress={() => handleNumberInput('6')} />
          <CalculatorButton title="×" isOperator onPress={() => handleOperatorInput('*')} />
        </View>

        <View style={styles.row}>
          <CalculatorButton title="1" onPress={() => handleNumberInput('1')} />
          <CalculatorButton title="2" onPress={() => handleNumberInput('2')} />
          <CalculatorButton title="3" onPress={() => handleNumberInput('3')} />
          <CalculatorButton title="-" isOperator onPress={() => handleOperatorInput('-')} />
        </View>

        <View style={styles.row}>
          <CalculatorButton title="0" isZero onPress={() => handleNumberInput('0')} />
          <CalculatorButton title="+" isOperator onPress={() => handleOperatorInput('+')} />
          <CalculatorButton title="=" isEqual onPress={handleEqual} />
        </View>

        <View style={styles.row}>
          <CalculatorButton title="C" isClear onPress={handleClear} />
        </View>
      </View>
    </SafeAreaView>
  );
};

export default App;