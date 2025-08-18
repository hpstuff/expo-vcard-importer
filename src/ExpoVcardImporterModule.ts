import { NativeModule, requireNativeModule } from "expo";
import type { ExpoVcardImporterEvents } from "./ExpoVcardImporter.types";

declare class ExpoVcardImporterModule extends NativeModule<ExpoVcardImporterEvents> {
	presentVCardFile(path: string, name?: string): Promise<void>;
}

export default requireNativeModule<ExpoVcardImporterModule>(
	"ExpoVcardImporter",
);
