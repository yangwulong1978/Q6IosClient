//
//  SaleDetailMemoViewController.swift
//  Q6IosClient
//
//  Created by yang wulong on 10/06/2016.
//  Copyright © 2016 q6. All rights reserved.
//

import UIKit

class SaleDetailMemoViewController: UIViewController ,UITextViewDelegate{

    
    @IBOutlet weak var memoTextView: UITextView!
    
    var fromCell = String()
    weak var delegate : Q6GoBackFromView?
    var strMemo = String()
    
    var textValue = ""
    
    override func viewWillAppear(animated: Bool) {
        
        if textValue != ""
        {
            memoTextView.text = textValue
            memoTextView.textColor = UIColor.blackColor()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        memoTextView.delegate = self
        // descriptionTextView.becomeFirstResponder()
        //descriptionTextView.text = "ffffddddddddd"
        setControlAppear()
        //descriptionTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
        
        if textValue != ""
        {
            memoTextView.text = textValue
        }
        
    }
    
    @IBAction func CancelButtonClicked(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    @IBAction func DoneButtonClicked(sender: AnyObject) {
        
        if memoTextView.textColor == UIColor.lightGrayColor()
        {
            strMemo = ""
        }
        else {
            strMemo = memoTextView.text
        }
        
        self.delegate?.sendGoBackFromSaleDetailMemoView("SaleDetailMemoViewController", forCell: "MemoCell", Memo: strMemo)
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    func setControlAppear()
    {
        var strMemo = memoTextView.text
        
        if strMemo == "" {
            
            
            
            
            memoTextView.text = "Memo"
            memoTextView.textColor = UIColor.lightGrayColor()
        }
        //
        //        descriptionTextView.selectedTextRange = descriptionTextView.textRangeFromPosition(descriptionTextView.beginningOfDocument, toPosition: descriptionTextView.beginningOfDocument)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() && textView.text == "Memo" {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
        
        memoTextView.selectedTextRange = memoTextView.textRangeFromPosition(memoTextView.beginningOfDocument, toPosition: memoTextView.beginningOfDocument)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        //        if textView.text.isEmpty {
        //            textView.text = "Description"
        //            textView.textColor = UIColor.lightGrayColor()
        //        }
    }
    
    //    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    //
    //        // Combine the textView text and the replacement text to
    //        // create the updated text string
    //        let currentText:NSString = descriptionTextView.text
    //        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
    //
    //        // If updated text view will be empty, add the placeholder
    //        // and set the cursor to the beginning of the text view
    //        if updatedText.isEmpty {
    //
    //            textView.text = "Description"
    //            textView.textColor = UIColor.lightGrayColor()
    //
    //           textView.selectedTextRange = descriptionTextView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
    //
    //            return false
    //        }
    //
    //            // Else if the text view's placeholder is showing and the
    //            // length of the replacement string is greater than 0, clear
    //            // the text view and set its color to black to prepare for
    //            // the user's entry
    //        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
    //            textView.text = ""
    //            textView.textColor = UIColor.blackColor()
    //        }
    //
    //        return true
    //    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        //        if self.view.window != nil {
        //           // print("textView 's length" + textView.text.length.description)
        //            if textView.textColor == UIColor.lightGrayColor() {
        //                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
        //            }
        //        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
