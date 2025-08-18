import { NativeModule, requireNativeModule } from "expo";

declare class ExpoVcardImporterModule extends NativeModule {
	presentVCardFile(path: string, name?: string): Promise<void>;
}

export default requireNativeModule<ExpoVcardImporterModule>(
	"ExpoVcardImporter",
);
