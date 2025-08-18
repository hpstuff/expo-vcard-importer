import ExpoModulesCore
import Contacts
import ContactsUI

public class ExpoVcardImporterModule: Module {
  
  public func definition() -> ModuleDefinition {
    Name("ExpoVcardImporter")

    Events("onShare")
    
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
          
          let _nav = UINavigationController(rootViewController: vc)
          _nav.modalPresentationStyle = .formSheet
          
          vc.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(self.closeContactVC(_:))
          )
          let shareButton = UIButton(type: .system)
          shareButton.setTitle("Share", for: .normal)
          shareButton.layer.cornerRadius = 16
          shareButton.clipsToBounds = true
          shareButton.backgroundColor = UIColor.systemGray5
          shareButton.addTarget(self, action: #selector(self.shareContacts(_:)), for: .touchUpInside)
          shareButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 16)

          vc.navigationItem.titleView = shareButton
        
          if let currentVC = self.appContext?.utilities?.currentViewController() {
            currentVC.present(_nav, animated: true)
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
  
  // MARK: - Close button selector
  @objc func closeContactVC(_ sender: UIBarButtonItem) {
    if let root = UIApplication.shared.connectedScenes
      .compactMap({ $0 as? UIWindowScene })
      .flatMap({ $0.windows })
      .first(where: { $0.isKeyWindow })?.rootViewController?.presentedViewController {
      
      root.dismiss(animated: true)
    }
  }
  
  // MARK: - Close button selector
  @objc func shareContacts(_ sender: UIButton) {
    self.sendEvent("onShare", [:])
  }
}
