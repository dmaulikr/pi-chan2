//
//  PreviewViewController.swift
//  pi-chan
//
//  Created by Kensuke Hoshikawa on 2016/04/12.
//  Copyright © 2016年 star__hoshi. All rights reserved.
//

import UIKit
import SVProgressHUD
import FontAwesome_swift
import SafariServices

class PreviewViewController: UIViewController, UIWebViewDelegate {
    var postNumber: Int!
    let localHtml = R.file.mdHtml()!.path
    var post: Post?

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
        rightBarButton.setTitleTextAttributes(attributes, for: .normal)
        rightBarButton.title = String.fontAwesomeIcon(name: .edit)

        let req = URLRequest(url: URL(string: localHtml)!)
        webView.delegate = self;
        webView.loadRequest(req)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadByNotification), name: ESAObserver.edit, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadByNotification), name: ESAObserver.login, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: ESAObserver.edit, object: nil)
        NotificationCenter.default.removeObserver(self, name: ESAObserver.login, object: nil)
    }

    func reloadByNotification(notification: Notification) {
        loadGetPostApi()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadGetPostApi()
    }

    func loadGetPostApi() {
        SVProgressHUD.showLoading()
        let request = ESAApiClient.GetPostRequest(number: postNumber!)
        ESASession.send(request) { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(let response):
                self.post = response
                self.setMarkdown()
                self.navigationItem.title = response.wip ? "[WIP]\(response.name)" : response.name
            case .failure(let error):
                ESAApiClient.errorHandler(error)
            }
        }
    }

    func setMarkdown() {
        let category = post?.category != nil ? "###### \(post!.category!) \\n" : ""
        let mdPrefixTitle = category + "# \(post!.name)\\n\\n"
        let md = mdPrefixTitle + post!.getBodyMdReplacedNewLine()
        let js = "insert('\(md.replacingOccurrences(of: "'", with: "\\'"))');"
        log?.debug("\(js)")
        self.webView.stringByEvaluatingJavaScript(from: js)
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        log?.info("\(request.url)")

        guard let url = request.url else {
            return false
        }
        if url.absoluteString.hasPrefix("file:///posts") {
            goPreviewToPreview(url: request.url!)
            return false
        }
        if navigationType == .other {
            return true
        } else {
            let safari = SFSafariViewController(url: request.url!, entersReaderIfAvailable: true)
            present(safari, animated: true, completion: nil)
            return false
        }
    }

    func goPreviewToPreview(url: URL) {
        let nextPostNumber = Int(url.absoluteString.replacingOccurrences(of: "file:///posts/", with: ""))!
        performSegue(withIdentifier: R.segue.previewViewController.previewToPreview.identifier, sender: nextPostNumber)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.previewViewController.previewToPreview.identifier {
            let previewViewController = segue.destination as! PreviewViewController
            previewViewController.postNumber = sender as! Int
        }
        if segue.identifier == R.segue.previewViewController.toEditor.identifier {
            let destinationNavigationController = segue.destination as! UINavigationController
            let editor = destinationNavigationController.topViewController as! EditorViewController
            editor.post = post
        }
    }

    @IBAction func openEditor(sender: AnyObject) {
        performSegue(withIdentifier: R.segue.previewViewController.toEditor.identifier, sender: nil)
    }
}