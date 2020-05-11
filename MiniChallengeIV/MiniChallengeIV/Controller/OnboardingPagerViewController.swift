//
//  Swipe.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 08/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

//protocol OnboardingPagerViewControllerDelegate {
//    func innerScrollViewShouldScroll() -> Bool
//}

class OnboardingPagerViewController: UIViewController {
    
    var vc = [UIViewController]()
    let viewControllersID = [ "step1","step2","step3","step4","step5","step6" ]
    
    var initialContentOffset = CGPoint()  // scrollView initial offset
    var scrollView: UIScrollView!
//    var delegate: OnboardingPagerViewControllerDelegate?
    
    var pgControl = UIPageControl()
    var currentPage = 0 {
        didSet {
            pgControl.currentPage = currentPage
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for vcID in viewControllersID {
            let vc = storyboard!.instantiateViewController(withIdentifier: vcID)
            self.vc.append(vc)
        }
        
        setupHorizontalScrollView()
        
        setupPageControl()
    }
    
    func setupPageControl() {
        pgControl.pageIndicatorTintColor = .lightGray
        pgControl.currentPageIndicatorTintColor = .white
        pgControl.numberOfPages = vc.count
        pgControl.removeFromSuperview()
        view.addSubview(pgControl)

        pgControl.translatesAutoresizingMaskIntoConstraints = false
        pgControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pgControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    func setupHorizontalScrollView() {
        
        let cWidth = self.view.bounds.width
        let cHeight = self.view.bounds.height
        let countVC = CGFloat(vc.count)
        
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        
        self.scrollView!.frame = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: cWidth, height: cHeight)
        self.view.addSubview(scrollView)
        
        let scrollWidth: CGFloat  = countVC * cWidth
        let scrollHeight: CGFloat  = cHeight
        self.scrollView!.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        for i in 0..<self.vc.count {
            
            vc[i].view.frame = CGRect(x: CGFloat(i) * cWidth, y: 0, width: cWidth, height: cHeight)
//            self.addChild(vc[i])
            self.scrollView!.addSubview(vc[i].view)
            
            if(i == self.vc.count - 1){
                vc[i].didMove(toParent: self)
            }
            
        }
        
        self.scrollView!.delegate = self;
    }
}

// MARK: UIScrollView Delegate
extension OnboardingPagerViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let width = view.bounds.width
            
        for i in 0..<vc.count {
            if xOffset == width * CGFloat(i) {
                currentPage = i
                break
            }
        }
        
//        if delegate != nil && !delegate!.innerScrollViewShouldScroll() {
//            // This is probably crazy movement: diagonal scrolling
//            var newOffset = CGPoint()
//
//            if (abs(scrollView.contentOffset.x) > abs(scrollView.contentOffset.y)) {
//                newOffset = CGPoint(x: self.initialContentOffset.x, y: self.initialContentOffset.y)
//            } else {
//                newOffset = CGPoint(x: self.initialContentOffset.x, y: self.initialContentOffset.y)
//            }
//
//            // Setting the new offset to the scrollView makes it behave like a proper
//            // directional lock, that allows you to scroll in only one direction at any given time
//            self.scrollView!.setContentOffset(newOffset,animated:  false)
//        }
    }
}
