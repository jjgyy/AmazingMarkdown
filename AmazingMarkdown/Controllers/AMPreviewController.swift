//
//  AMPreviewController.swift
//  AmazingMarkdown
//
//  Created by Apple on 2019/4/26.
//  Copyright © 2019 Young. All rights reserved.
//

import UIKit

class AMPreviewController: UIViewController {
    
    var markdownString: String?
    var markdownFile: AMMarkdownFile?
    var progressView: UIProgressView?
    
    @IBOutlet var markdownPreviewView: MarkdownView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 加载markdown
        self.markdownPreviewView.load(markdown: markdownString, enableImage: true)
        
        // 配置进度条, webView!依赖markdownPreviewView的load
        let progressView = DYProgressView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.view.bounds.width, height: 2.0)), observeValueForKeyPath: "estimatedProgress", of: self.markdownPreviewView.webView!)
        self.view.addSubview(progressView)
        
        // 设置背景色
        self.view.backgroundColor = DYTheme.themes[UserDefaults.standard.integer(forKey: DYThemeIndexUserDefaultsKey)].backgroundColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditFileSegue" {
            let destination = segue.destination as! AMEdittingContentController
            guard let markdownFile = self.markdownFile else { return }
            destination.load(markdownFile)
        }
    }
    
    
    @objc
    func clickSaveButtonHandler() {
        let newMarkdownFile = AMMarkdownFile.mr_createEntity()
        newMarkdownFile?.title = self.title
        newMarkdownFile?.content = self.markdownString
        newMarkdownFile?.creationDate = Date()
        newMarkdownFile?.modifiedDate = newMarkdownFile?.creationDate;
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func clickEditButtonHandler() {
        guard let markdownFile = self.markdownFile else { return }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RedirectToEdittingContentControllerNotification"), object: nil, userInfo: ["markdownFile" : markdownFile])
    }
    
    @objc
    func load(markdown: String?) {
        self.title = NSLocalizedString("preview", comment: "")
        self.markdownString = DYTheme.themes[UserDefaults.standard.integer(forKey: DYThemeIndexUserDefaultsKey)].cssStyleString + (markdown ?? "")
    }
    
    @objc
    func loadFile(markdownFile: AMMarkdownFile?) {
        self.markdownFile = markdownFile
        self.title = markdownFile?.title
        self.markdownString = DYTheme.themes[UserDefaults.standard.integer(forKey: DYThemeIndexUserDefaultsKey)].cssStyleString + "\n" + (markdownFile?.content ?? "")
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(clickEditButtonHandler))
        self.navigationItem.rightBarButtonItems = [editButton]
    }
    
    @objc
    func loadExternalFile(externalFile: AMExternalMarkdownFile?) {
        self.title = externalFile?.fileName
        guard let data = externalFile?.fileData else { return }
        self.markdownString = DYTheme.themes[UserDefaults.standard.integer(forKey: DYThemeIndexUserDefaultsKey)].cssStyleString + "\n" + (String(data: data, encoding: .utf8) ?? "")
        let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(clickSaveButtonHandler))
        self.navigationItem.rightBarButtonItems = [saveButton]
    }

}
