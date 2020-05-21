//
//  Swipe.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 08/05/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class OnboardingPagerViewController: UIViewController {
    
    let storyboardIDs = [ "Onboarding1",
                          "Onboarding2",
                          "Onboarding3",
                          "Onboarding4",
                          "Onboarding5",
                          "Onboarding6",
                          "Onboarding7", ]
    
    lazy var vcs: [UIViewController] = {
        var vc = [UIViewController]()
        
        for i in 0..<storyboardIDs.count {
            let id = storyboardIDs[i]
            vc.append(UIStoryboard(name: id, bundle: nil).instantiateViewController(identifier: "vc"))
        }
        
        return vc
    }()
    
    var initialContentOffset = CGPoint()
    var scrollView: UIScrollView!
    
    var pgControl = UIPageControl()
    var currentPage = 0 {
        didSet {
            pgControl.currentPage = currentPage
        }
    }
    var widthPage: CGFloat = 0
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHorizontalScrollView()
        
        setupPageControl()
        
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap() {
        let currentOffset = self.scrollView.contentOffset
        let newOffset = CGPoint(x: currentOffset.x + self.widthPage, y: currentOffset.y)
        
        guard newOffset.x <= widthPage * CGFloat(vcs.count) - 1 else {
            UserDefaults.standard.set(true, forKey: "onboardingWasDisplayed")
            performSegue(withIdentifier: "projects", sender: self)
            return
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.contentOffset = newOffset
        }, completion: nil)
    }
    
    func setupPageControl() {
        pgControl.pageIndicatorTintColor = .lightGray
        pgControl.currentPageIndicatorTintColor = .white
        pgControl.numberOfPages = vcs.count
        pgControl.removeFromSuperview()
        view.addSubview(pgControl)

        pgControl.translatesAutoresizingMaskIntoConstraints = false
        pgControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        pgControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }
    
    func setupHorizontalScrollView() {
        
        let cWidth = self.view.bounds.width
        let cHeight = self.view.bounds.height
        let countVC = CGFloat(vcs.count)
        
        widthPage = cWidth
        
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        
        self.scrollView!.frame = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: cWidth, height: cHeight)
        self.view.addSubview(scrollView)
        
        let scrollWidth: CGFloat  = countVC * cWidth
        let scrollHeight: CGFloat  = cHeight
        self.scrollView!.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        for i in 0..<self.vcs.count {
            
            vcs[i].view.frame = CGRect(x: CGFloat(i) * cWidth, y: 0, width: cWidth, height: cHeight)

            self.scrollView!.addSubview(vcs[i].view)
            
            if(i == self.vcs.count - 1){
                vcs[i].didMove(toParent: self)
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
            
        for i in 0..<vcs.count {
            if xOffset == width * CGFloat(i) {
                currentPage = i
                break
            }
        }
    }
}
