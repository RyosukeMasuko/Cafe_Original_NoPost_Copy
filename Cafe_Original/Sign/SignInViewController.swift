//
//  SignInViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/09.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var userPasswordTextField: UITextField!
    
    @IBOutlet var signInImageView: UIImageView!
    @IBOutlet var logInButton: UIButton!
        
        

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInImageView.layer.cornerRadius = signInImageView.bounds.width / 5
        signInImageView.layer.masksToBounds = true
        
        // 1.角丸設定
        // UIButtonの変数名.layer.cornerRadius = 角丸の大きさ
        logInButton.layer.cornerRadius = 10
        // 2.影の設定
        // 影の濃さ
        logInButton.layer.shadowOpacity = 0.7
        // 影のぼかしの大きさ
        logInButton.layer.shadowRadius = 3
        // 影の色
        logInButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        logInButton.layer.shadowOffset = CGSize(width: 5, height: 5)

    }
    
    //①
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func signIn(){
        
        if userIdTextField.text!.count > 0 && userPasswordTextField.text!.count > 0{
            //NCMBUser.logInWithUsername...   blookのところはもう一回押してエンターで、左にとりまuserと書いておく
            NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: userPasswordTextField.text!) { (user, error) in
                if error != nil{
                    print(error)
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    
                }else{
                    //ログイン成功  Signupのコードからコピペ
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    //これでvar windowと同じ役割を果たしている
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                    //登録成功したあとに   ログイン状態の保持
                    let ud = UserDefaults.standard
                    //ud.set(bool...　を選択
                    ud.set(true, forKey: "isLogin")
                    ud.synchronize()
                    
                    
                }
            }
            
        }
        
        
        
    }
    
    @IBAction func forgetPassword(){
        //置いておく
    }
    
    
}


