//
//  ProjectViewController.swift
//  MiniChallengeIV
//
//  Created by Murilo Teixeira on 29/04/20.
//  Copyright © 2020 Murilo Teixeira. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedProjectId: Int?
            
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    @IBAction func addProjectButtonAction(_ sender: Any) {
        goToNewProjectViewController()
    }
    
    /// Go to NewProjectViewController
    private func goToNewProjectViewController() {
        if let newProjectVC = UIStoryboard.loadView(from: .NewProject, identifier: .NewProjectID) as? NewProjectViewController {
            newProjectVC.modalTransitionStyle = .crossDissolve
            newProjectVC.modalPresentationStyle = .overCurrentContext
            newProjectVC.delegate = self
            
            if let selectedProjectId = selectedProjectId {
                newProjectVC.projectBean = ProjectDAO.list[selectedProjectId]
                self.selectedProjectId = nil
            }
            
            self.present(newProjectVC, animated: true)
        }
    }
}

extension ProjectViewController: NewProjectViewControllerDelegate {
    func reloadList() {
        collectionView.reloadData()
    }
}

extension ProjectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedProjectId = indexPath.item
//        goToNewProjectViewController()
        performSegue(withIdentifier: "GoToTimer", sender: self)
    }
}

extension ProjectViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProjectDAO.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProjectCollectionViewCell else {
            return ProjectCollectionViewCell()
        }
        
        cell.projectNameLabel.text = ProjectDAO.list[indexPath.row].name
        
        return cell
    }
}

extension ProjectViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 8, bottom: 10, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth * 0.475, height: collectionViewWidth * 0.45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
