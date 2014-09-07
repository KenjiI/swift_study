//
//  ViewController.swift
//  RssReader_1
//
//  Created by 石井賢二 on 2014/08/26.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController, MWFeedParserDelegate {
    
    // 記事のitem配列
    var itemInfo: MWFeedInfo! = nil
    var items: NSMutableArray! = nil
    var getFeedLastDate: NSDate?
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext
        
        self.items = NSMutableArray()
        
        // 格納したデータのフェッチ
        var request = NSFetchRequest()
        var entity = NSEntityDescription.entityForName("Feed", inManagedObjectContext: self.managedObjectContext)
        request.entity = entity
        request.returnsObjectsAsFaults = false;
        let sortDescriptor = NSSortDescriptor(key: "receiveDate", ascending: false)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = [sortDescriptor]
        var error: NSError? = nil
        var mutableFetchResults = managedObjectContext?.executeFetchRequest(request, error: &error)
        if (mutableFetchResults == nil) {
            println("faile why?")
            // エラーを処理する。
        }
        //self.items.addObjectsFromArray(mutableFetchResults!)
        self.items.addObjectsFromArray(mutableFetchResults!)
        
        if self.getFeedLastDate == nil {
            self.getFeedLastDate = (self.items[0] as Feed).receiveDate
        }
        for var i=0; i<self.items.count; i++ {
            var _item = self.items[i] as Feed
            switch(self.getFeedLastDate!.compare(_item.receiveDate)) {
            case NSComparisonResult.OrderedAscending : // date1が小さいとき
                // 最新の日付に更新
                self.getFeedLastDate = _item.receiveDate
                break
            default :
                break
            }
        }
        
        // タイトルの設定
        self.title = "RSS Reader v0.1"
        
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
        //let item = self.items[indexPath.row] as MWFeedItem
        let item = self.items[indexPath.row] as Feed
        cell.textLabel.text = item.title
        cell.detailTextLabel.text = item.receiveDate.description
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
            let item = self.items[indexPath.row] as Feed
            let destController = segue.destinationViewController as DetailShowController
            destController.item = item
        }
    }
/* MWFeedParserDelegate delegate*/

    // parser 開始
    func feedParserDidStart(parser: MWFeedParser) {
        self.itemInfo = nil
        //self.items = NSMutableArray()
    }
    
    // parser 完了時
    func feedParserDidFinish(parser: MWFeedParser) {
        self.tableView.reloadData()
    }
    
    // Feed Info の parse 完了
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        self.itemInfo = info
    }
    
    // Feed Item の parse 完了（１件）
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        var result = self.getFeedLastDate!.compare(item.date)
        switch(result) {
        // 今ある記事の最新より古い時間だった場合はむしする。本当は最後の取得日付をDBに覚えておくべき（記事の発行元別に）。
        case NSComparisonResult.OrderedDescending :
            println("descending")
            break
        case NSComparisonResult.OrderedAscending :
            println("ascending")
            var feed = saveFeedItem(item)
            self.items.insertObject(feed, atIndex: 0)
            break
        case NSComparisonResult.OrderedSame :
            println("same")
            break
        default :
            break
        }
    }

/* 独自 CoreData */
    func saveFeedItem(item: MWFeedItem) -> Feed{
        var feed: Feed = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: self.managedObjectContext) as Feed
        feed.title = item.title
        feed.link = item.link
        feed.receiveDate = item.date
        
        var error: NSError? = nil
        if(managedObjectContext?.save(&error) == nil){
            // エラーを処理する
            println("save error")
        }
        println("save success !!")
        return feed
    }
}

