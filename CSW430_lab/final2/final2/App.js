import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import UsersScreen from './screens/UsersList';
import UserDetailScreen from './screens/UserDetail';

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Users">
        <Stack.Screen name="Users" component={UsersScreen} />
        <Stack.Screen name="UserDetail" component={UserDetailScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}