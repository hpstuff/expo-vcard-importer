import Module from "./ExpoVcardImporterModule";

/**
 * Presents a vCard file to the user.
 * @param path The path to the vCard file.
 * @param name Optional name for the vCard. Only WEB.
 */
export function openVCard(path: string, name?: string): Promise<void> {
	return Module.presentVCardFile(path, name);
}

export function onShare() {
	return Module.addListener("onShare", () => {});
}

export default Module;
