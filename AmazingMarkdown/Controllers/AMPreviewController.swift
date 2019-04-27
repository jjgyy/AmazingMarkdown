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
    }
    
    @objc
    func load(markdown: String?) {
        self.markdownString = markdown
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
