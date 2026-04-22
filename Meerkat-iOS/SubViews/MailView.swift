//
//  MailView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//

#if canImport(UIKit)

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    let appVersion: String?
    let build: String?
    let serverVersion: String?
    
    let logs: [String]
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        
        let mailComposer = MFMailComposeViewController()
        
        mailComposer.mailComposeDelegate = context.coordinator
        
        mailComposer.setToRecipients(["contact@wehrfritz.me"])
        
        var body: String = ""
        
        if let appVersion {
            body += " \n\n\(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS") Version:\t\(appVersion) (\(build ?? "Unknown"), iOS)\n"
        }
        
        if let serverVersion {
            body += " Meerkat Version:\t\(serverVersion)\n"
        }
        
        mailComposer.setMessageBody(body, isHTML: false)
        
        if !logs.isEmpty, let data = logs.joined(separator: "\n").data(using: .utf8) {
            mailComposer.addAttachmentData(data, mimeType: "text/plain", fileName: "logs.txt")
        }
        
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.dismiss()
        }
    }
}
#endif
