//
//  UserinfoEditViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/17.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit

class UserinfoEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameTextField: UITextField!
    @IBOutlet var userIdTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        userIdTextField.delegate = self
        
        if let user = NCMBUser.current() {
            //⑯  userpageviewcontrollerからのコピペでやる
            userNameTextField.text = user.object(forKey: "displayName") as? String
            userIdTextField.text = user.userName


            //⑬ UserPageViewControllerからのコピペ
            let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil{
                    print(error)
                }else{
                    if data != nil{
                        //getDataInBackground内のdataに情報があるから、それを表示
                        let image = UIImage(data: data!)
                        self.userImageView.image = image
                    }
                }
            }
        }else{
            //nilであったら下のコードが読み込まれる
            //ログアウト成功
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            //これでvar windowと同じ役割を果たしている
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            //登録成功したあとに   ログイン状態の保持
            let ud = UserDefaults.standard
            //ud.set(bool...　を選択
            ud.set(true, forKey: "isLogin")
            ud.synchronize()
        }
        //⑬
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
    }//ここまでが名前とIDの値渡し
    
    
    //テキストフィールド使う時に必要
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    //カメラ、フォトライブラリを出す時のコード
    @IBAction func selectedImage() {
        let actionController = UIAlertController(title: "画像の選択", message: "画像を選択してください。", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true{
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }else{
                print("この機種ではカメラを起動することができません。")
            }
        }
        
        let alubumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true{
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }else{
                print("この機種ではフォトライブラリを使用することができません。")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            
        }
        actionController.addAction(cameraAction)
        actionController.addAction(alubumAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let resizedImage = selectedImage.scale(byFactor: 0.3)
        //ここから続き　多分niftycloudの会員とかからんでくるからここで書くのやめた
        picker.dismiss(animated: true, completion: nil)
        //画像アップロード
        let data = UIImage.pngData(resizedImage!)
        let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: data()) as! NCMBFile
        file.saveInBackground({ (error) in
            if error != nil{
                print(error)
            }else{
                self.userImageView.image = selectedImage
            }
        }) { (progress) in
            print(progress)
        }
    }
    
    
    //キャンセルボタン
    @IBAction func closeEditViewController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveUserInfo(){
        let user = NCMBUser.current()
        user?.setObject(userNameTextField.text, forKey:"displayName")
        user?.setObject(userIdTextField.text, forKey: "userName")
        user?.saveInBackground({ (error) in
            if error != nil{
                print(error)
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    

}

