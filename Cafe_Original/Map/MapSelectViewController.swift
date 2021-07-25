//
//  MapSelectViewController.swift
//  Cafe_Original
//
//  Created by Ryosuke Masuko on 2021/07/02.
//  Copyright © 2021 Ryosuke4869. All rights reserved.
//

import UIKit

class MapSelectViewController: UIViewController {
    
    var selectName = ""
    var selectButtonNumber = 0
    
    @IBOutlet var mapButton: UIButton!
    @IBOutlet var map2Button: UIButton!
    @IBOutlet var map3Button: UIButton!
    @IBOutlet var map4Button: UIButton!
    @IBOutlet var map5Button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapButton.layer.cornerRadius = 15
        map2Button.layer.cornerRadius = 15
        map3Button.layer.cornerRadius = 15
        map4Button.layer.cornerRadius = 15
        map5Button.layer.cornerRadius = 15
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("selectName=", selectName )
        if selectName != "toSelect"{
            let mapViewController = segue.destination as! Map2ViewController
            mapViewController.selectedButton = selectButtonNumber
        }else{
            let mapViewController = segue.destination as! MapTapSelectViewController
        }
        
        
    }
    
    
    
    @IBAction func toAll(){
        selectButtonNumber = 0
        selectName = "toAll"
        performSegue(withIdentifier: "toCategory", sender: nil)
    }
    
    @IBAction func toInsta(){
        selectButtonNumber = 1
        selectName = "toInsta"
        performSegue(withIdentifier: "toCategory", sender: nil)
    }
    
    @IBAction func toWork(){
        selectButtonNumber = 2
        selectName = "toWork"
        performSegue(withIdentifier: "toCategory", sender: nil)
    }
    
    @IBAction func toRest(){
        performSegue(withIdentifier: "toCategory", sender: nil)
        selectButtonNumber = 3
        selectName = "toRest"
    }
    
    @IBAction func toSelect(){
        selectName = "toSelect"
        performSegue(withIdentifier: "toSelect", sender: nil)
    }



}
