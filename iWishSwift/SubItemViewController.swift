//
//  SubItemViewController.swift
//  iWishSwift
//
//  Created by andycheng on 2016/11/4.
//  Copyright © 2016年 ccjeng. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "cell"

class SubItemViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var addButton: UIButton!
    
    let realmSubItem = RealmSubItem()
    var subItems:List<SubItem>!
    
    var editMode:Bool = false
    var tts:TextToSpeech!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        tts = TextToSpeech()
        addButton.isHidden = true
    }

    var label = ""
    var key = ""
    var mainKey = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = label
        mainKey = key

        //init data
        realmSubItem.initData(mainKey)
        
        subItems = realmSubItem.selectByItemId(mainKey)
    }
    
    @IBAction func addButtonTouchDown(_ sender: UIButton) {
        let addAlertController = UIAlertController(title: "新增", message: "", preferredStyle: .alert)
        
        addAlertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "內容"
        }
        
        let cancelAction = UIAlertAction( title: "取消", style: .cancel, handler: nil)
        addAlertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "儲存", style: .default) {
            (action: UIAlertAction!) -> Void in
            let textField = (addAlertController.textFields?.first!)! as UITextField
            
            self.realmSubItem.add(textField.text!, self.mainKey)
            
            self.collectionView?.reloadData()
        }
        addAlertController.addAction(saveAction)
        
        if editMode {
            self.present(addAlertController, animated: true, completion: nil)
        }
    }
    
    func editData(_ id:String, _ name:String){
        let editAlertController = UIAlertController(title: "修改", message: "", preferredStyle: .alert)
        
        editAlertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "內容"
            textField.text = name
        }
        
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        editAlertController.addAction(cancelAction)
        
        let editAction = UIAlertAction(title: "修改", style: .default) {
            (action: UIAlertAction!) -> Void in
            
            let textField = (editAlertController.textFields?.first!)! as UITextField
            self.realmSubItem.update(id, textField.text!)
            self.collectionView?.reloadData()
        }
        editAlertController.addAction(editAction)
        
        
        let deleteAction = UIAlertAction(title: "刪除", style: .destructive) {
            (action: UIAlertAction!) -> Void in
            
            self.realmSubItem.delete(id)
            self.collectionView?.reloadData()
        }
        editAlertController.addAction(deleteAction)
        
        self.present(editAlertController, animated: true, completion: nil)
        
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        if sender.isOn {
            editMode = true
            addButton.isHidden = false
        } else {
            editMode = false
            addButton.isHidden = true
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TextCell
        
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 3
        
        cell.label.text = subItems![indexPath.row].name
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subItems.count;
    }
    
    // set cell size
    // must set UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let nbCol = 4
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(nbCol - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(nbCol))
        return CGSize(width: size, height: 220)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var idName:String!
        var labelName:String!
        
        idName = subItems![indexPath.row].id
        labelName = subItems![indexPath.row].name
        
        if editMode {
            editData(idName, labelName)
        } else {
            tts.speak(label + labelName)
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.yellow
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.cyan
    }
    

}
