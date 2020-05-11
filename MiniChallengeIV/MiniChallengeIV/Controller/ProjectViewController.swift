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
    var projectBO = ProjectBO()
    var projects: [Project] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadList()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    @IBAction func addProjectButtonAction(_ sender: Any) {
        goToNewProjectViewController()
    }
    
    @IBAction func showStatistics(_ sender: Any) {
        performSegue(withIdentifier: "statistics", sender: nil)
    }
    
    /// Go to NewProjectViewController
    private func goToNewProjectViewController() {
        if let newProjectVC = UIStoryboard.loadView(from: .NewProject, identifier: .NewProjectID) as? NewProjectViewController {
            newProjectVC.modalTransitionStyle = .crossDissolve
            newProjectVC.modalPresentationStyle = .overCurrentContext
            newProjectVC.delegate = self
            
            if let selectedProjectId = selectedProjectId {
                newProjectVC.project = projects[selectedProjectId]
                self.selectedProjectId = nil
            }
            
            self.present(newProjectVC, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToTimer" {
            if let timerViewController = segue.destination as? TimerViewController {
                guard let index = selectedProjectId else {return}
                //pass projects id to timer
                timerViewController.timeTracker.projectUuid = projects[index].id
            }
        }
    }
}

extension ProjectViewController: NewProjectViewControllerDelegate {
    func reloadList(){
        projectBO.retrieve(completion: { result in
            switch result {
            case .success(let projects):
                self.projects = projects
                collectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
            
        }
    }
    
    extension ProjectViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            selectedProjectId = indexPath.item
            //        goToNewProjectViewController()
            performSegue(withIdentifier: "GoToTimer", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let destinationVC = segue.destination as! TimerViewController
            guard let row = selectedProjectId else {
                return
            }
            destinationVC.id = projects[row].id
        }
    }

    
    extension ProjectViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            //        return ProjectDAO.list.count
            return projects.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ProjectCollectionViewCell else {
                return ProjectCollectionViewCell()
            }
            
            cell.projectNameLabel.text = projects[indexPath.row].name
            cell.backgroundColor = projects[indexPath.row].color
            
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
