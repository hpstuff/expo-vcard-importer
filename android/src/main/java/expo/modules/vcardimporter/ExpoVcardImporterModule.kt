package expo.modules.vcardimporter

import android.content.Intent
import android.net.Uri
import android.webkit.MimeTypeMap
import androidx.core.content.FileProvider
import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import java.io.File

class ExpoVcardImporterModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("ExpoVcardImporter")

    AsyncFunction("presentVCardFile") { filePath: String, name: String? ->
      val activity = appContext.currentActivity ?: return@AsyncFunction

      val cleanPath = if (filePath.startsWith("file://")) {
        filePath.substring(7)
      } else {
        filePath
      }

      // Create a File object from the path
      val file = File(cleanPath)

      // Verify the file exists and is readable
      if (!file.exists() || !file.canRead()) {
        throw Exception("File not found: $filePath")
      }

      val uri: Uri = FileProvider.getUriForFile(
        activity,
        activity.packageName + ".provider",
        file
      )

      val intent = Intent(Intent.ACTION_VIEW).apply {
        setDataAndType(uri, "text/x-vcard")
        flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
      }

      activity.startActivity(intent)
    }
  }
}
