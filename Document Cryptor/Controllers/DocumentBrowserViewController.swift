/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A document browser view controller subclass that implements methods for creating, opening, and importing documents.
*/

import UIKit
import os.log

/// - Tag: DocumentBrowserViewController

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    var loginPassword = "pw345"
    var cryptorLogic = CryptorLogic()

    
    /// - Tag: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        cryptorLogic.setPassword(loginPassword)

        
        let encryptAction = UIDocumentBrowserAction(identifier: "com.sugirdha.DocumentCryptor.encryptFile",
                                                    localizedTitle: "Encrypt",
                                                    availability: [.menu, .navigationBar]) { (url) in
            print("file path: \(url[0])")
            self.cryptorLogic.encrypt(fileToEncrypt: url[0])
        }
        let decryptAction = UIDocumentBrowserAction(identifier: "com.sugirdha.DocumentCryptor.decryptFile", localizedTitle: "Decrypt", availability: [.menu, .navigationBar]) { (url) in
            self.cryptorLogic.decrypt(fileToDecrypt: url[0])
        }
        
        encryptAction.supportedContentTypes = ["public.plain-text"]
        decryptAction.supportedContentTypes = ["public.plain-text"]
        
        customActions = [encryptAction, decryptAction]
        
    }
    
    
    // MARK: - UIDocumentBrowserViewControllerDelegate
    
    // Create a new document.
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
                         didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        
        os_log("==> Creating A New Document.", log: .default, type: .debug)
        
        let doc = TextDocument()
        let url = doc.fileURL
        
        // Create a new document in a temporary location.
        doc.save(to: url, for: .forCreating) { (saveSuccess) in
            
            // Make sure the document saved successfully.
            guard saveSuccess else {
                os_log("*** Unable to create a new document. ***", log: .default, type: .error)
                
                // Cancel document creation.
                importHandler(nil, .none)
                return
            }
            
            // Close the document.
            doc.close(completionHandler: { (closeSuccess) in
                
                // Make sure the document closed successfully.
                guard closeSuccess else {
                    os_log("*** Unable to create a new document. ***", log: .default, type: .error)
                    
                    // Cancel document creation.
                    importHandler(nil, .none)
                    return
                }
                
                // Pass the document's temporary URL to the import handler.
                importHandler(url, .move)
            })
        }
    }
    
    // Import a document.
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        os_log("==> Imported A Document from %@ to %@.",
               log: .default,
               type: .debug,
               sourceURL.path,
               destinationURL.path)
        
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        let prefixDescription = NSLocalizedString("ErrorImportDescription", comment: "")
        var description = ""
        if error?.localizedDescription != nil {
            description = error!.localizedDescription
        } else {
            description = NSLocalizedString("ErrorImportNoDescription", comment: "")
        }
        let message = String(format: "%@ %@", prefixDescription, description)
        
        let alert = UIAlertController(
            title: NSLocalizedString("ErrorImportTitle", comment: ""),
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: NSLocalizedString("OKTitle", comment: ""),
            style: .cancel,
            handler: nil)
        alert.addAction(action)
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    // UIDocumentBrowserViewController is telling us to open a selected a document.
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        if let url = documentURLs.first {
            presentDocument(at: url)
        }
    }
    
    // MARK: - Document Presentation

    var transitionController: UIDocumentBrowserTransitionController?
    
    func presentDocument(at documentURL: URL) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        // Load the document's view controller from the storyboard.
        let instantiatedNavController = storyBoard.instantiateViewController(withIdentifier: "DocNavController")
        guard let docNavController = instantiatedNavController as? UINavigationController else { fatalError() }
        guard let documentViewController = docNavController.topViewController as? TextDocumentViewController else { fatalError() }
        
        // Load the document view.
        documentViewController.loadViewIfNeeded()
        
        // In order to get a proper animation when opening and closing documents, the DocumentViewController needs a custom view controller
        // transition. The `UIDocumentBrowserViewController` provides a `transitionController`, which takes care of the zoom animation. Therefore, the
        // `UIDocumentBrowserViewController` is registered as the `transitioningDelegate` of the `DocumentViewController`. Next, obtain the
        // transitionController, and store it for later (see `animationController(forPresented:presenting:source:)` and
        // `animationController(forDismissed:)`).
        docNavController.transitioningDelegate = self
        
        // Get the transition controller.
        transitionController = transitionController(forDocumentAt: documentURL)
        
        let doc = TextDocument(fileURL: documentURL)

        transitionController!.targetView = documentViewController.textView
  
        // Set up the loading animation.
        transitionController!.loadingProgress = doc.loadProgress
        
        // Present this document (and it's navigation controller) as full screen.
        docNavController.modalPresentationStyle = .fullScreen

        // Set and open the document.
        documentViewController.document = doc
        documentViewController.document.open(completionHandler: { (success) in
            // Make sure to implement handleError(_:userInteractionPermitted:) in your UIDocument subclass to handle errors appropriately.
            if success {
                // Remove the loading animation.
                self.transitionController!.loadingProgress = nil
                
                os_log("==> Document Opened", log: .default, type: .debug)
                self.present(docNavController, animated: true, completion: nil)
            }
        })
    }
    
}

extension DocumentBrowserViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // Since the `UIDocumentBrowserViewController` has been set up to be the transitioning delegate of `DocumentViewController` instances (see
        // implementation of `presentDocument(at:)`), it is being asked for a transition controller.
        // Therefore, return the transition controller, that previously was obtained from the `UIDocumentBrowserViewController` when a
        // `DocumentViewController` instance was presented.
        return transitionController
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // The same zoom transition is needed when closing documents and returning to the `UIDocumentBrowserViewController`, which is why the the
        // existing transition controller is returned here as well.
        return transitionController
    }
    
}

