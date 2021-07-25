//
//  PostViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/20.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NYXImagesKit
import NCMB
import SVProgressHUD
import UITextView_Placeholder

class PostViewController: UIViewController ,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    let placeholderImage = UIImage(named: "Placeholder-human.png")
    var resizedImage: UIImage!
    
    @IBOutlet var postImageView: UIImageView!
    @IBOutlet var cafeNameTextView: UITextView!
    @IBOutlet var introductionTextView: UITextView!
    @IBOutlet var timeTextView: UITextView!
    @IBOutlet var phoneNumberTextView: UITextView!
    @IBOutlet var webUrlTextView: UITextView!
    @IBOutlet var equalMoneyTextView: UITextView!
    @IBOutlet var basicInfoTextView: UITextView!
    @IBOutlet var streetAdressTextView: UITextView!
    
    @IBOutlet var postButton: UIBarButtonItem!
    
    //Map
    var placeLatitude: Double!
    var placeLongitude: Double!
    @IBOutlet var mapTitleTextView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postImageView.image = placeholderImage
        postButton.isEnabled = false
        cafeNameTextView.delegate = self
        
        introductionTextView.delegate = self
        timeTextView.delegate = self
        phoneNumberTextView.delegate = self
        webUrlTextView.delegate = self
        equalMoneyTextView.delegate = self
        basicInfoTextView.delegate = self
        streetAdressTextView.delegate = self
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        resizedImage = selectedImage.scale(byFactor: 1.0)
        postImageView.image = resizedImage
        picker.dismiss(animated: true, completion: nil)
        confirmContent()
    }
    func textViewDidChange(_ textView: UITextView) {
        confirmContent()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    @IBAction func selectedImage(){
        let alertController = UIAlertController(title: "画像の選択", message: "画像を選択してください。", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            // カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではカメラが使用出来ません。")
            }
        }
        let photoLibraryAction = UIAlertAction(title: "フォトライブラリから選択", style: .default) { (action) in
            // アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            } else {
                print("この機種ではフォトライブラリが使用出来ません。")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func sharePhotoButton(){
        SVProgressHUD.show()
        // 撮影した画像をデータ化したときに右に90度回転してしまう問題の解消
        UIGraphicsBeginImageContext(resizedImage.size)
        let rect = CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
        resizedImage.draw(in: rect)
        resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let data = resizedImage.pngData()
        let file = NCMBFile.file(with: data) as! NCMBFile
        file.saveInBackground({ (error) in
            if error != nil{
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(title: "画像アップロードエラー", message: "error!.localizedDescription", preferredStyle: .actionSheet)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }else{
                let postObject = NCMBObject(className: "HomeImage")
                //Map
                let geoPoint = NCMBGeoPoint(latitude: self.placeLatitude, longitude: self.placeLongitude)
                if self.cafeNameTextView.text.count == 0{
                    print("入力されていません。")
                    return
                }
                postObject?.setObject(self.cafeNameTextView.text, forKey: "text")
                postObject?.setObject(self.introductionTextView.text, forKey: "introduction")
                postObject?.setObject(self.timeTextView.text, forKey: "time")
                postObject?.setObject(self.phoneNumberTextView.text, forKey: "phoneNumber")
                postObject?.setObject(self.webUrlTextView.text, forKey: "web")
                postObject?.setObject(self.equalMoneyTextView.text, forKey: "money")
                postObject?.setObject(self.basicInfoTextView.text, forKey: "basicInfo")
                postObject?.setObject(self.streetAdressTextView.text, forKey: "streetAdress")
                //postObject?.setObject(NCMBUser.current(), forKey: "user")
                let url = "https://mbaas.api.nifcloud.com/2013-09-01/applications/jDdyNtvxGmt9wfqA/publicFiles/" + file.name
                postObject?.setObject(url, forKey: "imageUrl")
                //Map
                postObject?.setObject(geoPoint, forKey: "geoPoint")
                postObject?.saveInBackground({ (error) in
                    if error != nil{
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    }else{
                        SVProgressHUD.dismiss()
                        self.postImageView.image = nil
                        self.postImageView.image = UIImage(named: "Placeholder-human")
                        self.cafeNameTextView.text = nil
                        
                        //追加
                        self.introductionTextView.text = nil
                        self.timeTextView.text = nil
                        self.phoneNumberTextView.text = nil
                        self.webUrlTextView.text = nil
                        self.equalMoneyTextView.text = nil
                        self.basicInfoTextView.text = nil
                        self.streetAdressTextView.text = nil
                        //Map
                        self.placeLatitude = nil
                        self.placeLongitude = nil
                        
                        self.tabBarController?.selectedIndex = 0
                    }
                })
            }
    }) { (progress) in
        print(progress)
    }
}
    
    
    
    
    func confirmContent(){
        if postImageView.image != placeholderImage && cafeNameTextView.text.count > 0{
            postButton.isEnabled = true
        }else{
            postButton.isEnabled = false
        }
    }
    
    @IBAction func cancel() {
        if cafeNameTextView.isFirstResponder == true {
            cafeNameTextView.resignFirstResponder()
        }
        
        let alert = UIAlertController(title: "投稿内容の破棄", message: "入力中の投稿内容を破棄しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.cafeNameTextView.text = nil
            self.postImageView.image = UIImage(named: "photo-placeholder")
            self.confirmContent()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }





}
