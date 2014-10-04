//
//  ViewController.swift
//  music_1
//
//  Created by 石井賢二 on 2014/10/01.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {
    
    var moviePlayer:MPMoviePlayerController!
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        var url = NSURL.URLWithString("https://www.youtube.com/embed/We3uAyJJ9Fo?feature=player_detailpage&playsinline=1")
        var urlRequest: NSURLRequest = NSURLRequest(URL: url)
        self.webview.allowsInlineMediaPlayback = true;
        self.webview.loadRequest(urlRequest)
        */
        
        var srcUrl = NSURL.URLWithString("https://www.youtube.com/embed/We3uAyJJ9Fo?feature=player_detailpage&playsinline=1")
        
        var dict = HCYoutubeParser.h264videosWithYoutubeURL(srcUrl)
        var url = NSURL.URLWithString(dict["medium"] as NSString)
        moviePlayer = MPMoviePlayerController(contentURL: url)
        moviePlayer.view.frame = CGRect(x: 20, y: 100, width: 200, height: 150)
        self.view.addSubview(moviePlayer.view)
        moviePlayer.fullscreen = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

