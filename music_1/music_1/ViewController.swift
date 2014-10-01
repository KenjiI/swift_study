//
//  ViewController.swift
//  music_1
//
//  Created by 石井賢二 on 2014/10/01.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.webview.frame = self.view.bounds;
        //self.webview.delegate = self;
        //self.view.addSubview(self.webview)
        
        var url = NSURL.URLWithString("http://www.youtube.com/embed/OW0S0zOJeR8?feature=player_detailpage&playsinline=1")
        var urlRequest: NSURLRequest = NSURLRequest(URL: url)
        self.webview.allowsInlineMediaPlayback = true;
        self.webview.loadRequest(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

