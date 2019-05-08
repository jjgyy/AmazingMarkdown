//
//  AMPreviewController.swift
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/26.
//  Copyright © 2019 Young. All rights reserved.
//

import UIKit
import MarkdownView

class AMPreviewController: UIViewController {
    
    var markdownString: String? {
        didSet(oldValue) {
            if (self.markdownPreviewView != nil) {
                self.markdownPreviewView.load(markdown: markdownString)
            }
        }
    }
    
    @IBOutlet var markdownPreviewView: MarkdownView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.markdownPreviewView.load(markdown: markdownString)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.6) {
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    @objc
    func clickSaveButtonHandler() {
        let newMarkdownFile = AMMarkdownFile.mr_createEntity()
        newMarkdownFile?.title = self.title
        newMarkdownFile?.content = self.markdownString
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func load(markdown: String?) {
        self.markdownString = markdown
    }
    
    @objc
    func loadInFilePreviewMode(markdownFile: AMExternalMarkdownFile?) {
        self.title = markdownFile?.fileName
        guard let data = markdownFile?.fileData else { return }
        self.markdownString = String(data: data, encoding: .utf8)
        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(clickSaveButtonHandler))
        self.navigationItem.rightBarButtonItems = [saveButton]
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
