//
//  ViewController.swift
//  ApiProject_Tutorial
//
//  Created by 김동환 on 2021/03/23.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    let sgmArray = ["사진검색", "사용자검색"]
    var segmentedControl: UISegmentedControl!
    var keyboardDismissTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSegmentedCtl()
        setSearchBar()
        
        
        keyboardDismissTapGesture.delegate = self
        view.addGestureRecognizer(keyboardDismissTapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShowHandlingView), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideHandlingView), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    
    //MARK: - segSgmCtl
    fileprivate func setSegmentedCtl(){
        
        segmentedControl = UISegmentedControl(items: sgmArray)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setImage(UIImage(systemName: "photo"), forSegmentAt: 0)
        segmentedControl.setImage(UIImage(systemName: "person.fill"), forSegmentAt: 1)
        segmentedControl.addTarget(self, action: #selector(changePlaceHolder), for: .valueChanged)
    }
    
    //MARK: - Set Search bar
    
    fileprivate func setSearchBar(){
        searchBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20).isActive = true
        searchBtn.layer.cornerRadius = 10
        searchBar.placeholder = "사진 키워드 입력"
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
    }
    
    @objc fileprivate func changePlaceHolder(){
        
        if segmentedControl.selectedSegmentIndex == 0 {
            searchBar.placeholder = "사진 키워드 입력"
        } else {
            searchBar.placeholder = "사용자 이름 입력"
        }
    }
    
    
    //MARK: - searchBar delegate func
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchBartxt = searchBar.text else {return}
        
        if searchBartxt.isEmpty{
            self.view.makeToast("📢검색 키워드를 입력해주세요", duration: 3.0, position: .center)
        }
        segueFunc(index: segmentedControl.selectedSegmentIndex)
    }
    
    func segueFunc(index: Int){
        switch index {
        case 0:
            performSegue(withIdentifier: K.PHOTO_COLLECTION, sender: self)
        case 1:
            performSegue(withIdentifier: K.USER_LIST, sender: self)
        default:
            print("no segue")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == K.PHOTO_COLLECTION {
            if let text = searchBar.text {
                
                guard let photoCollectionVC = segue.destination as? PhotoCollectionViewController else {
                    return
                }
                photoCollectionVC.titleText = text
            }
        } else {
            if let text = searchBar.text {
                guard let userListVC = segue.destination as? UserListViewController else {
                    return
                }
                userListVC.titleText = text
            }
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = searchBar.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        
        let updateText = currentText.replacingCharacters(in: stringRange, with: text)
        print(updateText.count)
        if updateText.count == 13 {
            
            self.view.makeToast("📢12자까지만 입력가능합니다", duration: 3.0, position: .center)
        }
        
        return updateText.count < 13
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBtn.isHidden = false
    }
    
//MARK: - searchBtnClicked
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        
        segueFunc(index: segmentedControl.selectedSegmentIndex)
    }
    
    
    //MARK: - TapGesture func
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if ((touch.view?.isDescendant(of: segmentedControl)) == true) {
            return false
        } else if (touch.view?.isDescendant(of: searchBar)) == true {
            return false
        } else {
            view.endEditing(true)
            return true
        }
    }
    
    //MARK: - Keyboard hide and show
    
    @objc fileprivate func keyboardShowHandlingView(notification: NSNotification){
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            if searchBtn.frame.origin.y > keyboardSize.height {
                print("y is bigger")
            }
            
        }
    }
    
    @objc fileprivate func keyboardHideHandlingView(){
        self.view.frame.origin.y = 0
    }
    
}


