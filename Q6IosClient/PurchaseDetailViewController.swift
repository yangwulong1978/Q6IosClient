//
//  PurchaseDetailViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 3/05/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class PurchaseDetailViewController: UIViewController, UITableViewDelegate ,UITableViewDataSource,Q6GoBackFromView, Q6WebApiProtocol {
    
    
    @IBOutlet weak var Q6ActivityIndicatorView: UIActivityIndicatorView!
    // @IBOutlet weak var lblPurchasesType: UILabel!
    @IBOutlet var purchaseDetailTableView: UITableView!
    //@IBOutlet weak var lblTotalAmount: UILabel!
    //@IBOutlet weak var lblTotalLabel: UILabel!
    
    var purchasesDetailScreenLinesDic = [ScreenSortLinesDetail]()
    
    var originalRowsDic: [Int: String] = [0: "PurchasesTypecell", 1: "SupplierCell",2: "DueDateCell",3: "AddanItemCell",4: "SubTotalCell",5: "TotalCell",6: "TransactionDateCell",7: "MemoCell",8: "AddanImageCell"]
    
    var addItemsDic = [Int:String]()
    
    var backFrom = String()
    
    var purchasesTransactionHeader = PurchasesTransactionsHeader()
    var purchasesTransactionsDetailData = [PurchasesTransactionsDetail]()
    
    var supplier = Supplier()
    
    var attachedimage = UIImage?()
    
    var webAPICallAction: String = ""
    var operationType = String()
    var hasAddedItemLine = false
    var addItemRowIndex: Int = 0
    var isPreLoad = false
    var CompanyID = String()
    override func viewWillAppear(animated: Bool) {
        
        
        print("PurchaseDetailViewController" + operationType)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setScreenSortLines()
        print("purchasesDetailScreenLinesDic" + purchasesDetailScreenLinesDic.count.description)
        setControlAppear()
        
        purchaseDetailTableView.delegate = self
        purchaseDetailTableView.dataSource = self
        
        if operationType == "Edit"
        {
            purchaseDetailTableView.hidden = true
            Q6ActivityIndicatorView.startAnimating()
            let q6CommonLib = Q6CommonLib(myObject: self)
            
            var attachedURL = "&PurchasesTransactionsHeaderID=" + purchasesTransactionHeader.PurchasesTransactionsHeaderID
            isPreLoad = true
            q6CommonLib.Q6IosClientGetApi("Purchase", ActionName: "GetPurchasesTransactionsByID", attachedURL: attachedURL)
        }
        else {
              Q6ActivityIndicatorView.hidden = true
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem()
            preloadFields()
        }
    }
    
    func preloadFields()
    {
        
        let q6DBLib = Q6DBLib()
        
        
        var dicData=[String:String]()
        var tempdicData = q6DBLib.getUserInfos()
        
        
        dicData["WebApiTOKEN"]=Q6CommonLib.getQ6WebAPIToken()
        dicData["LoginUserName"]=tempdicData["LoginEmail"]
        dicData["Password"]=tempdicData["PassWord"]
        dicData["ClientIP"]=Q6CommonLib.getIPAddresses()
        
        let q6CommonLib = Q6CommonLib(myObject: self)
        webAPICallAction = "InternalUserLogin"
        isPreLoad = true
        q6CommonLib.Q6IosClientPostAPI("Q6",ActionName: "InternalUserLogin", dicData:dicData)
        
    }
    func setScreenSortLines()
    {
        if ValidteWhetherHasAddedLinesInPurchasesDetailScreenLinesDic() == false
        {
            for index in 0 ... 8 {
                
                var screenSortLinesDetail = ScreenSortLinesDetail()
                var prototypeCell = String()
                
                switch index {
                case 0:
                    prototypeCell = "PurchasesTypecell"
                case 1:
                    prototypeCell = "SupplierCell"
                case 2:
                    prototypeCell = "DueDateCell"
                case 3:
                    prototypeCell = "AddanItemCell"
                case 4:
                    prototypeCell = "SubTotalCell"
                case 5:
                    prototypeCell = "TotalCell"
                case 6:
                    prototypeCell = "TransactionDateCell"
                case 7:
                    prototypeCell = "MemoCell"
                case 8:
                    prototypeCell = "AddanImageCell"
                default:
                    prototypeCell = ""
                }
                
                screenSortLinesDetail.ID = index
                screenSortLinesDetail.PrototypeCellID = prototypeCell
                screenSortLinesDetail.LineDescription = "OriginalLine"
                
                purchasesDetailScreenLinesDic.append(screenSortLinesDetail)
                
            }
        }
        
    }
    func setControlAppear()
    {
        // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
        //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        
        purchaseDetailTableView.tableFooterView = UIView(frame: CGRectZero)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // print("addItemsDic" + addItemsDic.count.description)
        // return originalRowsDic.count + addItemsDic.count
        return purchasesDetailScreenLinesDic.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var resuseIdentifier = String()
        //        if indexPath.row <= 8 {
        //       resuseIdentifier = originalRowsDic[indexPath.row]!
        //        }
        //        if indexPath.row > 8 {
        //             resuseIdentifier = originalRowsDic[5]!
        //        }
        
        var screenSortLinesDetail = purchasesDetailScreenLinesDic[indexPath.row]  as ScreenSortLinesDetail
        
        resuseIdentifier = screenSortLinesDetail.PrototypeCellID
        let cell = tableView.dequeueReusableCellWithIdentifier(resuseIdentifier, forIndexPath: indexPath) as! PurchaseDetailTableViewCell
        
        
        if resuseIdentifier == "PurchasesTypecell" {
            
            cell.lblPurchasesType.text = purchasesTransactionHeader.PurchasesType
            
            if operationType != "Create"{
                cell.PurchasesTypeButton.enabled = false
            }
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        if resuseIdentifier == "SupplierCell" {
            
            cell.lblSupplierName.text = supplier.SupplierName
            
            if operationType != "Create" {
                cell.SupplierButton.enabled = false
                
            }
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "DueDateCell" {
            
         
            if purchasesTransactionHeader.DueDate != nil {
                
                
                cell.lblDueDate.text = purchasesTransactionHeader.DueDate!.formatted
            }
            
            
            //
            
            
            
            
        }
        
        if resuseIdentifier == "AddanItemCell" {
            
            if purchasesDetailScreenLinesDic[indexPath.row].isAdded == true {
                
                let image = UIImage(named: "Minus-25") as UIImage?
                
                
                
                
                
                
                cell.AddDeleteButton.setImage(image, forState: .Normal)
                cell.LineDescription.text = purchasesDetailScreenLinesDic[indexPath.row].LineDescription
                
            }
            else {
                
                let image = UIImage(named: "plus") as UIImage?
                
                
                
                // let image = UIImage(named: "name") as UIImage?
                // cell.AddDeleteButton = UIButton(type: .System) as UIButton
                
                
                cell.AddDeleteButton.setImage(image, forState: .Normal)
                cell.LineDescription.text = "Add an Item"
                
                
            }
            
        }
        
        
        if resuseIdentifier == "SubTotalCell" {
            
            var subTotalAmount: Double = 0
            
      
            for i in 0 ..< purchasesDetailScreenLinesDic.count
            {
                if purchasesDetailScreenLinesDic[i].isAdded == true
                {
                    if purchasesDetailScreenLinesDic[i].purchasesTransactionsDetailView != nil {
                        
                        var purchasesTransactionsDetailView = purchasesDetailScreenLinesDic[i].purchasesTransactionsDetailView
                        
                        subTotalAmount = subTotalAmount + (purchasesTransactionsDetailView?.AmountWithoutTax)!
                    }
                }
            }
                
            
            cell.lblSubTotalAmount.text =  String(format: "%.2f", subTotalAmount)
            
            purchasesTransactionHeader.SubTotal = subTotalAmount
            
        }
        if resuseIdentifier == "TotalCell" {
            
            cell.lblTotalAmountLabel.font = UIFont.boldSystemFontOfSize(17.0)
            cell.lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
            
            var totalAmount: Double = 0
            for i in 0 ..< purchasesDetailScreenLinesDic.count
            {
                if purchasesDetailScreenLinesDic[i].isAdded == true
                {
                    if purchasesDetailScreenLinesDic[i].purchasesTransactionsDetailView != nil {
                        
                        var purchasesTransactionsDetailView = purchasesDetailScreenLinesDic[i].purchasesTransactionsDetailView
                        
                        totalAmount = totalAmount + (purchasesTransactionsDetailView?.Amount)!
                    }
                }
            }
            
            cell.lblTotalAmount.text =   String(format: "%.2f", totalAmount)
            
            purchasesTransactionHeader.TotalAmount = totalAmount
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "AddanImageCell" {
            
            if attachedimage != nil {
                
                cell.AddRemoveImageButton.setImage(UIImage(named: "Minus-25.png"), forState: UIControlState.Normal)
                cell.lblAddImageLabel.text = "Has a linked image!"
            }
            
            
            // lblTotalLabel.font = UIFont.boldSystemFontOfSize(17.0)
            //lblTotalAmount.font = UIFont.boldSystemFontOfSize(17.0)
        }
        
        if resuseIdentifier == "TransactionDateCell" {
            
            //            if purchasesTransactionHeader.TransactionDate == nil {
            //
            //
            //                purchasesTransactionHeader.DueDate = NSDate()
            //            }
            
            //
            cell.lblTransactionDate.text = purchasesTransactionHeader.TransactionDate.formatted
            
            
            
        }
        if resuseIdentifier == "MemoCell" {
            
            
            cell.lblMemo.text = purchasesTransactionHeader.Memo
            
            
        }
        
        
        return cell
        
        
        // Configure the cell...
        print("indexPath" + indexPath.row.description)
        
        //return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row //2
        
        print("Selected Row" + indexPath.row.description)
        var screenSortLinesDetail = purchasesDetailScreenLinesDic[indexPath.row]  as ScreenSortLinesDetail
        print("screenSortLinesDetail.PrototypeCellID" + screenSortLinesDetail.PrototypeCellID)
        if screenSortLinesDetail.PrototypeCellID == "PurchasesTypecell" && operationType == "Create" {
            
            performSegueWithIdentifier("showPickerView", sender: "PurchasesTypecell")
            
            
        }
        print("screenSortLinesDetail.PrototypeCellID" + screenSortLinesDetail.PrototypeCellID)
        print("operationType" + operationType)
        if screenSortLinesDetail.PrototypeCellID == "SupplierCell" && operationType == "Create" {
            
            
            for item in  purchasesDetailScreenLinesDic
            {
                if item.isAdded == true
                {
                    hasAddedItemLine = true
                }
            }
            
            
            
            
            
            self.performSegueWithIdentifier("showContactSearch", sender: "SupplierCell")
            
            
            
            
            
        }
        if screenSortLinesDetail.PrototypeCellID == "DueDateCell" {
            if purchasesTransactionHeader.SupplierID.length != 0 {
                performSegueWithIdentifier("showDueDate", sender: "DueDateCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Supplier must be seleted!", viewController: self)
            }
            
            
        }
        
        
        
        if screenSortLinesDetail.PrototypeCellID == "AddanImageCell" {
            
            if purchasesTransactionHeader.SupplierID.length != 0 {
                performSegueWithIdentifier("showPhoto", sender: "AddanImageCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Supplier must be seleted!", viewController: self)
            }
            
        }
        
        if screenSortLinesDetail.PrototypeCellID == "AddanItemCell" {
            
            if purchasesTransactionHeader.SupplierID.length != 0 {
                addItemRowIndex = indexPath.row
                performSegueWithIdentifier("showItemDetail", sender: "AddanItemCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Supplier must be seleted!", viewController: self)
            }
            
            
            
        }
        
        
        if screenSortLinesDetail.PrototypeCellID == "TransactionDateCell" {
            if purchasesTransactionHeader.SupplierID.length != 0 {
                performSegueWithIdentifier("showTransactionDate", sender: "TransactionDateCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Supplier must be seleted!", viewController: self)
            }
            
            
        }
        
        if screenSortLinesDetail.PrototypeCellID == "MemoCell" {
            if purchasesTransactionHeader.SupplierID.length != 0 {
                performSegueWithIdentifier("showMemo", sender: "MemoCell")
            }
            else{
                Q6CommonLib.q6UIAlertPopupController("Information", message: "A Supplier must be seleted!", viewController: self)
            }
            
            
        }
        
        var index = addItemsDic.count
        addItemsDic[index] = "One more Item"
        // let section = indexPath.section//3
        //        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        //        self.purchaseDetailTableView.reloadData()
        //            })
        //        let order = menuItems.items[section][row] + " " + menuItems.sections[section] //4
        // navigationItem.title = order
    }
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        if purchasesDetailScreenLinesDic[indexPath.row].isAdded == true {
            return true
        }
        else {
            return false
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            if purchasesDetailScreenLinesDic[indexPath.row].isAdded == true
            {
                
                print("indexPath.row delete" + indexPath.row.description)
                purchasesDetailScreenLinesDic.removeAtIndex(indexPath.row)
                
                
                for i in 0 ..< purchasesDetailScreenLinesDic.count
                {
                    print("purchasesDetailScreenLinesDic[" + i.description + "].ID" + purchasesDetailScreenLinesDic[i].ID.description)
                    
                    print("purchasesDetailScreenLinesDic[" + i.description  + "].isAdded" + purchasesDetailScreenLinesDic[i].isAdded.description)
                    
                    print("purchasesDetailScreenLinesDic[" + i.description  + "].PrototypeCellID" +
                        purchasesDetailScreenLinesDic[i].PrototypeCellID)
                    
                    print("purchasesDetailScreenLinesDic[i].LineDescription"  + purchasesDetailScreenLinesDic[i].LineDescription)
                    
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.purchaseDetailTableView.reloadData()
                    
                })
                
                
                
            }
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if sender is String {
            
            let fromCell = sender as! String
            //        if let fromCell = sender as? String {
            
            
            
            
            if fromCell == "PurchasesTypecell"
            {
                var pickerViewController = segue.destinationViewController as! PickerViewViewController
                pickerViewController.fromCell = "PurchasesTypecell"
                
                pickerViewController.delegate = self
            }
            if fromCell == "SupplierCell"
            {
                
                var contactSearchViewController = segue.destinationViewController as! SupplierSearchViewController
                contactSearchViewController.fromCell = "SupplierCell"
                contactSearchViewController.delegate = self
                contactSearchViewController.hasAddedItemLine = hasAddedItemLine
                
            }
            
            if fromCell == "DueDateCell"
            {
                
                var datePickerViewController = segue.destinationViewController as! DatePickerViewController
                datePickerViewController.fromCell = "DueDateCell"
                datePickerViewController.delegate = self
                
            }
            
            if fromCell == "AddanItemCell"
            {
                var purchaseDetailDataLineViewController = segue.destinationViewController as! PurchaseDetailDataLineViewController
                purchaseDetailDataLineViewController.fromCell = "AddanItemCell"
                
                purchaseDetailDataLineViewController.supplier = supplier
                purchaseDetailDataLineViewController.delegate = self
                purchaseDetailDataLineViewController.purchasesTransactionHeader = purchasesTransactionHeader
                
                if purchasesDetailScreenLinesDic[addItemRowIndex].purchasesTransactionsDetailView != nil {
                    
                    purchaseDetailDataLineViewController.purchasesTransactionsDetailView = purchasesDetailScreenLinesDic[addItemRowIndex].purchasesTransactionsDetailView!
                }
            }
            
            if fromCell == "AddanImageCell"
            {
                var addImageViewController = segue.destinationViewController as! AddImageViewController
                addImageViewController.fromCell = "AddanImageCell"
                
                if attachedimage != nil
                {
                    addImageViewController.attachedImage = attachedimage
                }
                addImageViewController.delegate = self
            }
            
            if fromCell == "TransactionDateCell"
            {
                
                var datePickerViewController = segue.destinationViewController as! DatePickerViewController
                datePickerViewController.fromCell = "TransactionDateCell"
                datePickerViewController.delegate = self
                
            }
            
            if fromCell == "MemoCell"
            {
                
                var purchaseDetailMemoViewController = segue.destinationViewController as! PurchaseDetailMemoViewController
                purchaseDetailMemoViewController.fromCell = "MemoCell"
                
                purchaseDetailMemoViewController.delegate = self
                
                
                purchaseDetailMemoViewController.textValue = purchasesTransactionHeader.Memo
                
                
            }
        }
        
    }
    
    @IBAction func SaveButtonClick(sender: AnyObject) {
        
      
        
        if validateQuantityValue()&&validateDate()&&validateIfPurchaseDetailIsNotEmpty()
        {
            Q6ActivityIndicatorView.hidden = false 
            Q6ActivityIndicatorView.startAnimating()
            
            purchasesTransactionHeader.TaxTotal = purchasesTransactionHeader.TotalAmount - purchasesTransactionHeader.SubTotal
            

            var dicData=[String:AnyObject]()
            
            
            var q6DBLib = Q6DBLib()
            let q6CommonLib = Q6CommonLib(myObject: self)
            var userInfos = q6DBLib.getUserInfos()
            
            var LoginDetail = InternalUserLoginParameter()
            
            LoginDetail.LoginUserName = userInfos["LoginEmail"]!
            LoginDetail.Password = userInfos["PassWord"]!
            LoginDetail.ClientIP = Q6CommonLib.getIPAddresses()
            LoginDetail.WebApiTOKEN = Q6CommonLib.getQ6WebAPIToken()
            
            var NeedValidate = true
            
 
            
            var LoginDetailDicData = [String:AnyObject]()
            
            LoginDetailDicData["Email"] = userInfos["LoginEmail"]!
            LoginDetailDicData["Password"] = userInfos["PassWord"]!
            LoginDetailDicData["CompanyID"] = userInfos["CompanyID"]!
            LoginDetailDicData["WebApiTOKEN"] = Q6CommonLib.getQ6WebAPIToken()
            
            dicData["LoginDetail"] = LoginDetailDicData
            
            if attachedimage != nil {
                purchasesTransactionHeader.HasLinkedDoc = true
                
                var UploadedDocuments = getImageFileDataDic(attachedimage!)
                
                dicData["UploadedDocuments"] = UploadedDocuments
            }
            else{
                dicData["UploadedDocuments"] = nil
            }

            
            
            var purchasesTransactionsDetailDataDic = convertpurchasesTransactionsDetailDataTOArray()
            
            var purchasesTransactionsHeaderDic =   convertpurchasesTransactionsHeaderToArray()
            
            dicData["PurchasesTransactionsDetail"] = purchasesTransactionsDetailDataDic
            dicData["PurchasesTransactionsHeader"] = purchasesTransactionsHeaderDic
            dicData["RecurringTemplateList"] = nil
            
            dicData["NeedValidate"] = true
            var purchasesTransactionsParameter = [String: AnyObject]()
            
            purchasesTransactionsParameter["PurchasesTransactionsParameter"] = dicData
     
            isPreLoad = false
            
            if operationType == "Create" {
              q6CommonLib.Q6IosClientPostAPI("Purchase",ActionName: "AddPurchase", dicData:dicData)
            }
            else if operationType == "Edit"{
                q6CommonLib.Q6IosClientPostAPI("Purchase",ActionName: "EditPurchase", dicData:dicData)
            }
           
            
            
        }
    }
    
    func getImageFileDataDic(image: UIImage) -> [String: AnyObject]
    {
        
        var FileName = "AttachedPhoneImage"
        //
        var imgData: NSData = NSData(data: UIImageJPEGRepresentation((image), 1)!)
        // var imgData: NSData = UIImagePNGRepresentation(image)
        // you can also replace UIImageJPEGRepresentation with UIImagePNGRepresentation.
        var FileSize: Int = imgData.length
        print("File Size" + FileSize.description)
        var HasLinkedTransaction = false
        var LinkedTransactionID = String?()
        var TransactionType = String?()
        var UploadedBy = String?()
        
        var UploadedDate = NSDate().description
        var UploadedDocumentsID = "{00000000-0000-0000-0000-000000000000}"
        var i = CGFloat()
        if  FileSize > 2000000 {
            
            i = CGFloat (2000000 / FileSize)
            
        }
        else {
            i = 1
        }
        var imageData = UIImageJPEGRepresentation(image, i)
        var File = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        var dicData = [String: AnyObject]()
        
        dicData["File"] = File
        dicData["FileName"] = FileName
        dicData["FileSize"] = FileSize
        dicData["HasLinkedTransaction"] = HasLinkedTransaction
        dicData["TransactionType"] = TransactionType
        dicData["UploadedBy"] = UploadedBy
        dicData["UploadedDate"] = UploadedDate
        dicData["UploadedDocumentsID"] = UploadedDocumentsID
        
        return dicData
        //  print("size of image in KB: %f ", imageSize / 1024)
    }
    func convertpurchasesTransactionsHeaderToArray() -> [String: AnyObject]
    {
        var dicData = [String: AnyObject]()
        
        var PurchasesTransactionsHeaderID  = purchasesTransactionHeader.PurchasesTransactionsHeaderID
        
        if operationType == "Create" {
            dicData["PurchasesTransactionsHeaderID"] = "{00000000-0000-0000-0000-000000000000}"
        }
        else {
            dicData["PurchasesTransactionsHeaderID"] = PurchasesTransactionsHeaderID
        }
        dicData["ReferenceNo"] = purchasesTransactionHeader.ReferenceNo
        
        dicData["PurchasesType"] = purchasesTransactionHeader.PurchasesType
        dicData["PurchasesStatus"] = purchasesTransactionHeader.PurchasesStatus
        dicData["TransactionDate"] = purchasesTransactionHeader.TransactionDate.description
        
        print("purchasesTransactionHeader.TransactionDate.description" + purchasesTransactionHeader.TransactionDate.description)
        dicData["CreateTime"] = purchasesTransactionHeader.CreateTime.description
        
//        var LastModifiedTime = NSDate()
//        let dateFormatter = NSDateFormatter()
//        //dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
//       // dateFormatter.timeStyle =  NSDateFormatterStyle.LongStyle
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")
//       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//       var strLastModifiedTime = dateFormatter.stringFromDate(LastModifiedTime)
//        print("strLastModifiedTime" + strLastModifiedTime)
        
        if operationType == "Create" {
            dicData["LastModifiedTime"] = purchasesTransactionHeader.CreateTime.description
        }
        else{
        dicData["LastModifiedTime"] = purchasesTransactionHeader.LastModifiedTime
        }

        dicData["SupplierID"] = purchasesTransactionHeader.SupplierID
        dicData["ShipToAddress"] = purchasesTransactionHeader.ShipToAddress
        dicData["SupplierInv"] = purchasesTransactionHeader.SupplierInv
        dicData["Memo"] = purchasesTransactionHeader.Memo
        
        dicData["ClosedDate"] = purchasesTransactionHeader.ClosedDate?.description
        dicData["SubTotal"] = purchasesTransactionHeader.SubTotal
        dicData["TaxTotal"] = purchasesTransactionHeader.TaxTotal
        dicData["TotalAmount"] = purchasesTransactionHeader.TotalAmount
        dicData["DueDate"] = purchasesTransactionHeader.DueDate?.description
        dicData["TaxInclusive"] = purchasesTransactionHeader.TaxInclusive
        dicData["IsDeleted"] = purchasesTransactionHeader.IsDeleted
        dicData["IsCreatedByRecurring"] = purchasesTransactionHeader.IsCreatedByRecurring
        dicData["RecurringTemplateID"] = purchasesTransactionHeader.RecurringTemplateID
        dicData["HasLinkedDoc"] = purchasesTransactionHeader.HasLinkedDoc
        
        return dicData
        
    }
    
    func convertpurchasesTransactionsDetailDataTOArray()->[[String : AnyObject]]
    {
        var dicData = [[String : AnyObject]]()
        
        if   purchasesTransactionsDetailData.count > 0
        {
            for i in 0..<purchasesTransactionsDetailData.count
            {
                
                var data = [String : AnyObject]()
                
                var PurchasesTransactionsDetailID = purchasesTransactionsDetailData[i].PurchasesTransactionsDetailID
                if operationType == "Create"{
                    data["PurchasesTransactionsDetailID"] = "{00000000-0000-0000-0000-000000000000}"
                }
                else {
                    data["PurchasesTransactionsDetailID"] = PurchasesTransactionsDetailID
                }
                
                
                
                var PurchasesTransactionsHeaderID = purchasesTransactionsDetailData[i].PurchasesTransactionsHeaderID
                
                if operationType == "Create" {
                    data["PurchasesTransactionsHeaderID"] = "{00000000-0000-0000-0000-000000000000}"
                }
                else {
                    data["PurchasesTransactionsHeaderID"] = PurchasesTransactionsHeaderID
                }
                data["Quantity"] = purchasesTransactionsDetailData[i].Quantity
                
                data["InventoryID"] = purchasesTransactionsDetailData[i].InventoryID
                data["AccountID"] = purchasesTransactionsDetailData[i].AccountID
                data["TaxCodeID"] = purchasesTransactionsDetailData[i].TaxCodeID
                data["Description"] = purchasesTransactionsDetailData[i].Description
                
                data["UnitPrice"] = purchasesTransactionsDetailData[i].UnitPrice
                data["Discount"] = purchasesTransactionsDetailData[i].Discount
                data["Amount"] = purchasesTransactionsDetailData[i].Amount
                
                data["IsDeleted"] = purchasesTransactionsDetailData[i].IsDeleted
                data["SortNo"] = purchasesTransactionsDetailData[i].SortNo
                
                dicData.append(data)
                
            }
        }
        
        return dicData
    }
    
    
    func validateIfPurchaseDetailIsNotEmpty() -> Bool
    {
        var IsNotEmpty = true
        copyFromPurchasesTransactionDetailViewToPurchasesTransactionDetail()
        if purchasesTransactionsDetailData.count <= 0
        {
            Q6CommonLib.q6UIAlertPopupController("Information message", message: "You need to add at least one data line before you save purchase transaction !", viewController: self)
            
            IsNotEmpty = false
        }
        
        return IsNotEmpty
        
    }
    func validateDate()-> Bool
    {
        var isValid = true
        if purchasesTransactionHeader.PurchasesType == "BILL"
        {
            if purchasesTransactionHeader.DueDate == nil
            {
                
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "Due Date can not be empty if purchase type is BILL!", viewController: self)
                isValid = false
            }
        }
        
        if purchasesTransactionHeader.DueDate != nil {
            
            var DueDate = purchasesTransactionHeader.DueDate
            var TransactionDate = purchasesTransactionHeader.TransactionDate
            
            var isEalierOrEqual = (DueDate?.isLaterOrEqualThanDate(TransactionDate))! as Bool
            
            if isEalierOrEqual == false {
                Q6CommonLib.q6UIAlertPopupController("Information message", message: "Due Date can not be later than TransactionDate!", viewController: self)
                isValid = false
            }
        }
        return isValid
    }
    func validateQuantityValue() -> Bool
    {
        var isValid = true
        if purchasesTransactionHeader.PurchasesType == "DEBIT NOTE"
        {
            for i in 0..<purchasesDetailScreenLinesDic.count
            {
                var purchasesTransactionsDetailView = purchasesDetailScreenLinesDic[i].purchasesTransactionsDetailView
                
                if purchasesTransactionsDetailView != nil && purchasesDetailScreenLinesDic[i].isAdded == true
                {
                    if  purchasesTransactionsDetailView!.Quantity > 0
                    {
                        Q6CommonLib.q6UIAlertPopupController("Information message", message: "you can not input positive amount at quantity field when purchase type is DEBIT NOTE!", viewController: self)
                        isValid = false
                        
                    }
                }
            }
            
        }
        else {
            for i in 0..<purchasesDetailScreenLinesDic.count
            {
                var purchasesTransactionsDetailView = purchasesDetailScreenLinesDic[i].purchasesTransactionsDetailView
                
                if purchasesTransactionsDetailView != nil && purchasesDetailScreenLinesDic[i].isAdded == true
                {
                    if  purchasesTransactionsDetailView!.Quantity < 0
                    {
                        Q6CommonLib.q6UIAlertPopupController("Information message", message: "you can not input negative amount at quantity field when purchase type is QUOTE,ORDER ,BILL!", viewController: self)
                        isValid = false
                    }
                }
            }
            
        }
        
        return isValid
    }
    
    func copyFromPurchasesTransactionDetailViewToPurchasesTransactionDetail()
    {
        purchasesTransactionsDetailData.removeAll()
        
        var sortNo: Int = 0
        for i in 0..<purchasesDetailScreenLinesDic.count
        {
            var purchasesTransactionsDetailView = purchasesDetailScreenLinesDic[i].purchasesTransactionsDetailView
            if purchasesTransactionsDetailView != nil && purchasesDetailScreenLinesDic[i].isAdded == true
            {
                var purchasesTransactionsDetail = PurchasesTransactionsDetail()
                
                purchasesTransactionsDetail.AccountID = purchasesTransactionsDetailView!.AccountID
                purchasesTransactionsDetail.Amount = purchasesTransactionsDetailView!.Amount
                purchasesTransactionsDetail.Description = purchasesTransactionsDetailView!.Description
                purchasesTransactionsDetail.Discount = purchasesTransactionsDetailView!.Discount
                purchasesTransactionsDetail.InventoryID = purchasesTransactionsDetailView!.InventoryID
                purchasesTransactionsDetail.IsDeleted = purchasesTransactionsDetailView!.IsDeleted
                purchasesTransactionsDetail.PurchasesTransactionsDetailID = purchasesTransactionsDetailView!.PurchasesTransactionsDetailID
                
                purchasesTransactionsDetail.PurchasesTransactionsHeaderID = purchasesTransactionsDetailView!.PurchasesTransactionsHeaderID
                
                purchasesTransactionsDetail.Quantity = purchasesTransactionsDetailView!.Quantity
                purchasesTransactionsDetail.SortNo = sortNo
                sortNo = sortNo + 1
                
                purchasesTransactionsDetail.TaxCodeID = purchasesTransactionsDetailView!.TaxCodeID
                purchasesTransactionsDetail.UnitPrice = purchasesTransactionsDetailView!.UnitPrice
                
                purchasesTransactionsDetailData.append(purchasesTransactionsDetail)
            }
        }
        
        print("purchasesTransactionsDetailData.count" + purchasesTransactionsDetailData.count.description)
        
    }
    
    func copyFromPurchasesTransactionDetailViewToPurchasesTransactionDetailForEdit(purchasesTransactionsDetailList: [PurchasesTransactionsDetailView])
    {
        purchasesTransactionsDetailData.removeAll()
        
      for i in 0 ..< purchasesTransactionsDetailList.count
     {
        var purchasesTransactionDetail = PurchasesTransactionsDetail()
           purchasesTransactionDetail.AccountID = purchasesTransactionsDetailList[i].AccountID
        
        purchasesTransactionDetail.Amount = purchasesTransactionsDetailList[i].Amount
          purchasesTransactionDetail.Description = purchasesTransactionsDetailList[i].Description
        purchasesTransactionDetail.InventoryID = purchasesTransactionsDetailList[i].InventoryID
        purchasesTransactionDetail.PurchasesTransactionsDetailID = purchasesTransactionsDetailList[i].PurchasesTransactionsDetailID
        purchasesTransactionDetail.PurchasesTransactionsHeaderID = purchasesTransactionsDetailList[i].PurchasesTransactionsHeaderID
        purchasesTransactionDetail.Quantity = purchasesTransactionsDetailList[i].Quantity
        purchasesTransactionDetail.SortNo = purchasesTransactionsDetailList[i].SortNo
        purchasesTransactionDetail.TaxCodeID = purchasesTransactionsDetailList[i].TaxCodeID
        purchasesTransactionDetail.UnitPrice = purchasesTransactionsDetailList[i].UnitPrice
    
        purchasesTransactionsDetailData.append(purchasesTransactionDetail)
        
        var screenSortLinesDetail = ScreenSortLinesDetail()
        screenSortLinesDetail.ID = 3 + i
        screenSortLinesDetail.isAdded = true
        screenSortLinesDetail.LineDescription = purchasesTransactionsDetailList[i].InventoryName + purchasesTransactionsDetailList[i].AccountNameWithAccountNo
        screenSortLinesDetail.purchasesTransactionsDetailView = purchasesTransactionsDetailList[i]
        screenSortLinesDetail.PrototypeCellID = "AddanItemCell"
        
        purchasesDetailScreenLinesDic.insert(screenSortLinesDetail, atIndex: screenSortLinesDetail.ID)
       
        
        }
        
        print("purchasesTransactionsDetailData" + purchasesTransactionsDetailData.count.description)
        print("purchasesDetailScreenLinesDic" + purchasesDetailScreenLinesDic.count.description)
//        var sortNo: Int = 0
//        for i in 0..<purchasesDetailScreenLinesDic.count
//        {
//            var purchasesTransactionsDetailView = purchasesDetailScreenLinesDic[i].purchasesTransactionsDetailView
//            if purchasesTransactionsDetailView != nil && purchasesDetailScreenLinesDic[i].isAdded == true
//            {
//                var purchasesTransactionsDetail = PurchasesTransactionsDetail()
//                
//                purchasesTransactionsDetail.AccountID = purchasesTransactionsDetailView!.AccountID
//                purchasesTransactionsDetail.Amount = purchasesTransactionsDetailView!.Amount
//                purchasesTransactionsDetail.Description = purchasesTransactionsDetailView!.Description
//                purchasesTransactionsDetail.Discount = purchasesTransactionsDetailView!.Discount
//                purchasesTransactionsDetail.InventoryID = purchasesTransactionsDetailView!.InventoryID
//                purchasesTransactionsDetail.IsDeleted = purchasesTransactionsDetailView!.IsDeleted
//                purchasesTransactionsDetail.PurchasesTransactionsDetailID = purchasesTransactionsDetailView!.PurchasesTransactionsDetailID
//                
//                purchasesTransactionsDetail.PurchasesTransactionsHeaderID = purchasesTransactionsDetailView!.PurchasesTransactionsHeaderID
//                
//                purchasesTransactionsDetail.Quantity = purchasesTransactionsDetailView!.Quantity
//                purchasesTransactionsDetail.SortNo = sortNo
//                sortNo = sortNo + 1
//                
//                purchasesTransactionsDetail.TaxCodeID = purchasesTransactionsDetailView!.TaxCodeID
//                purchasesTransactionsDetail.UnitPrice = purchasesTransactionsDetailView!.UnitPrice
//                
//                purchasesTransactionsDetailData.append(purchasesTransactionsDetail)
//            }
//        }
//        
//        print("purchasesTransactionsDetailData.count" + purchasesTransactionsDetailData.count.description)
        
    }
    @IBAction func CancelButtonClick(sender: AnyObject) {
        
        //        if let purchaseViewController = storyboard!.instantiateViewControllerWithIdentifier("PurchaseViewController") as? PurchaseViewController {
        //
        //            presentViewController(purchaseViewController, animated: true, completion: nil)
        //        }
        //navigationController?.popViewControllerAnimated(true)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    //    func performFromRightToLeft(sourceViewController :AnyObject , destinationViewController: AnyObject)
    //    {
    //        let src = sourceViewController.sourceViewController
    //        let dst = destinationViewController.destinationViewController
    //
    //        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
    //        dst.view.transform = CGAffineTransformMakeTranslation(-src.view.frame.size.width, 0)
    //
    //        UIView.animateWithDuration(0.25,
    //                                   delay: 0.0,
    //                                   options: UIViewAnimationOptions.CurveEaseInOut,
    //                                   animations: {
    //                                    dst.view.transform = CGAffineTransformMakeTranslation(0, 0)
    //            },
    //                                   completion: { finished in
    //        })
    //
    //
    //    }
    func searchLastAddedIndexInPurchaseDetailScreenLinesDic() -> Int? {
        
        var indexPath = Int?()
        
        
        for index in 0 ..< purchasesDetailScreenLinesDic.count {
            var screenSortLinesDetail = purchasesDetailScreenLinesDic[index]  as ScreenSortLinesDetail
            
            if screenSortLinesDetail.isAdded == true {
                indexPath = index
            }
        }
        return indexPath
    }
    
    func ValidteWhetherHasAddedLinesInPurchasesDetailScreenLinesDic() -> Bool {
        
        for index in 0 ..< purchasesDetailScreenLinesDic.count {
            var screenSortLinesDetail = purchasesDetailScreenLinesDic[index]  as ScreenSortLinesDetail
            
            if screenSortLinesDetail.isAdded == true {
                return true
            }
            
        }
        return false
    }
    func sendGoBackFromPickerView(fromView : String ,forCell: String,selectedValue : String)
    {
        self.backFrom = fromView
        
        if fromView == "fromPickerViewViewController" {
            if forCell == "PurchasesTypecell" {
                
                purchasesTransactionHeader.PurchasesType = selectedValue
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.purchaseDetailTableView.reloadData()
                    
                })
                
            }
        }
        print("backFrom" + self.backFrom)
    }
    
    func  sendGoBackFromSupplierSearchView(fromView : String ,forCell: String,Contact:Supplier){
        
        if fromView == "SupplierSearchViewController" {
            if forCell == "SupplierCell" {
                purchasesTransactionHeader.SupplierID = Contact.SupplierID
               
                supplier = Contact
                
                print("purchasesTransactionHeader.SupplierID" + purchasesTransactionHeader.SupplierID)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.purchaseDetailTableView.reloadData()
                    
                })
            }
        }
        
        
    }
    func sendGoBackFromDatePickerView(fromView:String, forCell:String ,Date: NSDate)
    {
        if fromView == "DatePickerViewController" {
            if forCell == "DueDateCell" {
                purchasesTransactionHeader.DueDate = Date
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.purchaseDetailTableView.reloadData()
                    
                })
                
            }
            
            if forCell == "TransactionDateCell" {
                purchasesTransactionHeader.TransactionDate = Date
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.purchaseDetailTableView.reloadData()
                    
                })
                
            }
            
        }
        
    }
    
    
    func sendGoBackFromPurchaseDetailDataLineView(fromView:String,forCell:String,purchasesTransactionsDetailView: PurchasesTransactionsDetailView){
        
        if purchasesDetailScreenLinesDic[addItemRowIndex].isAdded == false{
            
            var screenSortLinesDetail = ScreenSortLinesDetail()
            screenSortLinesDetail.isAdded = true
            screenSortLinesDetail.ID = addItemRowIndex
            screenSortLinesDetail.LineDescription = purchasesTransactionsDetailView.InventoryName + " " + purchasesTransactionsDetailView.AccountNameWithAccountNo
            screenSortLinesDetail.PrototypeCellID = "AddanItemCell"
            screenSortLinesDetail.purchasesTransactionsDetailView = purchasesTransactionsDetailView
            purchasesDetailScreenLinesDic.insert(screenSortLinesDetail, atIndex: addItemRowIndex)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.purchaseDetailTableView.reloadData()
                
            })
        }
        else{
            purchasesDetailScreenLinesDic[addItemRowIndex].LineDescription = purchasesTransactionsDetailView.InventoryName + " " + purchasesTransactionsDetailView.AccountNameWithAccountNo
            purchasesDetailScreenLinesDic[addItemRowIndex].purchasesTransactionsDetailView = purchasesTransactionsDetailView
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.purchaseDetailTableView.reloadData()
                
            })
        }
    }
    func sendGoBackFromPurchaseDetailDataLineInventorySearchView(fromView:String,forCell:String,inventoryView: InventoryView){
        
    }
    
    func  sendGoBackFromPurchaseDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
    {
        
    }
    func  sendGoBackFromPurchaseDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
    {
        
    }
    
    func  sendGoBackFromPurchaseDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)
    {
        
    }
    
    func sendGoBackFromAddImageView(fromView: String, forCell: String, image:UIImage)
    {
        if fromView == "AddImageViewController" {
            if forCell == "AddanImageCell" {
                attachedimage = image
                
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.purchaseDetailTableView.reloadData()
                    
                })
                
            }
        }
    }
    
    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    {
        if operationType == "Edit" && isPreLoad == true {
            
            var postDicData :[String:AnyObject]
            
            do {
                //                if dataRequestSource == "Search" {
                //                    supplierData.removeAll()
                //                    selectedSuplier = nil
                //                }
                postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                
                var returnPurchasesTransactionHeaderData = postDicData["PurchasesTransactionsHeader"]  as? [String:AnyObject]
                
                if returnPurchasesTransactionHeaderData != nil {
                    
                    var purchasesTransactionsHeaderView =   initialPurchasepurchasesTransactionsHeaderView(returnPurchasesTransactionHeaderData!)
                    
                    copyFromPurchasesTransactionsHeaderViewToPurchasesTransactionsHeader(purchasesTransactionsHeaderView)
                  
                  
                }
                
                var returnPurchasesTransactionsDetailListData = postDicData["PurchasesTransactionsDetailList"]  as? [[String:AnyObject]]
                
                
                if returnPurchasesTransactionsDetailListData != nil {
                   
             var purchasesTransactionsDetailView =    initialPurchasepurchasesTransactionsDetailListView(returnPurchasesTransactionsDetailListData!)
                    
                       copyFromPurchasesTransactionDetailViewToPurchasesTransactionDetailForEdit(purchasesTransactionsDetailView)
                    
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.purchaseDetailTableView.reloadData()
//                        self.Q6ActivityIndicatorView.hidesWhenStopped = true
//                        self.Q6ActivityIndicatorView.stopAnimating()
//                        self.ContactSearchBox.resignFirstResponder()
                        
                        self.purchaseDetailTableView.hidden = false
                        self.Q6ActivityIndicatorView.hidesWhenStopped = true
                        self.Q6ActivityIndicatorView.stopAnimating()
                    })
                    
                }
            } catch  {
                print("error parsing response from POST on /posts")
                
                return ""
            }
            
            
        }
        
        if isPreLoad == true && operationType == "Create" {
            
            
            
            var postDicData :[String:AnyObject]
            var IsLoginSuccessed : Bool
            do {
                postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                
                
                IsLoginSuccessed = postDicData["IsSuccessed"] as! Bool
                
                
                if IsLoginSuccessed == true {
                    
                    var q6CommonLib = Q6CommonLib()
                    var returnValue = postDicData["ReturnValue"]! as! Dictionary<String, AnyObject>
                    //
                    var shippingAddress = ShippingAddress()
                    var Address = returnValue["ShippingAddress"] as? String
                    
                    
                    if Address != nil {
                        shippingAddress.ShippingAddress = Address!
                    }
                    var  ShippingAddressLine2 = returnValue["ShippingAddressLine2"] as? String
                    
                    if ShippingAddressLine2 != nil {
                        shippingAddress.ShippingAddressLine2 = ShippingAddressLine2!
                    }
                    
                    var  ShippingCity = returnValue["ShippingCity"] as? String
                    
                    if ShippingCity != nil {
                        shippingAddress.ShippingCity = ShippingCity!
                    }
                    var ShippingCountry = returnValue["ShippingCountry"] as? String
                    
                    if ShippingCountry != nil {
                        shippingAddress.ShippingCountry = ShippingCountry!
                    }
                    
                    var ShippingPostalCode = returnValue["ShippingPostalCode"] as? String
                    
                    if ShippingPostalCode != nil {
                        shippingAddress.ShippingPostalCode = ShippingPostalCode!
                    }
                    
                    var ShippingState = returnValue["ShippingState"] as? String
                    
                    if ShippingState != nil {
                        shippingAddress.ShippingState = ShippingState!
                    }
                    
                    var RealCompanyName = returnValue["RealCompanyName"] as? String
                    
                    if RealCompanyName != nil {
                        shippingAddress.RealCompanyName = RealCompanyName!
                    }
                    purchasesTransactionHeader.ShipToAddress = shippingAddress.getShippingAddressStr()
                    
                    print("purchasesTransactionHeader.ShipToAddress" + purchasesTransactionHeader.ShipToAddress)
                    //                //var json = try  NSJSONSerialization.JSONObjectWithData(dd as! NSData, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, String>
                    //
                    //                let q6DBLib = Q6DBLib()
                    //
                    //
                    //                q6DBLib.addUserInfos(txtLoginEmail.text!, PassWord: txtLoginPassword.text!, LoginStatus: "Login",CompanyID: companyID)
                    //                //Set any attributes of the view controller before it is displayed, this is where you would set the category text in your code.
                    //
                    //                var passCode = q6DBLib.getUserPassCode()
                    //
                    //
                    //
                    //                if let passCodeViewController = storyboard!.instantiateViewControllerWithIdentifier("Q6PassCodeViewController") as? PassCodeViewController {
                    //
                    //                    if passCode == nil {
                    //
                    //                        passCodeViewController.ScreenMode = "CreatePassCode"
                    //                    }
                    //                    else {
                    //                        passCodeViewController.ScreenMode = "ValidatePassCode"
                    //                    }
                    //                    presentViewController(passCodeViewController, animated: true, completion: nil)
                    //                }
                    //
                }
                //
                //
            } catch  {
                print("error parsing response from POST on /posts")
                
                return ""
            }
        }
        
        if isPreLoad == false && (operationType == "Create"||operationType == "Edit") {
            
            var postDicData :[String:AnyObject]
            var IsSuccessed : Bool?
            
            do {
                postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                
                IsSuccessed = postDicData["IsSuccessed"] as? Bool
                if IsSuccessed != nil {
                    IsSuccessed = postDicData["IsSuccessed"] as! Bool
                }
                ////                else{
                //                var message = postDicData["Message"] as! String
                //                print("Message" + message)
                ////                }
                if IsSuccessed == true {
                    
                    var nav = navigationController
                   // Q6CommonLib.q6UIAlertPopupControllerThenGoBack("Information message", message: "Save Successfully!", viewController: self,timeArrange:3,navigationController: nav!)
                    
                    
                    let alert = UIAlertController(title: "Information message", message: "Save Successfully!", preferredStyle: UIAlertControllerStyle.Alert)
                   self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW,
                                                  Int64(3 * Double(NSEC_PER_SEC)))
                    let delayTime2 = dispatch_time(DISPATCH_TIME_NOW,
                                                  Int64(4 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        self.dismissViewControllerAnimated(true, completion: nil);
                      // self.navigationController!.popViewControllerAnimated(true)
                       // self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    dispatch_after(delayTime2, dispatch_get_main_queue()) {
                       // self.dismissViewControllerAnimated(true, completion: nil);
                        self.navigationController!.popViewControllerAnimated(true)
                        // self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    //self.navigationController!.popViewControllerAnimated(true)
                    //                     public static func q6UIAlertPopupControllerThenGoBack(title: String?,message:String?,viewController: AnyObject? ,timeArrange: Double ,navigationController: UINavigationController)
                    //                    var q6CommonLib = Q6CommonLib()
                    //                    var returnValue = postDicData["ReturnValue"]! //as! Dictionary<String, AnyObject>
                    
                    // navigationController?.popViewControllerAnimated(true)
                    
                    //
                }
                else {
                    Q6CommonLib.q6UIAlertPopupController("Information message", message: "Save Fail!", viewController: self, timeArrange:2)
                }
                
            } catch  {
                print("error parsing response from POST on /posts")
                
                return ""
            }
            
            
        }
        
        //
        return ""
    }
    
    func initialPurchasepurchasesTransactionsDetailListView(returnPurchasesTransactionDetailListData : [[String: AnyObject]]) ->[PurchasesTransactionsDetailView]
    {
        var purchasesTransactionsDetailViewList = [PurchasesTransactionsDetailView]()
        
        for i in 0..<returnPurchasesTransactionDetailListData.count
        {
           var purchasesTransactionsDetailView = PurchasesTransactionsDetailView()
            
            purchasesTransactionsDetailView.AccountID = returnPurchasesTransactionDetailListData[i]["AccountID"] as! String
            purchasesTransactionsDetailView.AccountNameWithAccountNo = returnPurchasesTransactionDetailListData[i]["AccountNameWithAccountNo"] as! String
            
            
            purchasesTransactionsDetailView.Amount = returnPurchasesTransactionDetailListData[i]["Amount"] as! Double
            
            
            purchasesTransactionsDetailView.Description = returnPurchasesTransactionDetailListData[i]["Description"] as! String
            
            purchasesTransactionsDetailView.InventoryID = returnPurchasesTransactionDetailListData[i]["InventoryID"] as? String
            
           purchasesTransactionsDetailView.InventoryName = returnPurchasesTransactionDetailListData[i]["InventoryName"] as! String
            
            purchasesTransactionsDetailView.PurchasesTransactionsDetailID = returnPurchasesTransactionDetailListData[i]["PurchasesTransactionsDetailID"] as! String
            
            purchasesTransactionsDetailView.PurchasesTransactionsHeaderID = returnPurchasesTransactionDetailListData[i]["PurchasesTransactionsHeaderID"] as! String
            
            purchasesTransactionsDetailView.Quantity = returnPurchasesTransactionDetailListData[i]["Quantity"] as! Double
            purchasesTransactionsDetailView.SortNo = i
            
            purchasesTransactionsDetailView.TaxCodeID = returnPurchasesTransactionDetailListData[i]["TaxCodeID"] as? String
            
            purchasesTransactionsDetailView.TaxCodeName = returnPurchasesTransactionDetailListData[i]["TaxCodeName"] as! String
            
             purchasesTransactionsDetailView.TaxCodeRate = returnPurchasesTransactionDetailListData[i]["TaxCodeRate"] as? Double
            
            if purchasesTransactionsDetailView.TaxCodeRate != nil
            {
                print("purchasesTransactionsDetailView.TaxCodeRate" + purchasesTransactionsDetailView.TaxCodeRate!.description)
            }
            else{
                 print("purchasesTransactionsDetailView.TaxCodeRate  nil")
            }
            
          
            purchasesTransactionsDetailView.UnitPrice = returnPurchasesTransactionDetailListData[i]["UnitPrice"] as! Double

           
            if purchasesTransactionsDetailView.TaxCodeID != nil {
                
                var taxCodeRate = purchasesTransactionsDetailView.TaxCodeRate
                
                var amount = purchasesTransactionsDetailView.Amount
                
                purchasesTransactionsDetailView.AmountWithoutTax = amount / (1 + taxCodeRate!/100)
                
                
            }
    
       purchasesTransactionsDetailViewList.append(purchasesTransactionsDetailView)
            
           
        }
        
       return purchasesTransactionsDetailViewList
    }
    func initialPurchasepurchasesTransactionsHeaderView(returnPurchasesTransactionHeaderData : [String: AnyObject]!) -> PurchasesTransactionsHeaderView
    {
        
        var purchasesTransactionsHeaderView = PurchasesTransactionsHeaderView()
        purchasesTransactionsHeaderView.ClosedDate = returnPurchasesTransactionHeaderData!["ClosedDate"] as? NSDate
        
        
        
        var DueDate = returnPurchasesTransactionHeaderData!["DueDate"] as? String
        
        if DueDate != nil {
            print("DueDate" + DueDate!)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeZone = NSTimeZone(name: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            purchasesTransactionsHeaderView.DueDate = dateFormatter.dateFromString(DueDate!)
        }
        else{
        purchasesTransactionsHeaderView.DueDate = nil
        }
       // purchasesTransactionsHeaderView.DueDate = returnPurchasesTransactionHeaderData!["DueDate"] as? NSDate
        
        if purchasesTransactionsHeaderView.DueDate != nil {
            
            print("purchasesTransactionsHeaderView.DueDate" + purchasesTransactionsHeaderView.DueDate!.description)
        }
        else {
            print("purchasesTransactionsHeaderView.DueDate nil")
        }
        
        purchasesTransactionsHeaderView.HasLinkedDoc = returnPurchasesTransactionHeaderData!["HasLinkedDoc"] as! Bool
        
        
        
        var LastModifiedTime = returnPurchasesTransactionHeaderData!["LastModifiedTime"] as! String
        
        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.timeZone = NSTimeZone(name: "UTC")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        purchasesTransactionsHeaderView.LastModifiedTime = LastModifiedTime
        
        
        
        
        purchasesTransactionsHeaderView.LinkDocumentFile = returnPurchasesTransactionHeaderData!["LinkDocumentFile"] as? String
        
        
        
        purchasesTransactionsHeaderView.LinkDocumentFileName = returnPurchasesTransactionHeaderData!["LinkDocumentFileName"] as? String
        
        
        purchasesTransactionsHeaderView.LinkDocumentFileSize = returnPurchasesTransactionHeaderData!["LinkDocumentFileSize"] as? Double
        
        
        
        
        purchasesTransactionsHeaderView.Memo = returnPurchasesTransactionHeaderData!["Memo"] as! String
        
        purchasesTransactionsHeaderView.PurchasesStatus = returnPurchasesTransactionHeaderData!["PurchasesStatus"] as! String
        purchasesTransactionsHeaderView.PurchasesTransactionsHeaderID = returnPurchasesTransactionHeaderData!["PurchasesTransactionsHeaderID"] as! String
        
        purchasesTransactionsHeaderView.PurchasesType = returnPurchasesTransactionHeaderData!["PurchasesType"] as! String
        
        purchasesTransactionsHeaderView.ReferenceNo = returnPurchasesTransactionHeaderData!["ReferenceNo"] as! String
        
        purchasesTransactionsHeaderView.ShipToAddress = returnPurchasesTransactionHeaderData!["ShipToAddress"] as! String
        purchasesTransactionsHeaderView.SubTotal = returnPurchasesTransactionHeaderData!["SubTotal"] as! Double
        
        purchasesTransactionsHeaderView.SupplierID = returnPurchasesTransactionHeaderData!["SupplierID"] as! String
        
        purchasesTransactionsHeaderView.SupplierInv = returnPurchasesTransactionHeaderData!["SupplierInv"] as! String
        purchasesTransactionsHeaderView.SupplierName = returnPurchasesTransactionHeaderData!["SupplierName"] as! String
        
        supplier.SupplierID = purchasesTransactionsHeaderView.SupplierID
        supplier.SupplierName = purchasesTransactionsHeaderView.SupplierName
        purchasesTransactionsHeaderView.TaxInclusive = returnPurchasesTransactionHeaderData!["TaxInclusive"] as! Bool
        
        purchasesTransactionsHeaderView.TaxTotal = returnPurchasesTransactionHeaderData!["TaxTotal"] as! Double
        purchasesTransactionsHeaderView.TotalAmount = returnPurchasesTransactionHeaderData!["TotalAmount"] as! Double
        
        
        
        
        var TransactionDate  = returnPurchasesTransactionHeaderData!["TransactionDate"] as! String
        
        
        let dateFormatter2 = NSDateFormatter()
        dateFormatter2.timeZone = NSTimeZone(name: "UTC")
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        purchasesTransactionsHeaderView.TransactionDate = dateFormatter2.dateFromString(TransactionDate)!
        
        purchasesTransactionsHeaderView.UploadedDocumentsID = returnPurchasesTransactionHeaderData!["UploadedDocumentsID"] as? String
        
        if purchasesTransactionsHeaderView.UploadedDocumentsID != nil {
            
            var imageDataStr = purchasesTransactionsHeaderView.LinkDocumentFile
            
            
            let imageData = NSData(base64EncodedString: imageDataStr!, options: NSDataBase64DecodingOptions(rawValue: 0))
            attachedimage = UIImage(data: imageData!)
            print("purchasesTransactionsHeaderView.UploadedDocumentsID" + purchasesTransactionsHeaderView.UploadedDocumentsID!)
        }
        else {
            print("purchasesTransactionsHeaderView.UploadedDocumentsID nil")
        }
        
        
        return  purchasesTransactionsHeaderView
    }
    
    func copyFromPurchasesTransactionsHeaderViewToPurchasesTransactionsHeader(purchasesTransactionsHeaderView:PurchasesTransactionsHeaderView)
    {
        purchasesTransactionHeader.ClosedDate = purchasesTransactionsHeaderView.ClosedDate
        purchasesTransactionHeader.CreateTime = purchasesTransactionsHeaderView.CreateTime
        purchasesTransactionHeader.DueDate = purchasesTransactionsHeaderView.DueDate
        purchasesTransactionHeader.HasLinkedDoc = purchasesTransactionsHeaderView.HasLinkedDoc
        purchasesTransactionHeader.IsDeleted = purchasesTransactionsHeaderView.IsDeleted
        purchasesTransactionHeader.LastModifiedTime = purchasesTransactionsHeaderView.LastModifiedTime
        purchasesTransactionHeader.Memo = purchasesTransactionsHeaderView.Memo
        purchasesTransactionHeader.PurchasesStatus = purchasesTransactionsHeaderView.PurchasesStatus
        purchasesTransactionHeader.PurchasesTransactionsHeaderID = purchasesTransactionsHeaderView.PurchasesTransactionsHeaderID
        purchasesTransactionHeader.PurchasesType = purchasesTransactionsHeaderView.PurchasesType
        purchasesTransactionHeader.ReferenceNo = purchasesTransactionsHeaderView.ReferenceNo
        purchasesTransactionHeader.ShipToAddress = purchasesTransactionsHeaderView.ShipToAddress
        purchasesTransactionHeader.SubTotal = purchasesTransactionsHeaderView.SubTotal
        purchasesTransactionHeader.SupplierID = purchasesTransactionsHeaderView.SupplierID
        purchasesTransactionHeader.SupplierInv = purchasesTransactionsHeaderView.SupplierInv
        purchasesTransactionHeader.TaxInclusive = purchasesTransactionsHeaderView.TaxInclusive
        purchasesTransactionHeader.TaxTotal = purchasesTransactionsHeaderView.TaxTotal
        purchasesTransactionHeader.TotalAmount = purchasesTransactionsHeaderView.TotalAmount
        purchasesTransactionHeader.TransactionDate = purchasesTransactionsHeaderView.TransactionDate
        
        purchasesTransactionHeader.SubTotal = purchasesTransactionHeader.TotalAmount - purchasesTransactionHeader.TaxTotal
         }
    func  sendGoBackFromPurchaseDetailMemoView(fromView : String ,forCell: String,Memo: String)
    {
        purchasesTransactionHeader.Memo = Memo
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.purchaseDetailTableView.reloadData()
            
        })
        
    }
  
    func sendGoBackFromSaleDetailDataLineView(fromView:String,forCell:String,salesTransactionsDetailView: SalesTransactionsDetailView)
    {}
    func sendGoBackFromSaleDetailDataLineInventorySearchView(fromView:String,forCell:String,inventoryView: InventoryView)
    {}
    func  sendGoBackFromSaleDetailDataLineDescriptionView(fromView : String ,forCell: String,Description: String)
    {}
    func  sendGoBackFromSaleDetailDataLineTaxCodeSearchView(fromView : String ,forCell: String,taxCodeView: TaxCodeView)
    {}
    
    func  sendGoBackFromSaleDetailDataLineAccountSearchView(fromView : String ,forCell: String,accountView: AccountView)
    {}
    
    
    func  sendGoBackFromSaleDetailMemoView(fromView : String ,forCell: String,Memo: String)
    {}
      func  sendGoBackFromCustomerSearchView(fromView : String ,forCell: String,Contact: Customer)
      {}
    //    func dataLoadCompletion(data:NSData?, response:NSURLResponse?, error:NSError?) -> AnyObject
    //    {
    //
    //
    //
    //
    //        var postDicData :[String:AnyObject]
    //        var IsLoginSuccessed : Bool
    //        do {
    //            postDicData = try  NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
    //
    ////
    ////            IsLoginSuccessed = postDicData["IsSuccessed"] as! Bool
    ////
    ////
    ////            if IsLoginSuccessed == true {
    ////
    ////                var q6CommonLib = Q6CommonLib()
    ////                var returnValue = postDicData["ReturnValue"]! as! Dictionary<String, AnyObject>
    ////
    ////                var companyID = returnValue["CompanyID"] as! String
    ////
    ////                //var json = try  NSJSONSerialization.JSONObjectWithData(dd as! NSData, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String, String>
    ////
    ////                let q6DBLib = Q6DBLib()
    ////
    ////
    ////                q6DBLib.addUserInfos(txtLoginEmail.text!, PassWord: txtLoginPassword.text!, LoginStatus: "Login",CompanyID: companyID)
    ////                //Set any attributes of the view controller before it is displayed, this is where you would set the category text in your code.
    ////
    ////                var passCode = q6DBLib.getUserPassCode()
    ////
    ////
    ////
    ////                if let passCodeViewController = storyboard!.instantiateViewControllerWithIdentifier("Q6PassCodeViewController") as? PassCodeViewController {
    ////
    ////                    if passCode == nil {
    ////
    ////                        passCodeViewController.ScreenMode = "CreatePassCode"
    ////                    }
    ////                    else {
    ////                        passCodeViewController.ScreenMode = "ValidatePassCode"
    ////                    }
    ////                    presentViewController(passCodeViewController, animated: true, completion: nil)
    ////                }
    ////                
    ////            }
    //            
    //            
    //        } catch  {
    //            print("error parsing response from POST on /posts")
    //            
    //            return ""
    //        }
    //        
    //        //
    //        return ""
    //    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
