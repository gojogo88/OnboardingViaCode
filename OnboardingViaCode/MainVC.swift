//
//  ViewController.swift
//  OnboardingViaCode
//
//  Created by Jonathan Go on 2017/10/22.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let CELLID = "cellId"
    let LOGINCELLID = "loginCellId"
    
    let pages: [Page] = {
        let firstPage = Page(title: "Share A Great Listen", message: "Its free to send your books to the people in your life. Every recipient's first book is on us.", imageName: "page1")
        let secondPage = Page(title: "Send from your library", message: "Tap the more menu next to any book. Choose \"Send this Book\"", imageName: "page2")
        let thirdPage = Page(title: "Send from the Player", message: "Tap the more menu in the upper corner. Choose \"Send this book\"", imageName: "page3")
        return [firstPage, secondPage, thirdPage]
    }()
    
    //lazy var to make self accessible
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor =  UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        pc.numberOfPages = self.pages.count + 1
        return pc
    }()
    
    lazy var skipBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    @objc func skip() {
        pageControl.currentPage = pages.count - 1
        nextPage()
    }
    
    lazy var nextBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    @objc func nextPage() {
        //we are on the last page
        if pageControl.currentPage == pages.count {
            return
        }
        
        //secont to the last page
        if pageControl.currentPage == pages.count - 1 {
            moveControlConstraintsOffScreen()
        
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    var pageControlBtmAnchor: NSLayoutConstraint?
    var skipBtnTopAnchor: NSLayoutConstraint?
    var nextBtnTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeKeyboardNotifications()
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipBtn)
        view.addSubview(nextBtn)
        
        pageControlBtmAnchor = pageControl.anchor(nil, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1]
       
        skipBtnTopAnchor = skipBtn.anchor(view.topAnchor, left: view.leadingAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        nextBtnTopAnchor = nextBtn.anchor(view.topAnchor, left: nil, bottom: nil, right: view.trailingAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        collectionView.anchorToTop(view.topAnchor, left: view.leadingAnchor, bottom: view.bottomAnchor, right: view.trailingAnchor)
        
        registerCells()
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100 : -50
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
        
    }
    
    @objc func hideKeyboard() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)  //dismiss the keyboard when going back to previous page
    }
    
    //to highlight page in pagecontrol
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        //we are on the last page before login
        if pageNumber == pages.count {
            moveControlConstraintsOffScreen()
        } else {
            //back on regular pages
            pageControlBtmAnchor?.constant = 0
            skipBtnTopAnchor?.constant = 16
            nextBtnTopAnchor?.constant = 16
        }
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func moveControlConstraintsOffScreen() {
        pageControlBtmAnchor?.constant = 40
        skipBtnTopAnchor?.constant = -40
        nextBtnTopAnchor?.constant = -40
    }

    fileprivate func registerCells() {
        collectionView.register(OnboardingPageCell.self, forCellWithReuseIdentifier: CELLID)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: LOGINCELLID)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == pages.count {
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: LOGINCELLID, for: indexPath)
            return loginCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELLID, for: indexPath) as! OnboardingPageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }

    //screen rotation
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        //print(UIDevice.current.orientation.isLandscape)
        collectionView.collectionViewLayout.invalidateLayout()
        
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        
        //scroll to indexPath after the rotation is going
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
    }
    
}
