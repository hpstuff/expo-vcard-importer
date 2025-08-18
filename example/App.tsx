import * as FileSystem from "expo-file-system";
import { openVCard } from "expo-vcard-importer";
import { Button, SafeAreaView, ScrollView, Text, View } from "react-native";

export default function App() {
	const handleVCardOpen = async () => {
		const path = FileSystem.cacheDirectory + "john-doe.vcf";
		try {
			await FileSystem.downloadAsync(
				"https://www.w3.org/2002/12/cal/vcard-examples/john-doe.vcf",
				path,
			);
		} catch (error) {
			console.error("Failed to download vCard:", error);
		}

		try {
			console.log("Opening vCard at path:", path);
			await openVCard(path, "John Doe");
		} catch (error) {
			console.error("Failed to open vCard:", error);
		}
	};

	return (
		<SafeAreaView style={styles.container}>
			<ScrollView style={styles.container}>
				<Text style={styles.header}>Module API Example</Text>
				<Group name="Functions">
					<Button title="Open vCard" onPress={handleVCardOpen} />
				</Group>
			</ScrollView>
		</SafeAreaView>
	);
}

function Group(props: { name: string; children: React.ReactNode }) {
	return (
		<View style={styles.group}>
			<Text style={styles.groupHeader}>{props.name}</Text>
			{props.children}
		</View>
	);
}

const styles = {
	header: {
		fontSize: 30,
		margin: 20,
	},
	groupHeader: {
		fontSize: 20,
		marginBottom: 20,
	},
	group: {
		margin: 20,
		backgroundColor: "#fff",
		borderRadius: 10,
		padding: 20,
	},
	container: {
		flex: 1,
		backgroundColor: "#eee",
	},
	view: {
		flex: 1,
		height: 200,
	},
};
