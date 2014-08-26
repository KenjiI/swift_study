//
//  ViewController.swift
//  swift_uitableview
//
//  Created by 石井賢二 on 2014/08/09.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MWFeedParserDelegate {
    
    @IBOutlet var tableView: UITableView!
    //var items:Array<String> = ["one", "two", "three", "four"]
    // NSXMLParserDelegate
    var parseKey : String!
    var nameArray: Array<String>!
    var items: NSMutableArray! = nil
    /*
    let entryKey = "entry"
    let titleKey = "title"
    let urlKey   = "url"
    */
    /*
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self;
        
        // optional のサンプル
        self.optionaltest()
        
        // closure のサンプル
        self.closuretest()
        
        // class のサンプル
        var hoge:Hoge = Hoge();
        println(hoge.helloWorld2())
       
        self.execRequest()
        
        nameArray = []

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        //return items.count
        return self.items.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell =  tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell!
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        let item = self.items[indexPath.row] as MWFeedItem
        //cell.textLabel.text = "\(self.items[indexPath.row])"
        //cell.textLabel.text = nameArray[indexPath.row]
        cell.textLabel.text = item.title
        //cell.detailTextLabel.text = "Subtitle index : \(indexPath.row)"
        cell.detailTextLabel.text = item.link
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let alert = UIAlertView(title: "alertTitle", message: "selected cell index is \(indexPath.row)", delegate: nil, cancelButtonTitle: "OK")
        alert.show()
        
    }
    
    func optionaltest() {
        /*
        // var prop: Optinal<String> と同義. optional でラップされる
        // ? はnilの可能性を含む.
        var prop: String?
        
        // var prop2: ImplicitlyUnwrappedOptional<String> と同義
        // ! は ? でラップされた状態をアンラップする
        var prop2: String!
        
        
        // 確認１： ?, ! を利用した場合の 初期値 nilセット
        var hoge:String? = nil // OK nil は OK
        var hoge1:String! = nil // OK これはなぜ？初期値に nil がセットできるのは問題では？
        //var hoge2:String = nil // NG nil は NG
        var hoge2:String = "hoge" // OK nil 以外なら OK
        
        // 確認２ ?, ! で宣言した変数に対するメソッド実行（と、実行時に ?,! を指定した場合）
        
        // ?の場合
        // エラー。Optinal<String>の記法の通り wrap されているので、直接 String のメソッドは利用できない。静的解析のタイミングでエラー
        var value1 = hoge.toInt()
        
        // OK。 hogeがnilかチェックをしてくれる。hogeがnilの場合は toInt は実行しないので実行時エラーにはならない。 nil 出ない場合に実行される
        var value2 = hoge?.toInt()
        
        // 実行時エラー。 ! で String としてアンラップしており、コンパイルは通るが、実際には nil なので実行時エラーになる
        var value3 = hoge!.toInt()
        
        
        // !の場合
        // 実行時エラー。 コンパイルは通るが、実際には nil なので実行時エラーになる
        var value4 = hoge1.toInt()
        
        // OK。 hogeがnilかチェックをしてくれる。hogeがnilの場合は toInt は実行しないので実行時エラーにはならない。 nil 出ない場合に実行される
        var value5 = hoge1?.toInt()
        
        // 実行時エラー。 ! で String としてアンラップしており、コンパイルは通るが、実際には nil なので実行時エラーになる
        var value6 = hoge1!.toInt()

        
        // ?も!もなし
        // OK。
        var value7 = hoge2.toInt()
        
        // エラー。 hoge1 は optionalType ではないので ? は使えない. 静的解析のタイミングでエラー
        var value8 = hoge2?.toInt()
        
        // エラー。 hoge1 は optionalType ではないので ? は使えない. 静的解析のタイミングでエラー
        var value9 = hoge2!.toInt()
        */
        
    }
    
    func closuretest(){
        // 配列の各要素にクロージャの処理を実行させる
        let test1:Array<Int> = [10, 20, 30].map({
            (number: Int) -> Int in
            let result = 2 * number
            return result
        })
        
        // 上とやっていることは同じ
        let test2:Array<Int> = [10, 20, 30].map{2 * $0};
        
        // クロージャが１文の場合は return を省略できる。また引数は $0,$1...という記法で扱うことができる
        test1.map({println($0)}) //20, 40, 60
        
        // 結果ももちろん同じ なお、関数の最後がクロージャの場合は () も省略可能みたい。なのでこれでもOK
        test2.map{println($0)} //20, 40, 60
        
    }
    
    
    // リクエスト
     func execRequest(){
        /*
        //let url  = NSURL.URLWithString("http://qiita.com/")
        let url  = NSURL.URLWithString("http://rss.dailynews.yahoo.co.jp/fc/entertainment/rss.xml")
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithURL(url, completionHandler: {
            (data, resp, err) in
            //println(NSString(data: data, encoding:NSUTF8StringEncoding))
            var parser : NSXMLParser = NSXMLParser(data: data)
            parser.delegate = self;
            parser.parse()
        })
    
        task.resume()
        */
        let feedURL = NSURL.URLWithString("http://rss.dailynews.yahoo.co.jp/fc/entertainment/rss.xml");
        let feedParser = MWFeedParser(feedURL: feedURL)
        feedParser.delegate = self
        feedParser.parse()
    }
    
    // parser 開始
    func feedParserDidStart(parser: MWFeedParser) {
//        SVProgressHUD.show()
        self.items = NSMutableArray()
    }
    
    // parser 完了時
    func feedParserDidFinish(parser: MWFeedParser) {
//        SVProgressHUD.dismiss()
        self.tableView.reloadData()
    }
    
    // Feed Info の parse 完了
    func feedParser(parser: MWFeedParser, didParseFeedInfo info: MWFeedInfo) {
        println(info)
        self.title = info.title
    }
    
    // Feed Item の parse 完了（１件）
    func feedParser(parser: MWFeedParser, didParseFeedItem item: MWFeedItem) {
        println(item)
        self.items.addObject(item)
    }

    /* 自力でparserを頑張ろうとした後・・・ 一応titleはTableViewにセットされるところまで
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!)
    {
        println("didStartElement")
        println(elementName)

        parseKey = nil
        if elementName == titleKey {
            parseKey = elementName
        } else {
        }
        
        println(parseKey)
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        parseKey = nil;
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        println("foundCharacters")
        println(parseKey)
        println(titleKey)

        if parseKey? == titleKey {
            nameArray.append(string)
        } else if parseKey? == urlKey {
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser!)
    {
        println("DidEndDocument")
        dispatch_sync(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        });
    }
*/
}

class Hoge {
    var hello: String = "Hello"
    lazy var helloWorld:() -> String = {
        self.hello + " World";
    }
    lazy var helloWorld2:() -> String = {
        [unowned self] in return self.hello + " World";
    }
}

