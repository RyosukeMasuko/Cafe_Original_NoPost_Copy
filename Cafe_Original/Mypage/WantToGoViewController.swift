//
//  HomeViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/16.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB
import NYXImagesKit
import SVProgressHUD
import Kingfisher

class WantToGoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    //次の画面で値を渡すためのインデックス
    var selectedIndex: Int!
    var selectedTableViewText: String!
    
    var homeImages = [HomeImage]()
    
//    let cafeNames = ["しろくまカフェ","白ヤギコーヒー","椿屋カフェ","上島珈琲","エクセルシオールカフェ"]
//    let cafeImages = [UIImage(named: "shirokuma.png"), UIImage(named: "siriyagi.jpg") , UIImage(named: "tsubakiya.jpg"), UIImage(named: "ueshima.jpg"),UIImage(named: "excelsior.jpg")]
    
    @IBOutlet var photoCollectionView : UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        //nib登録
        let nib = UINib(nibName: "GonePhotoCollectionViewCell", bundle: Bundle.main)
        photoCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        //レイアウト設定
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3.0
        layout.minimumInteritemSpacing = 3.0
        layout.itemSize = CGSize(width: photoCollectionView.frame.width / 2 - 3 / 2, height: photoCollectionView.frame.width / 2 - 3 / 2)
        photoCollectionView.collectionViewLayout = layout
        
        loadTimeline()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = selectedTableViewText
        loadTimeline()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //カスタムセルの取得
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GonePhotoCollectionViewCell
        let imageUrl = homeImages[indexPath.row].imageUrl
        cell.photoImageView.kf.setImage(with: URL(string: imageUrl[0] as! String))
        cell.nameLabel.text = homeImages[indexPath.row].text
        //let user = posts[indexPath.row].user
        //let userImageUrl = "https://console.mbaas.nifcloud.com/#/applications/jDdyNtvxGmt9wfqA" + user.objectId

        
//        cell.photoImageView.image = cafeNames[indexPath.row] as? UIImage
//        cell.nameLabel.text = cafeNames[indexPath.row]
        
        return cell
    }
    
    func loadTimeline(){
        
        guard let currentUser = NCMBUser.current() else {
            // ログインに戻る
            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            // ログインしていない状態の保持(AppDelegateの"isLogin"の宣言より)
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            
            return
        }
        
        
        let query = NCMBQuery(className: "HomeImage")
        
//        //Userの情報も取ってくる
//        query?.includeKey("user")
        
        // 降順
        query?.order(byDescending: "createDate")
        
//        // 投稿したユーザーの情報も同時取得
//        query?.includeKey("user")
        
        
        //付け足したところ
        query?.whereKey("wantToGoUser", equalTo: currentUser.objectId)
        // オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
                print(result)
            } else {
                print(result)
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.homeImages = [HomeImage]()
                
                for postObject in result as! [NCMBObject] {
                    // ユーザー情報をUserクラスにセット
                    //let cafeInfo = postObject.object(forKey: "cafeInfo") as! NCMBUser
                    
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
//                    if user.object(forKey: "active") as? Bool != false {
//                        // 投稿したユーザーの情報をUserモデルにまとめる
//                    let cafeInfoModel = CafeInfo(objectId: cafeInfo.objectId,)
                        //cafeInfoModel.introduction = cafeInfo.object(forKey: "introduction") as? String
                        
                        // 投稿の情報を取得
                        let imageUrl = postObject.object(forKey: "imageUrl")
                        let text = postObject.object(forKey: "text") as! String
                        let category = postObject.object(forKey: "category") as! String
                        
                    
                        
                        // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてHomeImageクラスにセット
                    let homeImage = HomeImage(objectId: postObject.objectId, imageUrl: imageUrl as! Array<Any>, text: text, category: category)
                        
                        // 配列に加える
                        self.homeImages.append(homeImage)
//                    }
                }
                
                // 投稿のデータが揃ったらTableViewをリロード
                self.photoCollectionView.reloadData()
            }
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // どこの(何番目の)cellが押されたか記録
        selectedIndex = indexPath.row
        // 画面遷移
        self.performSegue(withIdentifier: "toDetail3", sender: nil)
        // 選択状態解除
        photoCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // segueのIDがtoDetailであれば
        if segue.identifier == "toDetail3" {
            let detailViewController = segue.destination as! Detail3ViewController
            
            detailViewController.homeImageId = homeImages[selectedIndex].objectId
            

            
        }
    }
    
    
    

    

}

