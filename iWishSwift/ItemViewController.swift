//
//  ItemViewController.swift
//  iWishSwift
//
//  Created by andycheng on 2016/11/4.
//  Copyright © 2016年 ccjeng. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "cell"

class ItemViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    let realmItem = RealmItem()
    var items:Results<Item>!
    
    var editMode:Bool = false
    var tts:TextToSpeech!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        tts = TextToSpeech()
    }

    var label = ""
    var key = ""
    var mainKey = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = label
        mainKey = key
        items = realmItem.selectAll()
    }
    
    @IBAction func swithChanged(_ sender: UISwitch) {
        if sender.isOn {
            editMode = true
        } else {
            editMode = false
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TextCell
        
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 3
        
        cell.label.text = items![indexPath.row].name
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count;
    }
    
    // set cell size
    // must set UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nbCol = 4
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(nbCol - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(nbCol))
        return CGSize(width: size, height: 200)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var idName:String!
        var labelName:String!
        
        idName = items![indexPath.row].id
        labelName = items![indexPath.row].name
        
        if editMode {
           // editData(idName, labelName)
        } else {
            tts.speak(label + labelName)
        }
        
        //  performSegue(withIdentifier:"category", sender: self)
        
    }
}
