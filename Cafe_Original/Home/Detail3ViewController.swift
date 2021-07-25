//
//  DetailViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2020/09/21.
//  Copyright © 2020 Ryosuke4869. All rights reserved.
//

import UIKit
import NCMB
import SVProgressHUD
import Kingfisher
import Cosmos
import PopupDialog

class Detail3ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var commentArray = [NCMBObject]()
    
    @IBOutlet var introductionLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var moneyLabel: UILabel!
    @IBOutlet var webLabel: UILabel!
    @IBOutlet var topShopNameLabel: UILabel!
    @IBOutlet var streetAdressLabel: UILabel!
    @IBOutlet var selectedImageView: UIImageView!
    @IBOutlet var shadowButton: UIButton!
    @IBOutlet var shadow2Button: UIButton!
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var basicInfo: UILabel!
    
    //この2つはレビューのため
    @IBOutlet var reviewTableView: UITableView!
    var reviews = [Review]()
    var reviewRatings = [Double]()
    @IBOutlet var reviewCosmosView: CosmosView!
    @IBOutlet var reviewAverageLabel: UILabel!
    
    var homeImageId: String?
    var cafeInfos = [CafeInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //レビューのためのやつ
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        let nib = UINib(nibName: "ReviewTableViewCell", bundle: Bundle.main)
        reviewTableView.register(nib, forCellReuseIdentifier: "Cell")
        reviewTableView.tableFooterView = UIView()
        // tableViewを可変にする
        reviewTableView.estimatedRowHeight = 120
        reviewTableView.rowHeight = UITableView.automaticDimension
        
//        removeButton.isEnabled = false
        ConfigureShadowItem.button(shadowButton: shadowButton)
        ConfigureShadowItem.button(shadowButton: shadow2Button)
//        confirmContent()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCafeInfos()
        loadReviews()
//        confirmContent()
    }
    
    
    //レビューのtableViewのためのコード2つ
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ReviewTableViewCell
        let user = reviews[indexPath.row].user
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/jDdyNtvxGmt9wfqA /publicFiles/" + user.objectId
        cell.userIdLabel.text = user.userName
        cell.userNameLabel.text = user.displayName
        cell.reviewCosmosView.rating = reviews[indexPath.row].reviewRating
        cell.reviewLabel.text = reviews[indexPath.row].reviewText
        //cell.userImageView.kf.setImage(with: URL(string: userImageUrl))
        cell.userImageView.loadImageAsynchronously(url: URL(string: userImageUrl), defaultUIImage: UIImage(named: "Placeholder-human.png"))
        print(userImageUrl)
        
        
        return cell
    }
    //以下のコードもレビューのための関数
    //総和｜全体の各要素を足し合わせるだけ。
    func sum(_ array:[Double])->Double{
        return array.reduce(0,+)
    }
    
    //平均値｜全体の総和をその個数で割る。
    func average(_ array:[Double])->Double{
        return self.sum(array) / Double(array.count)
    }
    
    func loadReviews(){
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
        let query = NCMBQuery(className: "Review")
        query?.whereKey("homeImageId", equalTo: homeImageId)
        query?.includeKey("user")
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                // 初期化
                self.reviews = [Review]()
                self.reviewRatings = [Double]()
                
                for reviewObject in result as! [NCMBObject] {
                    // コメントをしたユーザーの情報を取得
                    let user = reviewObject.object(forKey: "user") as! NCMBUser
                    let userModel = User(objectId: user.objectId, userName: user.userName)
                    userModel.displayName = user.object(forKey: "displayName") as? String
                    
                    // コメントの文字を取得
                    let text = reviewObject.object(forKey: "text") as! String
                    let starRating = reviewObject.object(forKey: "starRating") as! Double
                    
                    // Reviewクラスに格納
                    let review = Review(objectId: reviewObject.objectId,user: userModel, reviewText: text, createDate: reviewObject.createDate, reviewRating: starRating)
                    self.reviews.append(review)
                    self.reviewRatings.append(review.reviewRating)
                    
                    // 平均算出
                    let averageReviewRating = self.average(self.reviewRatings)
                    // 四捨五入して小数点第二位まで表示
                    let roundAverageReviewRating = round(averageReviewRating * 100) / 100
                    // レビューの星数の平均を表示
                    self.reviewAverageLabel.text = String(roundAverageReviewRating)
                    self.reviewCosmosView.rating = roundAverageReviewRating
                    
                    // テーブルをリロード
                    self.reviewTableView.reloadData()
                }
            }
        })
    }
    func showCustomDialog(animated: Bool = true) {
        
        // Create a custom view controller
        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            //alertを閉じるだけ
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "RATE", height: 60) {
            
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
            
            
            
            // Save review
            //ここで初めてクラスのReviewを作っている reviewクラスの中にpostId的存在を作って、querlyのwherekeyでequal to 使って探す
            //これでおそらくひもづけはできる→次はコメントの削除→行った、行ってないの配列を追加してコレクションビューでうまいこと表示させる
            //自分のコメントが削除できるようにする→これでとりあえず。
            let object = NCMBObject(className: "Review")
            object?.setObject(self.homeImageId, forKey: "homeImageId")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.setObject(ratingVC.reviewTextField.text, forKey: "text")
            object?.setObject(ratingVC.cosmosStarRating.rating, forKey: "starRating")
            object?.saveInBackground({ (error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    // 保存したものを表示
                    self.loadReviews()
                }
            })
            //ここでRATEを押したら、インスタのいいねと同じようにgoneUserを新たに追加する。elseは書かないで解除ボタンも足す
            //その解除ボタンでニフクラのgoneUserだのwantToGoUserだのの配列を消すコードを書く
            //マイページのコレクションビューは、コレクションビュー上に星のボタンとかつけて押したら解除と同じ役割をするようにする
            
            //cafeInfosには、カフェの情報(一つのDetailViewControllerに載っているカフェ情報)が一つだから、[0]とする
            if self.cafeInfos[0].gone == false || self.cafeInfos[0].gone == nil{
                let query = NCMBQuery(className: "HomeImage")
                query?.getObjectInBackground(withId: self.cafeInfos[0].objectId, block: { (post, error) in
                    post?.addUniqueObject(currentUser.objectId, forKey: "goneUser")
                    post?.saveEventually({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadCafeInfos()
                        }
                    })
                })
            }
        }
        let buttonThree = DefaultButton(title: "コメントを書かない", height: 60){
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
            if self.cafeInfos[0].gone == false || self.cafeInfos[0].gone == nil{
                let query = NCMBQuery(className: "HomeImage")
                query?.getObjectInBackground(withId: self.cafeInfos[0].objectId, block: { (post, error) in
                    post?.addUniqueObject(currentUser.objectId, forKey: "goneUser")
                    post?.saveEventually({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadCafeInfos()
                        }
                    })
                })
            }
        }
        
        
        
        
        // Add buttons to dialog
        popup.addButtons([buttonOne,buttonThree, buttonTwo])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
    @IBAction func wantToGo(){
        if self.cafeInfos[0].wantToGo == false || self.cafeInfos[0].wantToGo == nil{
            let query = NCMBQuery(className: "HomeImage")
            query?.getObjectInBackground(withId: self.cafeInfos[0].objectId, block: { (post, error) in
                post?.addUniqueObject(NCMBUser.current().objectId, forKey: "wantToGoUser")
                post?.saveEventually({ (error) in
                    if error != nil {
                        SVProgressHUD.showError(withStatus: error!.localizedDescription)
                    } else {
                        self.loadCafeInfos()
                    }
                })
            })
        }
        
    }
    
    @IBAction func remove(){
        let query = NCMBQuery(className: "HomeImage")
        query?.getObjectInBackground(withId: cafeInfos[0].objectId, block: { (post, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                if post?.object(forKey: "goneUser") != nil{
                    post?.removeObjects(in: [NCMBUser.current().objectId], forKey: "goneUser")
                    post?.saveEventually({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadCafeInfos()
                        }
                    })
                    
                }
                if post?.object(forKey: "wantToGoUser") != nil{
                    post?.removeObjects(in: [NCMBUser.current().objectId], forKey: "wantToGoUser")
                    post?.saveEventually({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            self.loadCafeInfos()
                        }
                    })
                    
                }
                
            }
        })
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //アラートでコメントを削除できるようにする
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
            SVProgressHUD.show()
            let query = NCMBQuery(className: "Review")
            
            query?.getObjectInBackground(withId: self.reviews[indexPath.row].objectId, block: { (review, error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error!.localizedDescription)
                } else {
                    // 取得した投稿オブジェクトを削除
                    review?.deleteInBackground({ (error) in
                        if error != nil {
                            SVProgressHUD.showError(withStatus: error!.localizedDescription)
                        } else {
                            // 再読込
                            self.loadReviews()
                            SVProgressHUD.dismiss()
                        }
                    })
                }
            })
        }
        let updateAction = UIAlertAction(title: "編集する", style: .default) { (action) in
            
            self.performSegue(withIdentifier: "toEditComment", sender: nil)
            
        }
        
        
        //let reportAction = UIAlertAction(title: "報告する", style: .destructive) { (action) in
        //SVProgressHUD.showSuccess(withStatus: "この投稿を報告しました。ご協力ありがとうございました。")
        //}
        
        let reportAction = UIAlertAction(title: "報告する", style: .destructive) { (action) in
            let object = NCMBObject(className: "Report") //新たにクラス作る
            object?.setObject(self.reviews[indexPath.row].objectId, forKey: "reportId")
            object?.setObject(NCMBUser.current(), forKey: "user")
            object?.saveInBackground({ (error) in
                if error != nil {
                    SVProgressHUD.showError(withStatus: error?.localizedDescription)
                } else {
                    SVProgressHUD.showSuccess(withStatus: "この投稿を報告しました。ご協力ありがとうございました。")
                }
            })
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        if reviews[indexPath.row].user.objectId == NCMBUser.current().objectId {
            // 自分の投稿なので、削除ボタンを出す
            alertController.addAction(updateAction)
            alertController.addAction(deleteAction)
            
        } else {
            // 他人の投稿なので、報告ボタンを出す
            alertController.addAction(reportAction)
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面の取得 二つに別れてるので注意→　if文で
        if segue.identifier == "toEditComment"{
            //つなぐ
            let editCommentViewController = segue.destination as! EditCommentViewController
            //memoArrayに入ったデータのセルのインデックスを取得
            let selectedIndex = self.reviewTableView.indexPathForSelectedRow!
            //detailViewController.selectedMemoは、つないだ後の画面に変数selectedMemoを用意して、そこに代入する
            
            editCommentViewController.reviewText = self.reviews[selectedIndex.row].reviewText
            editCommentViewController.objectId = self.reviews[selectedIndex.row].objectId
            
        }
    }
    
    
    
    
    @IBAction func goneButton(){
        showCustomDialog()
    }
    
    //この上までがレビューに関して
    
    
    
    //ここがボタンを使えるか使えないか
//    func confirmContent(){
//        let query = NCMBQuery(className: "HomeImage")
//        query?.getObjectInBackground(withId: cafeInfos[0].objectId, block: { (result, error) in
//            if error != nil{
//                SVProgressHUD.showError(withStatus: error?.localizedDescription)
//            }else{
//                let resultObject = result?.object(forKey: "goneUser")
//                let resultObject2 = result?.object(forKey: "wantToGoUser")
//                if NCMBUser.current()?.objectId == resultObject as? String {
//                    self.removeButton.isEnabled = true
//                }else{
//                    self.removeButton.isEnabled = false
//                }
//                if NCMBUser.current()?.objectId == resultObject as? String{
//                    self.removeButton.isEnabled = true
//                }else{
//                    self.removeButton.isEnabled = false
//                }
//            }
//        })
////        if postImageView.image != placeholderImage && cafeNameTextView.text.count > 0{
////            postButton.isEnabled = true
////        }else{
////            postButton.isEnabled = false
////        }
//    }
    
    
    
    
    
    
    
    
    func loadCafeInfos() {
        
        let query = NCMBQuery(className: "HomeImage")
        query?.whereKey("objectId", equalTo: homeImageId)
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                SVProgressHUD.showError(withStatus: error!.localizedDescription)
            } else {
                
                self.cafeInfos = [CafeInfo]()
                
                for cafeInfoObject in result as! [NCMBObject] {
                    // コメントの文字を取得
                    let text = cafeInfoObject.object(forKey: "text") as! String
                    let basicInfo = cafeInfoObject.object(forKey: "basicInfo") as! String
                    let introduciton = cafeInfoObject.object(forKey: "introduction") as! String
                    let money = cafeInfoObject.object(forKey: "money") as! String
                    let time = cafeInfoObject.object(forKey: "time") as! String
                    let web = cafeInfoObject.object(forKey: "web") as! String
                    let phoneNumber = cafeInfoObject.object(forKey: "phoneNumber") as! String
                    let imageUrl = cafeInfoObject.object(forKey: "imageUrl") as! Array<Any>
                    let streetAdress = cafeInfoObject.object(forKey: "streetAdress") as! String
                    let geoPoint = cafeInfoObject.object(forKey: "geoPoint") as! NCMBGeoPoint
                    let category = cafeInfoObject.object(forKey: "category") as! String
                    
                    // Commentクラスに格納
                    //let cafeInfo = CafeInfo(objectId: cafeInfoObject.objectId, homeImageId: self.homeImageId, text: text, createDate: cafeInfoObject.createDate,basicInfo:basicInfo, introduction: introduciton,money: money,time: time,web: web,phoneNumber: phoneNumber)
                    let cafeInfo = CafeInfo(objectId: cafeInfoObject.objectId, basicInfo: basicInfo, introduction: introduciton, money: money, phoneNumber: phoneNumber, time: time, web: web,text: text, imageUrl: imageUrl, streetAdress: streetAdress, geoPoint: geoPoint, category: category)
                    
                    self.cafeInfos.append(cafeInfo)
                    
                    //ここに代入するコードを書く
                    self.introductionLabel.text = text
                    self.timeLabel.text = time
                    self.phoneNumberLabel.text = phoneNumber
                    self.moneyLabel.text = money
                    self.webLabel.text = web
                    self.navigationItem.title = text
                    self.selectedImageView.kf.setImage(with:URL(string: imageUrl[0] as! String))
                    self.streetAdressLabel.text = streetAdress
                    self.topShopNameLabel.text = text
                    self.basicInfo.text = basicInfo
                    //ラベル内に、文字を全て収める
                    self.timeLabel.adjustsFontSizeToFitWidth = true
                    self.webLabel.adjustsFontSizeToFitWidth = true
                    self.streetAdressLabel.adjustsFontSizeToFitWidth = true
                    self.topShopNameLabel.adjustsFontSizeToFitWidth = true
                    
                    
                    
                    
                    
                }
                
            }
        })
    }
    
    @IBAction func map(){
        
        performSegue(withIdentifier: "toPlacePoint", sender: nil)
        
    }
    
    
}

