//
//  ViewController.swift
//  RssReader_1
//
//  Created by 石井賢二 on 2014/08/26.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, MWFeedParserDelegate {
    
    // 記事のitem配列
    var items: NSMutableArray! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 記事の取得とパース
        let feedURL = NSURL.URLWithString("http://rss.dailynews.yahoo.co.jp/fc/computer/rss.xml");
        let feedParser = MWFeedParser(feedURL: feedURL)
        feedParser.delegate = self
        feedParser.parse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/* UITableViewDataSource delegate*/
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell =  tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell!
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let item = self.items[indexPath.row] as MWFeedItem
        cell.textLabel.text = item.title
        cell.detailTextLabel.text = item.link
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        /*
        let alert = UIAlertView(title: "alertTitle", message: "selected cell index is \(indexPath.row)", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        */
        //self.performSegueWithIdentifier("showDetail", sender: self)
    }

/* StoryBoard による画面遷移時の呼ばれる コードで全部作るなら上の select をトリガに処理をする */
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if(segue.identifier == "showDetail"){
            let indexPath = self.tableView.indexPathForSelectedRow()
            let item = self.items[indexPath.row] as MWFeedItem
            let destController = segue.destinationViewController as DetailShowController
            destController.item = item
        }
    }
/* MWFeedParserDelegate delegate*/

    // parser 開始
    func feedParserDidStart(parser: MWFeedParser) {
        self.items = NSMutableArray()
    }
    
    // parser 完了時
    func feedParserDidFinish(parser: MWFeedParser) {
        self.tableView.reloadData()
    }
    
    // Feed Info の parse 完了
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        self.title = info.title
    }
    
    // Feed Item の parse 完了（１件）
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        self.items.addObject(item)
    }

}

