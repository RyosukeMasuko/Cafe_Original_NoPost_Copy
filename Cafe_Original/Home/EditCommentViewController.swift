//
//  EditCommentViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/10/04.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class EditCommentViewController: UIViewController {
    
    var reviewText: String!
    var objectId: String!
    
    @IBOutlet var reviewTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTextView.text = reviewText

    }
    
    @IBAction func update(){
        //　set.object　が値を入れる方法
        let query = NCMBQuery(className: "Review")
        query?.getObjectInBackground(withId: objectId, block: { (review, error) in
            if error != nil{
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
            }else{
                print(review)
                review?.setObject(self.reviewTextView.text, forKey: "text")
                review?.saveInBackground({ (error) in
                    if error != nil{
                        SVProgressHUD.showError(withStatus: error?.localizedDescription)
                    }else{
                        SVProgressHUD.dismiss()
                        self.navigationController?.popViewController(animated: true)
                    
                        
                    }
                })
                
            }
            
        })

    }
    
    
    @IBAction func cansel(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

    
}
