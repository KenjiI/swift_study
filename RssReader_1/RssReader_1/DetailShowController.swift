//
//  File.swift
//  RssReader_1
//
//  Created by 石井賢二 on 2014/09/03.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

import UIKit
import Foundation

class DetailShowController: UIViewController, UIWebViewDelegate {
    var webview: UIWebView = UIWebView()
    var item:Feed!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.webview.frame = self.view.bounds
        self.webview.delegate = self;
        self.view.addSubview(self.webview)
        
        var url: NSURL = NSURL.URLWithString(self.item.link)
        var urlRequest: NSURLRequest = NSURLRequest(URL: url)
        self.webview.loadRequest(urlRequest)
    }
}