//
//  MeController.swift
//  Niii
//
//  Created by LinShengyi on 4/14/15.
//  Copyright (c) 2015 LinShengyi. All rights reserved.
//

import UIKit

class MeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingList: UITableView!
    var settings = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.settingList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.settings = ["Name: Shengyi Lin", "Sex: Female", "Age: 23"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.settingList.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.settings[indexPath.row]
        
        return cell
    }
}
