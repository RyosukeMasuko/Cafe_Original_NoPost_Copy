//
//  MypageViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/16.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD

class MypageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var mypageArray = ["行ったカフェ","行ってみたいカフェ","ログアウト","退会"]
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var optionTableView : UITableView!
    //@IBOutlet var tableViewCellImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        optionTableView.delegate = self
        optionTableView.dataSource = self
        
        //セルの不要な線の削除
        optionTableView.tableFooterView = UIView()
        
        //画像の角丸
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
    }
    
    //アップロード画像をこっちでも出す
    override func viewWillAppear(_ animated: Bool) {
        if let user = NCMBUser.current(){
            nameLabel.text = user.object(forKey: "displayName") as? String
            idLabel.text = user.object(forKey: "userName") as? String
            let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
            file.getDataInBackground { (data, error) in
                if error != nil{
                    let alert = UIAlertController(title: "画像取得エラー", message: error!.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    if data != nil{
                        //getDataInBackground内のdataに情報があるから、それを表示
                        let image = UIImage(data: data!)
                        self.userImageView.image = image
                    }
                    
                }
            }
            
            
        }else{
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            //これでvar windowと同じ役割を果たしている
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            //登録成功したあとに   ログイン状態の保持
            let ud = UserDefaults.standard
            //ud.set(bool...　を選択
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
        }
    }
    
    
    
    
    //TableViewの必要な2つの関数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mypageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cellにアクセス？
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        //セルが元々持っているテキスト
        cell.textLabel?.text = mypageArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //セルの退会をタップした時の動作
        if indexPath.row == 3{
            let alert = UIAlertController(title: "会員登録の解除", message: "本当に退会しますか？退会した場合、再度このアカウントをご利用頂くことができません。", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                // ユーザーのアクティブ状態をfalseに
                if let user = NCMBUser.current() {
            //どのユーザーを削除するか
            //NCMBUser.current()と書くことで、どのユーザーが今ログインしているかがわかる
                    user.setObject(false, forKey: "active")
                    user.saveInBackground({ (error) in
                        if error != nil{
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        }else{
                            //ログアウト成功
                            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                            //これでvar windowと同じ役割を果たしている
                            UIApplication.shared.keyWindow?.rootViewController = rootViewController
                            
                            //ログアウト成功したあとに   ログアウト状態の保持
                            let ud = UserDefaults.standard
                            //ud.set(bool...　を選択
                            ud.set(false, forKey: "isLogin")
                            ud.synchronize()
                        }
                    })
                }
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else if indexPath.row == 2{
            //これはセルのログアウトをタップした時の動作
            let alert = UIAlertController(title: "ログアウト", message: "ログアウトしてもよろしいですか？", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                // ユーザーのアクティブ状態をfalseに
                if let user = NCMBUser.current() {
            //どのユーザーを削除するか
            //NCMBUser.current()と書くことで、どのユーザーが今ログインしているかがわかる
                    user.saveInBackground({ (error) in
                        if error != nil{
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        }else{
                            //ログアウト成功
                            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                            //これでvar windowと同じ役割を果たしている
                            UIApplication.shared.keyWindow?.rootViewController = rootViewController
                            
                            //ログアウト成功したあとに   ログアウト状態の保持
                            let ud = UserDefaults.standard
                            //ud.set(bool...　を選択
                            ud.set(false, forKey: "isLogin")
                            ud.synchronize()
                        }
                    })
                }
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }else if indexPath.row == 0{
            // 画面遷移
            
            self.performSegue(withIdentifier: "toGone", sender: nil)
            // 選択状態解除
            optionTableView.deselectRow(at: indexPath, animated: true)
        }else if indexPath.row == 1{
            self.performSegue(withIdentifier: "toWantToGo", sender: nil)
            optionTableView.deselectRow(at: indexPath, animated: true)
        }
        //セル選択解除
        optionTableView.deselectRow(at: indexPath, animated: true)
    }
    
    //選択したセルにかかれている文を値渡ししてナビゲーションタイトルに表示させるためのコード
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面の取得 二つに別れてるので注意→　if文で
        if segue.identifier == "toGone"{
            //つなぐ
            let goneViewController = segue.destination as! GoneViewController
            //memoArrayに入ったデータのセルのインデックスを取得
            let selectedIndex = optionTableView.indexPathForSelectedRow!
            //detailViewController.selectedMemoは、つないだ後の画面に変数selectedMemoを用意して、そこに代入する
            goneViewController.selectedTableViewText = mypageArray[selectedIndex.row]
            //print(mypageArray[selectedIndex.row])
        }else if segue.identifier == "toWantToGo"{
            //つなぐ
            let wantToGoViewController = segue.destination as! WantToGoViewController
            //memoArrayに入ったデータのセルのインデックスを取得
            let selectedIndex = optionTableView.indexPathForSelectedRow!
            //detailViewController.selectedMemoは、つないだ後の画面に変数selectedMemoを用意して、そこに代入する
            wantToGoViewController.selectedTableViewText = mypageArray[selectedIndex.row]
            //print(mypageArray[selectedIndex.row])
            
        }
        
    }
    
    
    
    
    
    
    
    //ログアウト
    @IBAction func logout() {
        NCMBUser.logOutInBackground ({ (error) in
            if error != nil{
                print(error)
            }else{
                //ログアウト成功
                let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                //これでvar windowと同じ役割を果たしている
                UIApplication.shared.keyWindow?.rootViewController = rootViewController
                
                //ログアウト成功したあとに   ログアウト状態の保持
                let ud = UserDefaults.standard
                //ud.set(bool...　を選択
                ud.set(false, forKey: "isLogin")
                ud.synchronize()
            }
        })
    }
    //退会
    @IBAction func delete() {
        let alert = UIAlertController(title: "会員登録の解除", message: "本当に退会しますか？退会した場合、再度このアカウントをご利用頂くことができません。", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            // ユーザーのアクティブ状態をfalseに
            if let user = NCMBUser.current() {
        //どのユーザーを削除するか
        //NCMBUser.current()と書くことで、どのユーザーが今ログインしているかがわかる
                user.setObject(false, forKey: "active")
                user.saveInBackground({ (error) in
                    if error != nil{
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    }else{
                        //ログアウト成功
                        let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                        //これでvar windowと同じ役割を果たしている
                        UIApplication.shared.keyWindow?.rootViewController = rootViewController
                        
                        //ログアウト成功したあとに   ログアウト状態の保持
                        let ud = UserDefaults.standard
                        //ud.set(bool...　を選択
                        ud.set(false, forKey: "isLogin")
                        ud.synchronize()
                    }
                })
            }
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    

}
