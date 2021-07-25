//
//  AddViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/15.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB

class AddViewController: UIViewController ,UITextViewDelegate ,UITextFieldDelegate{
    
    var latitude : Double!
    var longitude : Double!
    
    @IBOutlet var postTextField: UITextField!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postTextField.delegate = self
        postTextView.delegate = self
        
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    
    
    @IBAction func save(){
        let postObject = NCMBObject(className: "Map")
        postObject?.setObject(self.postTextField.text!, forKey: "text")
        postObject?.setObject(self.postTextView.text!, forKey: "subtext")
        postObject?.setObject(self.latitude, forKey: "latitude")
        postObject?.setObject(self.longitude, forKey: "longitude")
        
        postObject?.saveInBackground({ (error) in
            if error != nil{
                
            }else{
                //成功して戻る
                  self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    
    
    
}
