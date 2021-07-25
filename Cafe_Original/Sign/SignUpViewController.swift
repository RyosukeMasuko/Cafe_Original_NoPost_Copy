//
//  SignUpViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/09.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class SignUpViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmTextField: UITextField!
    @IBOutlet var signUpImageView: UIImageView!
    @IBOutlet var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmTextField.delegate = self
        
        signUpImageView.layer.cornerRadius = signUpImageView.bounds.width / 5
        signUpImageView.layer.masksToBounds = true
        
        // 1.角丸設定
        // UIButtonの変数名.layer.cornerRadius = 角丸の大きさ
        signUpButton.layer.cornerRadius = 10
        // 2.影の設定
        // 影の濃さ
        signUpButton.layer.shadowOpacity = 0.7
        // 影のぼかしの大きさ
        signUpButton.layer.shadowRadius = 3
        // 影の色
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        signUpButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //閉じるコード
        textField.resignFirstResponder()
        return true
    }

    @IBAction func signup(){
        let user = NCMBUser()
        if userIdTextField.text!.count < 4{
            print("文字数が足りません")
            return //このリターンで下のコードは一切読み込まれなくなる
        }

        //userの名前   最後はオプショナル型だからアンラップ
        user.userName = userIdTextField.text!
        user.mailAddress = emailTextField.text!
        //打ち込んだパスが一致していたら
        if passwordTextField.text! == confirmTextField.text!{
            user.password = passwordTextField.text!
        }else{
            print("パスワードが一致していません。")
        }
        //ここからサインアップ
        user.signUpInBackground { (error) in
            if error != nil{
                print(error)
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            }else{
                //登録成功した場合、MainStoryBoardに進む

                //ストーリーボードの取得
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

