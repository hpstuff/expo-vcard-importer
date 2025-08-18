import { NativeModule, registerWebModule } from "expo";

class ExpoVcardImporterModule extends NativeModule {
	async presentVCardFile(path: string, name?: string): Promise<void> {
		const a = document.createElement("a");
		a.href = path;
		a.download = name || "vcard.vcf";
		a.style.display = "none";
		document.body.appendChild(a);
		a.click();
		document.body.removeChild(a);
	}
}

export default registerWebModule(
	ExpoVcardImporterModule,
	"ExpoVcardImporterModule",
);
