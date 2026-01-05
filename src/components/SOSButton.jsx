import { Pressable, Text } from "react-native";
import { Colors } from "../constants/colors";

export default function SOSButton({ onPress }) {
  return (
    <Pressable
      onPress={onPress}
      style={{
        backgroundColor: Colors.danger,
        height: 100,
        width: 100,
        borderRadius: 50,
        alignItems: "center",
        justifyContent: "center",
      }}
    >
      <Text style={{ color: "#fff", fontSize: 20, fontWeight: "700" }}>
        SOS
      </Text>
    </Pressable>
  );
}