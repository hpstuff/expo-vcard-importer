import ExpoModulesCore
import Contacts
import ContactsUI

public class ExpoVcardImporterModule: Module {
  
    public func definition() -> ModuleDefinition {
    Name("ExpoVcardImporter")

    AsyncFunction("presentVCardFile") { (filePath: String, name: String?, promise: Promise) in
        do {
            let fileUrl: URL
            if filePath.hasPrefix("file://") {
                guard let url = URL(string: filePath) else {
                    promise.reject("E_INVALID", "Invalid file URL")
                    return
                }
                fileUrl = url
            } else {
              if #available(iOS 16.0, *) {
                fileUrl = URL(filePath: filePath)
              } else {
                fileUrl = URL(fileURLWithPath: filePath)
              }
            }

            let fm = FileManager.default
            guard fm.fileExists(atPath: fileUrl.path) else {
                promise.reject("E_NOT_FOUND", "File does not exist at \(fileUrl.path)")
                return
            }
            let data = try Data(contentsOf: fileUrl)
            let contacts = try CNContactVCardSerialization.contacts(with: data)

            guard let contact = contacts.first else {
                promise.reject("E_EMPTY", "No contact found in vCard file")
                return
            }

            DispatchQueue.main.async {
                let vc = CNContactViewController(forUnknownContact: contact)
                vc.allowsActions = true
                vc.contactStore = CNContactStore()
              
                if let root = UIApplication.shared.connectedScenes
                    .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                    .first?.rootViewController {
                
                let nav = UINavigationController(rootViewController: vc)
                    root.present(nav, animated: true)
                    promise.resolve(nil)
                } else {
                    promise.reject("E_UI", "No root view controller")
                }
            }
        } catch {
            promise.reject("E_FAIL", "Failed to load vCard: \(error.localizedDescription)")
        }
    }
}
}
