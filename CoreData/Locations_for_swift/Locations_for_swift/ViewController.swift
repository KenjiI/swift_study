//
//  ViewController.swift
//  Locations_for_swift
//
//  Created by 石井賢二 on 2014/08/27.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UITableViewController, CLLocationManagerDelegate{
    
    var eventsArray: NSMutableArray?
    var managedObjectContext: NSManagedObjectContext?
    var addButton: UIBarButtonItem?
    var locationManager: CLLocationManager!
    /*
        {
        get{
            if (self.locationManager != nil) {
                return self.locationManager!;
            }
            self.locationManager = CLLocationManager();
            self.locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            self.locationManager!.delegate = self;
            return self.locationManager!;
        }
        
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        self.managedObjectContext = appDel.managedObjectContext
        
        //タイトルを設定する。
        self.title = "Locations";

        // ボタンをセットアップする。
        self.navigationItem.leftBarButtonItem = self.editButtonItem();
        //addButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.Add, target:self, action:{addEvent()})
        addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addEvent")
        // 初期状態ではfalse
        addButton?.enabled = true;

        // ナビゲータの右に配置
        self.navigationItem.rightBarButtonItem = addButton;
        
        // ロケーションマネージャを起動する。
        self.locationManager = CLLocationManager();
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.distanceFilter = 300
        self.locationManager.startUpdatingLocation()
        
        // テーブルに表示する用の配列の初期化
        eventsArray = NSMutableArray()
        
        // 格納したデータのフェッチ
        var request = NSFetchRequest()
        
        var entity = NSEntityDescription.entityForName("Event", inManagedObjectContext: self.managedObjectContext)
        
        //var entity = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: self.managedObjectContext) as NSEntityDescription
        request.entity = entity
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = [sortDescriptor]
        
        var error: NSError? = nil
        var mutableFetchResults = managedObjectContext?.executeFetchRequest(request, error: &error)
        if (mutableFetchResults == nil) {
            println("faile why?")
            // エラーを処理する。
        }
        self.eventsArray?.addObjectsFromArray(mutableFetchResults!)
    
    }

    // ViewのUnload処理
    /*
    override func viewDidUnload() {
        self.eventsArray = nil;
        self.locationManager = nil;
        self.addButton = nil;
    }
    */
    // Core Location 生成 (locationManagerのgetter)
    /*
    func locationManager() -> CLLocationManager {
        if (locationManager != nil) {
            return locationManager!;
        }
        locationManager = CLLocationManager();
        locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        locationManager!.delegate = self;
        return locationManager!;
    }
*/
    
    // Addボタン押下時の処理
    func addEvent() {
        var location = self.locationManager.location;
        if (location == nil) {
            println("location is nil")
            return;
        }
    
        // Eventエンティティの新規インスタンスを作成して設定する
        var event: Event = NSEntityDescription.insertNewObjectForEntityForName("Event", inManagedObjectContext: self.managedObjectContext) as Event
        var coordinate = location?.coordinate
        event.latitude = 1234 //coordinate!.latitude
        event.longitude = 5678 //coordinate!.longitude
        event.creationDate = NSDate()
        
        var error: NSError? = nil
        if(managedObjectContext?.save(&error) == nil){
            // エラーを処理する
            println("save error")
        }
        println("event : \(event)")
    
        eventsArray?.insertObject(event, atIndex: 0)

        let indexPath = NSIndexPath(forRow:0, inSection:0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


//    #pragma CoreLocation - delegate Method
    
    // ロケーションの更新時に呼ばれる
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        println("update")
        addButton?.enabled = true
    }
    
    // ロケーション取得失敗時に呼ばれる
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("fail")
    }
    
/* UITableViewDataSource delegate*/
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return eventsArray!.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        //let cell: UITableViewCell =  tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell!
            cell.textLabel.text = "hoge \(NSDate())";
        return cell;
    }
}

