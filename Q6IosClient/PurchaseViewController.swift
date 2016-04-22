//
//  PurchaseViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 5/04/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController, Q6WebApiProtocol,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var purchaseTableView: PurchaseTableView!
    var attachedURL: String = "&Type=AllPurchases&SearchText=&StartDate=2016-03-15&EndDate=2016-04-14&PageSize=20&PageIndex=1"
    @IBOutlet weak var PurchaseSearchBox: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        setControlAppear()
  let q6CommonLib = Q6CommonLib(myObject: self)
      
        q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetPurchasesTransactionsList", attachedURL: attachedURL)
        
   var now = NSDate()
     var ddd = now.formatted
        print(ddd)
     
        // Do any additional setup after loading the view.
        
        purchaseTableView.delegate = self
        purchaseTableView.dataSource = self
     
//        purchaseTableView.registerClass(cellClass:PurchaseTableViewCell.self, forCellWithReuseIdentifier: "PurchasePototypeCELL")
    }
    func setControlAppear()
    {
        
        PurchaseSearchBox.layer.cornerRadius = 2;
        PurchaseSearchBox.layer.borderWidth = 0.1;
        PurchaseSearchBox.layer.borderColor = UIColor.blackColor().CGColor
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        var postDicData :[String:AnyObject]
    
        do {
            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
            
            var dddd = postDicData["PurchasesTransactionsHeaderList"] as! [[String : AnyObject]]
            
            var sss = dddd[1] as [String: AnyObject]
            
           print(sss["Memo"]!)
//        var dd = try  NSJSONSerialization.JSONObjectWithData(postDicData["PurchasesTransactionsHeaderList"]! as! NSData, options: []) as! [AnyObject]
            //let dataDict = try  NSJSONSerialization.JSONObjectWithData(postDicData["PurchasesTransactionsHeaderList"]! as! NSData, options: NSJSONReadingOptions.MutableContainers) as! [[String:String]]

            
        } catch  {
            print("error parsing response from POST on /posts")
            
            return ""
        }

        return ""
    }
    
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
    
         func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
    
         func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var  cell = tableView.dequeueReusableCellWithIdentifier("PurchasePototypeCELL", forIndexPath: indexPath) as! PurchaseTableViewCell
            
            cell.lblMemo.text = "purchase memo"
            cell.lblTotalAmount.text = "$500.00"
            cell.lblSupplierName.text =  "testSupplier1"
            cell.lblTransactionDate.text = "20/4/2016"
            
            // Configure the cell...
            
            return cell
        }
   

}
