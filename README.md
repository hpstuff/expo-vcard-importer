# Expo VCard Importer

An [Expo](https://docs.expo.dev/) module for **opening vCard (`.vcf`) files** in your React Native app across **iOS, Android, and Web**.  

- 📱 On **iOS**, it uses `CNContactViewController` to present a native contact sheet with built-in **Cancel** and **Share** buttons.  
- 🤖 On **Android**, it opens the vCard file using an `Intent` (handled by the system’s Contacts app).  
- 🌐 On **Web**, it triggers a `.vcf` file download.  

---

## ✨ Features

- 📂 Open and display `.vcf` files cross-platform.  
- 👤 Native **iOS contact view** with Cancel and Share actions.  
- 📲 Android integration via system `Intent`.  
- 🌍 Web support via file download.  
- 🔔 `"onShare"` event emitter (iOS only).  

---

## 📦 Installation

```bash
npx expo install expo-vcard-importer
```

Since this package includes native code, make sure to run prebuild:

```bash
npx expo prebuild
```

## 🚀 Usage

```ts
import { useEvent } from "expo";
import VCardImporter, { openVCard } from "expo-vcard-importer";
import { Button } from "react-native";

export default function App() {
  // iOS only: listen for "Share" button event
  useEffect(() => {
    VCardImporter.addListener("onShare", () => {
      console.log("onShare event triggered");
    });
  }, []);

  const handleOpen = async () => {
    try {
      await openVCard(
        "file://path/to/Rumen_Rusanov.vcf", // absolute file path or file:// URI
        "Rumen Rusanov" // optional name (only used on Web)
      );
    } catch (e) {
      console.error("Failed to open vCard", e);
    }
  };

  return <Button title="Open vCard" onPress={handleOpen} />;
}
```

## 📚 API
`openVCard(path: string, name?: string): Promise<void>`
Opens a `.vcf` file:
- iOS → Presents a native contact view (`CNContactViewController`).
- Android → Launches an Intent to view the vCard (handled by Contacts).
- Web → Triggers a `.vcf` file download.
  
Parameters:
- `path` → The absolute file path (or `file://` URI).
- `name?` → Optional filename for Web downloads.

### Listening to `"onShare"` (iOS only)
Using `addListener`:
```ts
import VCardImporter from "expo-vcard-importer";

const subscription = VCardImporter.addListener("onShare", () => {
  console.log("onShare event triggered");
});

// later
subscription.remove();
```

Using `useEvent` from Expo (recommended):
```ts
import { useEvent } from "expo";
import VCardImporter from "expo-vcard-importer";

function ContactScreen() {
  useEvent(VCardImporter, "onShare");

  return null;
}
```

## ⚠️ Platform Notes
- **iOS**: Requires user permission to access Contacts if saving the contact.
- **Android**: Relies on the system’s default contact handler. Ensure .vcf is readable and your FileProvider is configured.
- **Web**: Only supports downloading the .vcf file, not previewing.

## 📄 License
MIT
