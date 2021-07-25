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

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    //次の画面で値を渡すためのインデックス
    var selectedIndex: Int!
    
    var homeImages = [HomeImage]()
    
    var string  = "全て"
    
    @IBOutlet var photoCollectionView : UICollectionView!
    @IBOutlet var categorySegmentControl : UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        //nib登録
        let nib = UINib(nibName: "PhotoCollectionViewCell", bundle: Bundle.main)
        photoCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        //レイアウト設定
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 3.0
        layout.minimumInteritemSpacing = 3.0
        layout.itemSize = CGSize(width: photoCollectionView.frame.width / 2 - 3 / 2, height: photoCollectionView.frame.width / 2 - 3 / 2)
        photoCollectionView.collectionViewLayout = layout
        
        loadTimeline(string: string)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTimeline(string: string)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //カスタムセルの取得
        let cell = photoCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell
        let imageUrl = homeImages[indexPath.row].imageUrl
        cell.photoImageView.kf.setImage(with: URL(string: imageUrl[0] as! String ))
        cell.nameLabel.text = homeImages[indexPath.row].text
        //UILabelの枠のサイズに合わせてフォントサイズを自動調整する方法
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func loadTimeline(string: String){
        print("string=",string)
        let query = NCMBQuery(className: "HomeImage")
        
        // 降順
        query?.order(byDescending: "createDate")
        
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
                    // 投稿の情報を取得
                    let imageUrl = postObject.object(forKey: "imageUrl") as! Array<Any>
                    let text = postObject.object(forKey: "text") as! String
                    let category = postObject.object(forKey: "category") as! String
                    // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてHomeImageクラスにセット
                    let homeImage = HomeImage(objectId: postObject.objectId, imageUrl: imageUrl, text: text, category: category)
                    // 配列に加える
                    if category.contains(string){
                        self.homeImages.append(homeImage)
                    }
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
        self.performSegue(withIdentifier: "toDetail", sender: nil)
        // 選択状態解除
        photoCollectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // segueのIDがtoDetailであれば
        if segue.identifier == "toDetail" {
            let detailViewController = segue.destination as! DetailViewController
            
            detailViewController.homeImageId = homeImages[selectedIndex].objectId
      }
    }
    
    //ホーム画面のジャンルごとに表示するためのセグメントコントロールボタンのアクション
    @IBAction func tapSegmentedIndex(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            self.string = "全て"
            loadTimeline(string: string)
            break
        case 1:
            self.string = "インスタ"
            loadTimeline(string: string)
            break
        case 2:
            self.string = "仕事・課題"
            loadTimeline(string: string)
            break
        default:
            break
        }
    }
    
    
    
    
    
}
